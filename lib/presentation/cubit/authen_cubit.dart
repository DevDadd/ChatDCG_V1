import 'package:chatdcg_demo/data/models/auth_models.dart';
import 'package:chatdcg_demo/domain/exceptions/auth_exception.dart';
import 'package:chatdcg_demo/domain/repository/authen_repository.dart';
import 'package:chatdcg_demo/presentation/cubit/authen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenCubit extends Cubit<AuthenState> {
  AuthenCubit(this._repository) : super(const AuthenState());

  final AuthenRepository _repository;

  Future<void> login({
    required String account,
    required String password,
  }) =>
      _authenticate(
        () => _repository.login(
          LoginRequest(account: account.trim(), password: password),
        ),
      );

  Future<void> register({
    required String account,
    required String password,
    String? username,
    String? displayName,
  }) =>
      _authenticate(
        () => _repository.register(
          RegisterRequest(
            account: account.trim(),
            password: password,
            username: _blankToNull(username),
            displayName: _blankToNull(displayName),
          ),
        ),
      );

  void logout() => emit(const AuthenState());

  Future<void> _authenticate(Future<AuthResponse> Function() call) async {
    // Ignore double taps while a request is in flight
    if (state.isLoading) return;

    emit(state.copyWith(status: AuthenStatus.loading, errorMessage: null));
    try {
      final response = await call();
      emit(AuthenState(
        status: AuthenStatus.authenticated,
        user: response.user,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: AuthenStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: AuthenStatus.failure,
        errorMessage: 'Có lỗi không xác định, vui lòng thử lại',
      ));
    }
  }

  // Empty optional fields are omitted so the backend falls back to account
  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
