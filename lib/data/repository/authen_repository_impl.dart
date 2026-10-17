import 'dart:async';

import 'package:chatdcg_demo/data/gRPC/gRPC_client.dart';
import 'package:chatdcg_demo/data/models/auth_models.dart';
import 'package:chatdcg_demo/data/models/message_baseresponse.dart';
import 'package:chatdcg_demo/data/models/message_history.dart';
import 'package:chatdcg_demo/data/models/send_message_request.dart';
import 'package:chatdcg_demo/data/models/sync_message_response.dart';
import 'package:chatdcg_demo/data/models/type_status_stream_dto.dart';
import 'package:chatdcg_demo/data/models/user_status.dart';
import 'package:chatdcg_demo/di.dart';
import 'package:chatdcg_demo/domain/exceptions/auth_exception.dart';
import 'package:chatdcg_demo/domain/repository/authen_repository.dart';
import 'package:chatdcg_demo/generated/chat.pb.dart' as pb;
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';

class AuthenRepositoryImpl implements AuthenRepository {
  AuthenRepositoryImpl();

  final GrpcClient _grpc = getIt<GrpcClient>();

  static final _options = CallOptions(timeout: const Duration(seconds: 10));

  @override
  Future<AuthResponse> login(LoginRequest request) => _guard(
    () => _grpc.chat.login(
      pb.LoginRequest(account: request.account, password: request.password),
      options: _options,
    ),
  );

  @override
  Future<AuthResponse> register(RegisterRequest request) => _guard(
    () => _grpc.chat.register(
      pb.RegisterRequest(
        account: request.account,
        password: request.password,
        username: request.username,
        displayName: request.displayName,
      ),
      options: _options,
    ),
  );

  @override
  Future<UserStatusDto> getUserStatus() async {
    try {
      final response = await _grpc.chat.getUsersStatus(
        pb.GetUsersStatusRequest(),
        options: _options,
      );
      return UserStatusDto(
        users: response.users
            .map(
              (u) => UserStatus(
                userId: u.userId.toInt(),
                username: u.username,
                displayName: u.displayName,
                isOnline: u.isOnline,
                lastSeen: u.lastSeen,
              ),
            )
            .toList(),
      );
    } on GrpcError catch (e) {
      throw AuthException(_message(e), statusCode: e.code);
    }
  }

  // No timeout: this stream stays open while the app runs
  @override
  Stream<UserStatus> presence() => _grpc.chat
      .presence(pb.PresenceRequest())
      .map(
        (event) => UserStatus(
          userId: event.userId.toInt(),
          isOnline: event.isOnline,
          lastSeen: event.lastSeen,
        ),
      );

  Message _map(pb.ChatMessage m) => Message(
    messageId: m.messageId.toInt(),
    conversationId: m.conversationId.toInt(),
    senderId: m.senderId.toInt(),
    senderName: m.senderName,
    content: m.content,
    timestamp: DateTime.tryParse(m.timestamp)?.toLocal(), // server gửi UTC
  );

  @override
  Future<MessageHistoryDto> getHistory(int otherUserId) async {
    try {
      final res = await _grpc.chat.getConversationHistory(
        pb.GetConversationHistoryRequest(otherUserId: Int64(otherUserId)),
        options: _options,
      );
      return MessageHistoryDto(
        messages: res.messages.map(_map).toList(),
        totalCount: res.totalCount,
      );
    } on GrpcError catch (e) {
      throw AuthException(_message(e), statusCode: e.code);
    }
  }

  @override
  Future<MessageBaseResponse> sendMessage(SendMessageRequest request) async {
    try {
      final res = await _grpc.chat.sendMessage(
        pb.SendMessageRequest(
          conversationId: _int64(request.conversationId),
          // 0 = server dùng user đang đăng nhập (x-user-id) / giờ server
          senderId: _int64(request.senderId),
          content: request.content ?? '',
          clientTimestampMs: _int64(request.clientTimestampMs),
        ),
        options: _options,
      );
      return MessageBaseResponse(
        success: res.success,
        message: res.message,
        messageId: res.messageId.toString(),
      );
    } on GrpcError catch (e) {
      throw AuthException(_message(e), statusCode: e.code);
    }
  }

  @override
  Future<void> sentTypingStatus(
    int conversationid,
    bool isTyping,
    int userId,
  ) async {
    try {
      await _grpc.chat.sendTypingStatus(
        pb.SendTypingStatusRequest(
          conversationId: Int64(conversationid),
          isTyping: isTyping,
          userId: Int64(userId),
        ),
        options: _options,
      );
    } on GrpcError catch (e) {
      throw AuthException(_message(e), statusCode: e.code);
    }
  }

  @override
  Stream<Message> streamMessages(int conversationid) => _grpc.chat
      .streamMessages(
        pb.StreamMessagesRequest(conversationId: Int64(conversationid)),
      )
      .map(_map);

  Int64 _int64(String? value) => Int64.tryParseInt(value ?? '') ?? Int64.ZERO;

  @override
  Future<SyncMessageResponse> syncMessages(
    List<SendMessageRequest> requests,
  ) async {
    try {
      final res = await _grpc.chat.syncMessages(
        Stream.fromIterable(
          requests.map(
            (r) => pb.SendMessageRequest(
              conversationId: _int64(r.conversationId),
              content: r.content ?? '',
              clientTimestampMs: _int64(r.clientTimestampMs),
            ),
          ),
        ),
        options: _options,
      );
      return SyncMessageResponse(
        receivedCount: res.receivedCount,
        failedCount: res.failedCount,
        message: res.message,
      );
    } on GrpcError catch (e) {
      throw AuthException(_message(e), statusCode: e.code);
    }
  }

  Future<AuthResponse> _guard(Future<pb.AuthResponse> Function() call) async {
    try {
      final user = (await call()).user;
      _grpc.userId = user.id;
      return AuthResponse(
        user: User(
          id: user.id.toInt(),
          account: user.account,
          username: user.username,
          displayName: user.displayName,
        ),
      );
    } on GrpcError catch (e) {
      throw AuthException(_message(e), statusCode: e.code);
    }
  }

  @override
  Stream<TypingStreamDto> streamTypingStatus(int conversationid, int userid) =>
      _grpc.chat
          .subscribeTyping(
            pb.SubscribeTypingRequest(
              conversationId: Int64(conversationid),
              userId: Int64(userid),
            ),
          )
          .map(
            (e) => TypingStreamDto(
              conversationId: e.conversationId.toString(),
              userId: e.userId.toString(),
              username: e.username,
              displayName: e.displayName,
              isTyping: e.isTyping,
              timestamp: DateTime.tryParse(e.timestamp)?.toLocal(), // UTC
            ),
          );

  String _message(GrpcError e) => switch (e.code) {
    StatusCode.unauthenticated => 'Sai tài khoản hoặc mật khẩu',
    StatusCode.alreadyExists => 'Tài khoản đã tồn tại',
    StatusCode.invalidArgument => e.message ?? 'Thông tin không hợp lệ',
    StatusCode.notFound => 'Không tìm thấy cuộc trò chuyện',
    StatusCode.permissionDenied => 'Không có quyền gửi thay người khác',
    StatusCode.deadlineExceeded => 'Máy chủ phản hồi quá lâu, vui lòng thử lại',
    StatusCode.unavailable => 'Không kết nối được tới máy chủ',
    _ => 'Có lỗi xảy ra (${e.codeName})',
  };
}
