// This is a generated file - do not edit.
//
// Generated from chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'account', '3': 1, '4': 1, '5': 9, '10': 'account'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert.base64Decode(
    'Cg9SZWdpc3RlclJlcXVlc3QSGAoHYWNjb3VudBgBIAEoCVIHYWNjb3VudBIaCghwYXNzd29yZB'
    'gCIAEoCVIIcGFzc3dvcmQSGgoIdXNlcm5hbWUYAyABKAlSCHVzZXJuYW1lEiEKDGRpc3BsYXlf'
    'bmFtZRgEIAEoCVILZGlzcGxheU5hbWU=');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'account', '3': 1, '4': 1, '5': 9, '10': 'account'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSGAoHYWNjb3VudBgBIAEoCVIHYWNjb3VudBIaCghwYXNzd29yZBgCIA'
    'EoCVIIcGFzc3dvcmQ=');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor =
    $convert.base64Decode('Cg1Mb2dvdXRSZXF1ZXN0');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert
    .base64Decode('Cg5Mb2dvdXRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use userInfoDescriptor instead')
const UserInfo$json = {
  '1': 'UserInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'account', '3': 2, '4': 1, '5': 9, '10': 'account'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
  ],
};

/// Descriptor for `UserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoDescriptor = $convert.base64Decode(
    'CghVc2VySW5mbxIOCgJpZBgBIAEoA1ICaWQSGAoHYWNjb3VudBgCIAEoCVIHYWNjb3VudBIaCg'
    'h1c2VybmFtZRgDIAEoCVIIdXNlcm5hbWUSIQoMZGlzcGxheV9uYW1lGAQgASgJUgtkaXNwbGF5'
    'TmFtZQ==');

@$core.Deprecated('Use authResponseDescriptor instead')
const AuthResponse$json = {
  '1': 'AuthResponse',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.chat.UserInfo', '10': 'user'},
  ],
};

/// Descriptor for `AuthResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authResponseDescriptor = $convert.base64Decode(
    'CgxBdXRoUmVzcG9uc2USIgoEdXNlchgBIAEoCzIOLmNoYXQuVXNlckluZm9SBHVzZXI=');

@$core.Deprecated('Use getUsersStatusRequestDescriptor instead')
const GetUsersStatusRequest$json = {
  '1': 'GetUsersStatusRequest',
};

/// Descriptor for `GetUsersStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsersStatusRequestDescriptor =
    $convert.base64Decode('ChVHZXRVc2Vyc1N0YXR1c1JlcXVlc3Q=');

@$core.Deprecated('Use userStatusDescriptor instead')
const UserStatus$json = {
  '1': 'UserStatus',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'is_online', '3': 4, '4': 1, '5': 8, '10': 'isOnline'},
    {'1': 'last_seen', '3': 5, '4': 1, '5': 9, '10': 'lastSeen'},
  ],
};

/// Descriptor for `UserStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userStatusDescriptor = $convert.base64Decode(
    'CgpVc2VyU3RhdHVzEhcKB3VzZXJfaWQYASABKANSBnVzZXJJZBIaCgh1c2VybmFtZRgCIAEoCV'
    'IIdXNlcm5hbWUSIQoMZGlzcGxheV9uYW1lGAMgASgJUgtkaXNwbGF5TmFtZRIbCglpc19vbmxp'
    'bmUYBCABKAhSCGlzT25saW5lEhsKCWxhc3Rfc2VlbhgFIAEoCVIIbGFzdFNlZW4=');

@$core.Deprecated('Use getUsersStatusResponseDescriptor instead')
const GetUsersStatusResponse$json = {
  '1': 'GetUsersStatusResponse',
  '2': [
    {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.chat.UserStatus',
      '10': 'users'
    },
  ],
};

/// Descriptor for `GetUsersStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsersStatusResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRVc2Vyc1N0YXR1c1Jlc3BvbnNlEiYKBXVzZXJzGAEgAygLMhAuY2hhdC5Vc2VyU3RhdH'
        'VzUgV1c2Vycw==');

@$core.Deprecated('Use getConversationHistoryRequestDescriptor instead')
const GetConversationHistoryRequest$json = {
  '1': 'GetConversationHistoryRequest',
  '2': [
    {'1': 'other_user_id', '3': 1, '4': 1, '5': 3, '10': 'otherUserId'},
  ],
};

/// Descriptor for `GetConversationHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConversationHistoryRequestDescriptor =
    $convert.base64Decode(
        'Ch1HZXRDb252ZXJzYXRpb25IaXN0b3J5UmVxdWVzdBIiCg1vdGhlcl91c2VyX2lkGAEgASgDUg'
        'tvdGhlclVzZXJJZA==');

