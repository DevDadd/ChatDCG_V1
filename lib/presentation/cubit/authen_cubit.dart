import 'dart:async';

import 'package:chatdcg_demo/data/models/auth_models.dart';
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
  final AuthenRepository _repository = getIt<AuthenRepository>();

  StreamSubscription<UserStatus>? _presence;

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
    _presence?.cancel();
    _presence = null;
    emit(const AuthenState());
  }

  @override
  Future<void> close() {
    _presence?.cancel();
    accountController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
