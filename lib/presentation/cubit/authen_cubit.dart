import 'dart:async';

import 'package:chatdcg_demo/data/models/auth_models.dart';
import 'package:chatdcg_demo/data/models/message_history.dart';
import 'package:chatdcg_demo/data/models/send_message_request.dart';
import 'package:chatdcg_demo/data/models/user_status.dart';
import 'package:chatdcg_demo/di.dart';
import 'package:chatdcg_demo/domain/exceptions/auth_exception.dart';
import 'package:chatdcg_demo/domain/repository/authen_repository.dart';
import 'package:chatdcg_demo/presentation/cubit/authen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenCubit extends Cubit<AuthenState> {
  AuthenCubit() : super(const AuthenState());
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController chatController = TextEditingController();
  final AuthenRepository _repository = getIt<AuthenRepository>();
  StreamSubscription<Message>? _messageStream;
  int? _streamConversationId;
  StreamSubscription<UserStatus>? _presence;
  Timer? _stopTypingTimer;
  bool _isTyping = false;
  DateTime _lastTypingSent = DateTime.fromMicrosecondsSinceEpoch(0);

  void startMessageStream(int conversationId) {
    _streamConversationId = conversationId;
    _listenMessages(conversationId);
  }

  void onChatTextChange() {
    if (chatController.text.trim().isEmpty) {
      _logTyping('ô nhập trống');
      _setTyping(false);
      return;
    }
    final now = DateTime.now();
    if (!_isTyping || now.difference(_lastTypingSent).inSeconds >= 3) {
      _setTyping(true);
    }
    _stopTypingTimer?.cancel();
    _stopTypingTimer = Timer(const Duration(seconds: 2), () {
      _logTyping('ngừng gõ 2s');
      _setTyping(false);
    });
  }

  void stopTyping() {
    _logTyping('ô nhập mất focus');
    _setTyping(false);
  }

  void _logTyping(String text) => debugPrint('[Typing] $text');

  void _setTyping(bool isTyping) {
    if (!isTyping) _stopTypingTimer?.cancel();
    if (!isTyping && !_isTyping) return;

    final conversationId = _streamConversationId;
    if (conversationId == null) {
      _logTyping('bỏ qua is_typing=$isTyping: chưa có conversation');
      return;
    }

    _isTyping = isTyping;
    _lastTypingSent = DateTime.now();
    _logTyping('gửi is_typing=$isTyping, conversation $conversationId');

    _repository
        .sentTypingStatus(conversationId, isTyping, state.user?.id ?? 0)
        .then(
          (_) => _logTyping('server nhận is_typing=$isTyping'),
          onError: (Object e) => _logTyping('lỗi is_typing=$isTyping: $e'),
        );
  }

  void _listenMessages(int conversationId) {
    _messageStream?.cancel();
    _logStream('mở stream, conversation $conversationId');
    _messageStream = _repository
        .streamMessages(conversationId)
        .listen(
          _onMessage,
          onError: (Object e) {
            _logStream('lỗi, conversation $conversationId: $e');
            _restartMessageStream(conversationId);
          },
          onDone: () {
            _logStream('server đóng stream, conversation $conversationId');
            _restartMessageStream(conversationId);
          },
        );
  }

  // debugPrint (not dart:developer log) so it also shows in release builds:
  // adb logcat -s flutter
  void _logStream(String text) => debugPrint('[MessageStream] $text');

  void _restartMessageStream(int conversationId) {
    _messageStream?.cancel();
    _messageStream = null;
    _logStream('kết nối lại sau 2s, conversation $conversationId');
    Future.delayed(const Duration(seconds: 2), () {
      // Đã rời màn chat / mở chat khác / đã kết nối lại rồi
      if (isClosed ||
          _streamConversationId != conversationId ||
          _messageStream != null) {
        _logStream('bỏ kết nối lại, conversation $conversationId');
        return;
      }
      _listenMessages(conversationId);
    });
  }

  void stopMessageStream() {
    // Before the id is cleared, or the other side keeps seeing "typing"
    _logTyping('rời trang chat');
    _setTyping(false);
    if (_streamConversationId != null) {
      _logStream('ngắt stream, conversation $_streamConversationId');
    }
    _streamConversationId = null;
    _messageStream?.cancel();
    _messageStream = null;
  }

  void _onMessage(Message message) {
    _logStream(
      'nhận tin #${message.messageId} từ ${message.senderName} '
      '(${message.senderId}), conversation ${message.conversationId}: '
      '${message.content}',
    );
    if (message.conversationId != _streamConversationId) {
      _logStream('bỏ qua: không phải conversation đang mở');
      return;
    }

    final messages = state.history?.messages ?? [];
    if (messages.any((m) => m.messageId == message.messageId)) {
      _logStream('bỏ qua: tin #${message.messageId} đã có');
      return;
    }

    _emitMessages([...messages, message]);
  }

  Future<bool> login() async {
    if (state.isLoading) return false;

    emit(state.copyWith(status: AuthenStatus.loading, errorMessage: null));
    try {
      final response = await _repository.login(
        LoginRequest(
          account: accountController.text.trim(),
          password: passwordController.text,
        ),
      );
      emit(
        AuthenState(status: AuthenStatus.authenticated, user: response.user),
      );
      _startPresence();
      return true;
    } on AuthException catch (e) {
      emit(
        state.copyWith(status: AuthenStatus.failure, errorMessage: e.message),
      );
      return false;
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthenStatus.failure,
          errorMessage: 'Có lỗi không xác định, vui lòng thử lại',
        ),
      );
      return false;
    }
  }

  Future<bool> register({
    required String account,
    required String password,
    String? username,
    String? displayName,
  }) async {
    if (state.isLoading) return false;

    // Empty optional fields are omitted so the backend falls back to account
    final trimmedUsername = username?.trim() ?? '';
    final trimmedDisplayName = displayName?.trim() ?? '';

    emit(state.copyWith(status: AuthenStatus.loading, errorMessage: null));
    try {
      final response = await _repository.register(
        RegisterRequest(
          account: account.trim(),
          password: password,
          username: trimmedUsername.isEmpty ? null : trimmedUsername,
          displayName: trimmedDisplayName.isEmpty ? null : trimmedDisplayName,
        ),
      );
      emit(
        AuthenState(status: AuthenStatus.authenticated, user: response.user),
      );
      _startPresence();
      return true;
    } on AuthException catch (e) {
      emit(
        state.copyWith(status: AuthenStatus.failure, errorMessage: e.message),
      );
      return false;
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthenStatus.failure,
          errorMessage: 'Có lỗi không xác định, vui lòng thử lại',
        ),
      );
      return false;
    }
  }

  Future<void> getUserStatus() async {
    if (state.isLoading) return;

    emit(state.copyWith(status: AuthenStatus.loading, errorMessage: null));
    try {
      final response = await _repository.getUserStatus();
      emit(
        state.copyWith(
          status: AuthenStatus.authenticated,
          userStatus: response,
        ),
      );
    } on AuthException catch (e) {
      emit(
        state.copyWith(status: AuthenStatus.failure, errorMessage: e.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthenStatus.failure,
          errorMessage: 'Có lỗi không xác định, vui lòng thử lại',
        ),
      );
    }
  }

  Future<void> getHistory(int otherUserId) async {
    emit(
      state.copyWith(history: null, isHistoryLoading: true, errorMessage: null),
    );
    try {
      final response = await _repository.getHistory(otherUserId);
      emit(state.copyWith(history: response, isHistoryLoading: false));
    } on AuthException catch (e) {
      emit(state.copyWith(isHistoryLoading: false, errorMessage: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          isHistoryLoading: false,
          errorMessage: 'Không tải được tin nhắn, vui lòng thử lại',
        ),
      );
    }
  }

  Future<void> sendMessage() async {
    final text = chatController.text.trim();
    final messages = state.history?.messages ?? [];
    if (text.isEmpty) return;

    // No RPC creates a conversation yet: the id only comes from the history
    final conversationId = messages
        .map((m) => m.conversationId)
        .firstWhere((id) => id != null, orElse: () => null);
    if (conversationId == null) {
      emit(
        state.copyWith(errorMessage: 'Chưa có cuộc trò chuyện với người này'),
      );
      return;
    }

    final pending = Message(
      conversationId: conversationId,
      senderId: state.user?.id,
      senderName: state.user?.displayName,
      content: text,
      timestamp: DateTime.now(),
    );
    // clear() does not fire onChanged, so stop typing here
    chatController.clear();
    _logTyping('gửi tin nhắn');
    _setTyping(false);
    _emitMessages([...messages, pending]);

    try {
      final response = await _repository.sendMessage(
        SendMessageRequest(
          conversationId: conversationId.toString(),
          senderId: state.user?.id.toString(),
          content: text,
          clientTimestampMs: pending.timestamp!.millisecondsSinceEpoch
              .toString(),
        ),
      );
      pending.messageId = int.tryParse(response.messageId ?? '');
    } on AuthException catch (e) {
      _removeMessage(pending, text, e.message);
    } catch (_) {
      _removeMessage(pending, text, 'Gửi tin nhắn thất bại, vui lòng thử lại');
    }
  }

  void _emitMessages(List<Message> messages) {
    emit(
      state.copyWith(
        history: MessageHistoryDto(
          messages: messages,
          totalCount: messages.length,
        ),
        errorMessage: null,
      ),
    );
  }

  void _removeMessage(Message pending, String text, String error) {
    final messages = [...?state.history?.messages]..remove(pending);
    _emitMessages(messages);
    if (chatController.text.isEmpty) chatController.text = text;
    emit(state.copyWith(errorMessage: error));
  }

  void _startPresence() {
    _presence?.cancel();
    _presence = _repository.presence().listen(
      _onPresence,
      onError: (_) => _restartPresence(),
      onDone: _restartPresence,
    );
  }

  void _restartPresence() {
    _presence?.cancel();
    _presence = null;
    Future.delayed(const Duration(seconds: 2), () {
      // Logged out or closed in the meantime
      if (isClosed || state.user == null || _presence != null) return;
      _startPresence();
    });
  }

  void _onPresence(UserStatus event) {
    final users = state.userStatus?.users ?? [];
    final index = users.indexWhere((u) => u.userId == event.userId);

    // Someone not in the list yet (e.g. just registered): the event has no
    // name, so fetch the whole list again
    if (index == -1) {
      getUserStatus();
      return;
    }

    final old = users[index];
    final updated = [...users]
      ..[index] = UserStatus(
        userId: old.userId,
        username: old.username,
        displayName: old.displayName,
        isOnline: event.isOnline,
        lastSeen: event.lastSeen,
      );
    emit(state.copyWith(userStatus: UserStatusDto(users: updated)));
  }

  void logout() {
    stopMessageStream();
    _presence?.cancel();
    _presence = null;
    emit(const AuthenState());
  }

  @override
  Future<void> close() {
    stopMessageStream();
    _presence?.cancel();
    accountController.dispose();
    passwordController.dispose();
    chatController.dispose();
    return super.close();
  }
}
