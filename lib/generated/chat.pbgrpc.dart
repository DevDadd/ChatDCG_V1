// This is a generated file - do not edit.
//
// Generated from chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chat.pb.dart' as $0;

export 'chat.pb.dart';

@$pb.GrpcServiceName('chat.ChatService')
class ChatServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ChatServiceClient(super.channel, {super.options, super.interceptors});

  /// No x-user-id needed: these return the id to send on every other call
  $grpc.ResponseFuture<$0.AuthResponse> register(
    $0.RegisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$register, request, options: options);
  }

  $grpc.ResponseFuture<$0.AuthResponse> login(
    $0.LoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$login, request, options: options);
  }

  /// Marks the caller offline and ends their open streams on every device
  $grpc.ResponseFuture<$0.LogoutResponse> logout(
    $0.LogoutRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$logout, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUsersStatusResponse> getUsersStatus(
    $0.GetUsersStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUsersStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.SendMessageResponse> sendMessage(
    $0.SendMessageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.SendTypingStatusResponse> sendTypingStatus(
    $0.SendTypingStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendTypingStatus, request, options: options);
  }

  $grpc.ResponseStream<$0.TypingEvent> subscribeTyping(
    $0.SubscribeTypingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribeTyping, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.ChatMessage> streamMessages(
    $0.StreamMessagesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$streamMessages, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.SyncMessagesResponse> syncMessages(
    $async.Stream<$0.SendMessageRequest> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$syncMessages, request, options: options)
        .single;
  }

  $grpc.ResponseStream<$0.ChatMessage> chat(
    $async.Stream<$0.ChatClientMessage> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$chat, request, options: options);
  }

  /// Open right after Login/Register and keep open while the app runs: the
  /// caller stays online while it is open, and receives other users'
  /// online/offline changes.
  $grpc.ResponseStream<$0.PresenceEvent> presence(
    $0.PresenceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$presence, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$register =
      $grpc.ClientMethod<$0.RegisterRequest, $0.AuthResponse>(
          '/chat.ChatService/Register',
          ($0.RegisterRequest value) => value.writeToBuffer(),
          $0.AuthResponse.fromBuffer);
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.AuthResponse>(
      '/chat.ChatService/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      $0.AuthResponse.fromBuffer);
  static final _$logout =
      $grpc.ClientMethod<$0.LogoutRequest, $0.LogoutResponse>(
          '/chat.ChatService/Logout',
          ($0.LogoutRequest value) => value.writeToBuffer(),
          $0.LogoutResponse.fromBuffer);
  static final _$getUsersStatus =
      $grpc.ClientMethod<$0.GetUsersStatusRequest, $0.GetUsersStatusResponse>(
          '/chat.ChatService/GetUsersStatus',
          ($0.GetUsersStatusRequest value) => value.writeToBuffer(),
          $0.GetUsersStatusResponse.fromBuffer);
  static final _$sendMessage =
      $grpc.ClientMethod<$0.SendMessageRequest, $0.SendMessageResponse>(
          '/chat.ChatService/SendMessage',
          ($0.SendMessageRequest value) => value.writeToBuffer(),
          $0.SendMessageResponse.fromBuffer);
  static final _$sendTypingStatus = $grpc.ClientMethod<
          $0.SendTypingStatusRequest, $0.SendTypingStatusResponse>(
      '/chat.ChatService/SendTypingStatus',
      ($0.SendTypingStatusRequest value) => value.writeToBuffer(),
      $0.SendTypingStatusResponse.fromBuffer);
  static final _$subscribeTyping =
      $grpc.ClientMethod<$0.SubscribeTypingRequest, $0.TypingEvent>(
          '/chat.ChatService/SubscribeTyping',
          ($0.SubscribeTypingRequest value) => value.writeToBuffer(),
          $0.TypingEvent.fromBuffer);
  static final _$streamMessages =
      $grpc.ClientMethod<$0.StreamMessagesRequest, $0.ChatMessage>(
          '/chat.ChatService/StreamMessages',
          ($0.StreamMessagesRequest value) => value.writeToBuffer(),
          $0.ChatMessage.fromBuffer);
  static final _$syncMessages =
      $grpc.ClientMethod<$0.SendMessageRequest, $0.SyncMessagesResponse>(
          '/chat.ChatService/SyncMessages',
          ($0.SendMessageRequest value) => value.writeToBuffer(),
          $0.SyncMessagesResponse.fromBuffer);
  static final _$chat =
      $grpc.ClientMethod<$0.ChatClientMessage, $0.ChatMessage>(
          '/chat.ChatService/Chat',
          ($0.ChatClientMessage value) => value.writeToBuffer(),
          $0.ChatMessage.fromBuffer);
  static final _$presence =
      $grpc.ClientMethod<$0.PresenceRequest, $0.PresenceEvent>(
          '/chat.ChatService/Presence',
          ($0.PresenceRequest value) => value.writeToBuffer(),
          $0.PresenceEvent.fromBuffer);
}

@$pb.GrpcServiceName('chat.ChatService')
abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'chat.ChatService';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.AuthResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.AuthResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.AuthResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.AuthResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LogoutRequest, $0.LogoutResponse>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LogoutRequest.fromBuffer(value),
        ($0.LogoutResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUsersStatusRequest,
            $0.GetUsersStatusResponse>(
        'GetUsersStatus',
        getUsersStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetUsersStatusRequest.fromBuffer(value),
        ($0.GetUsersStatusResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SendMessageRequest, $0.SendMessageResponse>(
            'SendMessage',
            sendMessage_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SendMessageRequest.fromBuffer(value),
            ($0.SendMessageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SendTypingStatusRequest,
            $0.SendTypingStatusResponse>(
        'SendTypingStatus',
        sendTypingStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SendTypingStatusRequest.fromBuffer(value),
        ($0.SendTypingStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SubscribeTypingRequest, $0.TypingEvent>(
        'SubscribeTyping',
        subscribeTyping_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.SubscribeTypingRequest.fromBuffer(value),
        ($0.TypingEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StreamMessagesRequest, $0.ChatMessage>(
        'StreamMessages',
        streamMessages_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.StreamMessagesRequest.fromBuffer(value),
        ($0.ChatMessage value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SendMessageRequest, $0.SyncMessagesResponse>(
            'SyncMessages',
            syncMessages,
            true,
            false,
            ($core.List<$core.int> value) =>
                $0.SendMessageRequest.fromBuffer(value),
            ($0.SyncMessagesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ChatClientMessage, $0.ChatMessage>(
        'Chat',
        chat,
        true,
        true,
        ($core.List<$core.int> value) => $0.ChatClientMessage.fromBuffer(value),
        ($0.ChatMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PresenceRequest, $0.PresenceEvent>(
        'Presence',
        presence_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.PresenceRequest.fromBuffer(value),
        ($0.PresenceEvent value) => value.writeToBuffer()));
  }

  $async.Future<$0.AuthResponse> register_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RegisterRequest> $request) async {
    return register($call, await $request);
  }

  $async.Future<$0.AuthResponse> register(
      $grpc.ServiceCall call, $0.RegisterRequest request);

  $async.Future<$0.AuthResponse> login_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LoginRequest> $request) async {
    return login($call, await $request);
  }

  $async.Future<$0.AuthResponse> login(
      $grpc.ServiceCall call, $0.LoginRequest request);

  $async.Future<$0.LogoutResponse> logout_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LogoutRequest> $request) async {
    return logout($call, await $request);
  }

  $async.Future<$0.LogoutResponse> logout(
      $grpc.ServiceCall call, $0.LogoutRequest request);

  $async.Future<$0.GetUsersStatusResponse> getUsersStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUsersStatusRequest> $request) async {
    return getUsersStatus($call, await $request);
  }

  $async.Future<$0.GetUsersStatusResponse> getUsersStatus(
      $grpc.ServiceCall call, $0.GetUsersStatusRequest request);

  $async.Future<$0.SendMessageResponse> sendMessage_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SendMessageRequest> $request) async {
    return sendMessage($call, await $request);
  }

  $async.Future<$0.SendMessageResponse> sendMessage(
      $grpc.ServiceCall call, $0.SendMessageRequest request);

  $async.Future<$0.SendTypingStatusResponse> sendTypingStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SendTypingStatusRequest> $request) async {
    return sendTypingStatus($call, await $request);
  }

  $async.Future<$0.SendTypingStatusResponse> sendTypingStatus(
      $grpc.ServiceCall call, $0.SendTypingStatusRequest request);

  $async.Stream<$0.TypingEvent> subscribeTyping_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SubscribeTypingRequest> $request) async* {
    yield* subscribeTyping($call, await $request);
  }

  $async.Stream<$0.TypingEvent> subscribeTyping(
      $grpc.ServiceCall call, $0.SubscribeTypingRequest request);

  $async.Stream<$0.ChatMessage> streamMessages_Pre($grpc.ServiceCall $call,
      $async.Future<$0.StreamMessagesRequest> $request) async* {
    yield* streamMessages($call, await $request);
  }

  $async.Stream<$0.ChatMessage> streamMessages(
      $grpc.ServiceCall call, $0.StreamMessagesRequest request);

  $async.Future<$0.SyncMessagesResponse> syncMessages(
      $grpc.ServiceCall call, $async.Stream<$0.SendMessageRequest> request);

  $async.Stream<$0.ChatMessage> chat(
      $grpc.ServiceCall call, $async.Stream<$0.ChatClientMessage> request);

  $async.Stream<$0.PresenceEvent> presence_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PresenceRequest> $request) async* {
    yield* presence($call, await $request);
  }

  $async.Stream<$0.PresenceEvent> presence(
      $grpc.ServiceCall call, $0.PresenceRequest request);
}
