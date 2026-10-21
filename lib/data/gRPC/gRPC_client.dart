import 'dart:async';
import 'dart:developer';

import 'package:chatdcg_demo/generated/chat.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';

class GrpcClient {
  GrpcClient({required String host, required int port})
    : _channel = ClientChannel(
        host,
        port: port,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      );

  final ClientChannel _channel;

  Int64? userId;

  late final ChatServiceClient chat = ChatServiceClient(
    _channel,
    interceptors: [
      _UserIdInterceptor(this),
      // Last so it logs the final metadata, including x-user-id
      if (kDebugMode) _LoggingInterceptor(),
    ],
  );
}

class _UserIdInterceptor extends ClientInterceptor {
  _UserIdInterceptor(this._client);

  final GrpcClient _client;

  CallOptions _withUserId(CallOptions options) {
    final id = _client.userId;
    if (id == null) return options;
    return options.mergedWith(CallOptions(metadata: {'x-user-id': '$id'}));
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) => invoker(method, request, _withUserId(options));

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) => invoker(method, requests, _withUserId(options));
}

/// Logs every call to the debug console: requests, responses, and for
/// streams when they open, each message both ways, and how they end.
class _LoggingInterceptor extends ClientInterceptor {
  void _log(String message) => log(message, name: 'gRPC');

  // interceptStreaming gets every non-unary call and ClientMethod does not say
  // which kind, so it comes from chat.proto. Update when an RPC is added.
  static const _streamKinds = {
    '/chat.ChatService/StreamMessages': 'Server stream',
    '/chat.ChatService/SubscribeTyping': 'Server stream',
    '/chat.ChatService/Presence': 'Server stream',
    '/chat.ChatService/SyncMessages': 'Client stream',
    '/chat.ChatService/Chat': 'Bidi stream',
  };

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final watch = Stopwatch()..start();
    _log('[Unary] --> ${method.path} ${options.metadata}\n$request');
    final response = invoker(method, request, options);
    response.then(
      (value) => _log(
        '[Unary] <-- ${method.path} OK (${watch.elapsedMilliseconds}ms)\n$value',
      ),
      onError: (Object e) => _log(
        '[Unary] <-- ${method.path} FAILED (${watch.elapsedMilliseconds}ms) $e',
      ),
    );
    return response;
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    final watch = Stopwatch()..start();
    final kind = '[${_streamKinds[method.path] ?? 'Stream'}]';
    _log('$kind ==> ${method.path} stream open ${options.metadata}');
    final response = invoker(
      method,
      requests.map((request) {
        _log('$kind --> ${method.path}\n$request');
        return request;
      }),
      options,
    );
    response.trailers.then(
      (_) => _log(
        '$kind <== ${method.path} stream closed (${watch.elapsedMilliseconds}ms)',
      ),
      onError: (Object e) => _log(
        '$kind <== ${method.path} stream FAILED (${watch.elapsedMilliseconds}ms) $e',
      ),
    );
    return _LoggedResponseStream(
      response,
      (message) => _log('$kind <-- ${method.path}\n$message'),
    );
  }
}

/// ResponseStream that logs each message the server sends. The original is
/// single-subscription and can only be built by grpc itself, so this wraps it
/// instead of listening twice.
class _LoggedResponseStream<R> extends StreamView<R>
    implements ResponseStream<R> {
  _LoggedResponseStream(this._inner, void Function(R message) onMessage)
    : super(
        _inner.map((message) {
          onMessage(message);
          return message;
        }),
      );

  final ResponseStream<R> _inner;

  @override
  Future<Map<String, String>> get headers => _inner.headers;

  @override
  Future<Map<String, String>> get trailers => _inner.trailers;

  @override
  Future<void> cancel() => _inner.cancel();

  @override
  ResponseFuture<R> get single => _inner.single;
}