@$core.Deprecated('Use getConversationHistoryResponseDescriptor instead')
const GetConversationHistoryResponse$json = {
  '1': 'GetConversationHistoryResponse',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.chat.ChatMessage',
      '10': 'messages'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `GetConversationHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConversationHistoryResponseDescriptor =
    $convert.base64Decode(
        'Ch5HZXRDb252ZXJzYXRpb25IaXN0b3J5UmVzcG9uc2USLQoIbWVzc2FnZXMYASADKAsyES5jaG'
        'F0LkNoYXRNZXNzYWdlUghtZXNzYWdlcxIfCgt0b3RhbF9jb3VudBgCIAEoBVIKdG90YWxDb3Vu'
        'dA==');

@$core.Deprecated('Use sendMessageRequestDescriptor instead')
const SendMessageRequest$json = {
  '1': 'SendMessageRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 3, '10': 'conversationId'},
    {'1': 'sender_id', '3': 2, '4': 1, '5': 3, '10': 'senderId'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'client_timestamp_ms',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'clientTimestampMs'
    },
  ],
};

/// Descriptor for `SendMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendMessageRequestDescriptor = $convert.base64Decode(
    'ChJTZW5kTWVzc2FnZVJlcXVlc3QSJwoPY29udmVyc2F0aW9uX2lkGAEgASgDUg5jb252ZXJzYX'
    'Rpb25JZBIbCglzZW5kZXJfaWQYAiABKANSCHNlbmRlcklkEhgKB2NvbnRlbnQYAyABKAlSB2Nv'
    'bnRlbnQSLgoTY2xpZW50X3RpbWVzdGFtcF9tcxgEIAEoA1IRY2xpZW50VGltZXN0YW1wTXM=');

@$core.Deprecated('Use sendMessageResponseDescriptor instead')
const SendMessageResponse$json = {
  '1': 'SendMessageResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'message_id', '3': 3, '4': 1, '5': 3, '10': 'messageId'},
  ],
};

/// Descriptor for `SendMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendMessageResponseDescriptor = $convert.base64Decode(
    'ChNTZW5kTWVzc2FnZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGAoHbWVzc2'
    'FnZRgCIAEoCVIHbWVzc2FnZRIdCgptZXNzYWdlX2lkGAMgASgDUgltZXNzYWdlSWQ=');

@$core.Deprecated('Use sendTypingStatusRequestDescriptor instead')
const SendTypingStatusRequest$json = {
  '1': 'SendTypingStatusRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 3, '10': 'conversationId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 3, '10': 'userId'},
    {'1': 'is_typing', '3': 3, '4': 1, '5': 8, '10': 'isTyping'},
  ],
};

/// Descriptor for `SendTypingStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendTypingStatusRequestDescriptor = $convert.base64Decode(
    'ChdTZW5kVHlwaW5nU3RhdHVzUmVxdWVzdBInCg9jb252ZXJzYXRpb25faWQYASABKANSDmNvbn'
    'ZlcnNhdGlvbklkEhcKB3VzZXJfaWQYAiABKANSBnVzZXJJZBIbCglpc190eXBpbmcYAyABKAhS'
    'CGlzVHlwaW5n');

@$core.Deprecated('Use sendTypingStatusResponseDescriptor instead')
const SendTypingStatusResponse$json = {
  '1': 'SendTypingStatusResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `SendTypingStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendTypingStatusResponseDescriptor =
    $convert.base64Decode(
        'ChhTZW5kVHlwaW5nU3RhdHVzUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use subscribeTypingRequestDescriptor instead')
const SubscribeTypingRequest$json = {
  '1': 'SubscribeTypingRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 3, '10': 'conversationId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 3, '10': 'userId'},
  ],
};

/// Descriptor for `SubscribeTypingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscribeTypingRequestDescriptor =
    $convert.base64Decode(
        'ChZTdWJzY3JpYmVUeXBpbmdSZXF1ZXN0EicKD2NvbnZlcnNhdGlvbl9pZBgBIAEoA1IOY29udm'
        'Vyc2F0aW9uSWQSFwoHdXNlcl9pZBgCIAEoA1IGdXNlcklk');

@$core.Deprecated('Use typingEventDescriptor instead')
const TypingEvent$json = {
  '1': 'TypingEvent',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 3, '10': 'conversationId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 3, '10': 'userId'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'is_typing', '3': 5, '4': 1, '5': 8, '10': 'isTyping'},
    {'1': 'timestamp', '3': 6, '4': 1, '5': 9, '10': 'timestamp'},
  ],
};

/// Descriptor for `TypingEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List typingEventDescriptor = $convert.base64Decode(
    'CgtUeXBpbmdFdmVudBInCg9jb252ZXJzYXRpb25faWQYASABKANSDmNvbnZlcnNhdGlvbklkEh'
    'cKB3VzZXJfaWQYAiABKANSBnVzZXJJZBIaCgh1c2VybmFtZRgDIAEoCVIIdXNlcm5hbWUSIQoM'
    'ZGlzcGxheV9uYW1lGAQgASgJUgtkaXNwbGF5TmFtZRIbCglpc190eXBpbmcYBSABKAhSCGlzVH'
    'lwaW5nEhwKCXRpbWVzdGFtcBgGIAEoCVIJdGltZXN0YW1w');

