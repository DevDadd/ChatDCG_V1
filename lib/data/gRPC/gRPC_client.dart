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

/// Logs every call to the debug console. Incoming stream messages are not
/// logged one by one; only when the stream opens and how it ends.
class _LoggingInterceptor extends ClientInterceptor {
  void _log(String message) => log(message, name: 'gRPC');

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final watch = Stopwatch()..start();
    _log('--> ${method.path} ${options.metadata}\n$request');
    final response = invoker(method, request, options);
    response.then(
      (value) => _log(
        '<-- ${method.path} OK (${watch.elapsedMilliseconds}ms)\n$value',
      ),
      onError: (Object e) => _log(
        '<-- ${method.path} FAILED (${watch.elapsedMilliseconds}ms) $e',
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
    _log('==> ${method.path} stream open ${options.metadata}');
    final response = invoker(
      method,
      requests.map((request) {
        _log('--> ${method.path}\n$request');
        return request;
      }),
      options,
    );
    response.trailers.then(
      (_) => _log(
        '<== ${method.path} stream closed (${watch.elapsedMilliseconds}ms)',
      ),
      onError: (Object e) => _log(
        '<== ${method.path} stream FAILED (${watch.elapsedMilliseconds}ms) $e',
      ),
    );
    return response;
  }
}
