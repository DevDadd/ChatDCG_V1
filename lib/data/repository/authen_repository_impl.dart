import 'package:chatdcg_demo/data/authen_service.dart';
import 'package:chatdcg_demo/data/models/auth_models.dart';
import 'package:chatdcg_demo/domain/exceptions/auth_exception.dart';
import 'package:chatdcg_demo/domain/repository/authen_repository.dart';
import 'package:dio/dio.dart';

class AuthenRepositoryImpl implements AuthenRepository {
  AuthenRepositoryImpl(this._service);

  final AuthenService _service;

  @override
  Future<AuthResponse> login(LoginRequest request) =>
      _guard(() => _service.login(request));

  @override
  Future<AuthResponse> register(RegisterRequest request) =>
      _guard(() => _service.register(request));

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw _toAuthException(e);
    }
  }

  AuthException _toAuthException(DioException e) {
    final response = e.response;
    if (response == null) {
      return AuthException(switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          'Máy chủ phản hồi quá lâu, vui lòng thử lại',
        _ => 'Không kết nối được tới máy chủ',
      });
    }

    // The backend sends errors as {"error": "..."}
    final data = response.data;
    final message = data is Map && data['error'] is String
        ? data['error'] as String
        : 'Có lỗi xảy ra (${response.statusCode})';
    return AuthException(message, statusCode: response.statusCode);
  }
}