@$core.Deprecated('Use chatMessageDescriptor instead')
const ChatMessage$json = {
  '1': 'ChatMessage',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 3, '10': 'messageId'},
    {'1': 'conversation_id', '3': 2, '4': 1, '5': 3, '10': 'conversationId'},
    {'1': 'sender_id', '3': 3, '4': 1, '5': 3, '10': 'senderId'},
    {'1': 'sender_name', '3': 4, '4': 1, '5': 9, '10': 'senderName'},
    {'1': 'content', '3': 5, '4': 1, '5': 9, '10': 'content'},
    {'1': 'timestamp', '3': 6, '4': 1, '5': 9, '10': 'timestamp'},
  ],
};

/// Descriptor for `ChatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVzc2FnZRIdCgptZXNzYWdlX2lkGAEgASgDUgltZXNzYWdlSWQSJwoPY29udmVyc2'
    'F0aW9uX2lkGAIgASgDUg5jb252ZXJzYXRpb25JZBIbCglzZW5kZXJfaWQYAyABKANSCHNlbmRl'
    'cklkEh8KC3NlbmRlcl9uYW1lGAQgASgJUgpzZW5kZXJOYW1lEhgKB2NvbnRlbnQYBSABKAlSB2'
    'NvbnRlbnQSHAoJdGltZXN0YW1wGAYgASgJUgl0aW1lc3RhbXA=');

@$core.Deprecated('Use streamMessagesRequestDescriptor instead')
const StreamMessagesRequest$json = {
  '1': 'StreamMessagesRequest',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 3, '10': 'conversationId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 3, '10': 'userId'},
  ],
};

/// Descriptor for `StreamMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamMessagesRequestDescriptor = $convert.base64Decode(
    'ChVTdHJlYW1NZXNzYWdlc1JlcXVlc3QSJwoPY29udmVyc2F0aW9uX2lkGAEgASgDUg5jb252ZX'
    'JzYXRpb25JZBIXCgd1c2VyX2lkGAIgASgDUgZ1c2VySWQ=');

@$core.Deprecated('Use syncMessagesResponseDescriptor instead')
const SyncMessagesResponse$json = {
  '1': 'SyncMessagesResponse',
  '2': [
    {'1': 'received_count', '3': 1, '4': 1, '5': 5, '10': 'receivedCount'},
    {'1': 'failed_count', '3': 2, '4': 1, '5': 5, '10': 'failedCount'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SyncMessagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncMessagesResponseDescriptor = $convert.base64Decode(
    'ChRTeW5jTWVzc2FnZXNSZXNwb25zZRIlCg5yZWNlaXZlZF9jb3VudBgBIAEoBVINcmVjZWl2ZW'
    'RDb3VudBIhCgxmYWlsZWRfY291bnQYAiABKAVSC2ZhaWxlZENvdW50EhgKB21lc3NhZ2UYAyAB'
    'KAlSB21lc3NhZ2U=');

@$core.Deprecated('Use chatClientMessageDescriptor instead')
const ChatClientMessage$json = {
  '1': 'ChatClientMessage',
  '2': [
    {'1': 'conversation_id', '3': 1, '4': 1, '5': 3, '10': 'conversationId'},
    {'1': 'sender_id', '3': 2, '4': 1, '5': 3, '10': 'senderId'},
    {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `ChatClientMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatClientMessageDescriptor = $convert.base64Decode(
    'ChFDaGF0Q2xpZW50TWVzc2FnZRInCg9jb252ZXJzYXRpb25faWQYASABKANSDmNvbnZlcnNhdG'
    'lvbklkEhsKCXNlbmRlcl9pZBgCIAEoA1IIc2VuZGVySWQSGAoHY29udGVudBgDIAEoCVIHY29u'
    'dGVudA==');

@$core.Deprecated('Use presenceRequestDescriptor instead')
const PresenceRequest$json = {
  '1': 'PresenceRequest',
};

/// Descriptor for `PresenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceRequestDescriptor =
    $convert.base64Decode('Cg9QcmVzZW5jZVJlcXVlc3Q=');

@$core.Deprecated('Use presenceEventDescriptor instead')
const PresenceEvent$json = {
  '1': 'PresenceEvent',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 3, '10': 'userId'},
    {'1': 'is_online', '3': 2, '4': 1, '5': 8, '10': 'isOnline'},
    {'1': 'last_seen', '3': 3, '4': 1, '5': 9, '10': 'lastSeen'},
  ],
};

/// Descriptor for `PresenceEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceEventDescriptor = $convert.base64Decode(
    'Cg1QcmVzZW5jZUV2ZW50EhcKB3VzZXJfaWQYASABKANSBnVzZXJJZBIbCglpc19vbmxpbmUYAi'
    'ABKAhSCGlzT25saW5lEhsKCWxhc3Rfc2VlbhgDIAEoCVIIbGFzdFNlZW4=');
