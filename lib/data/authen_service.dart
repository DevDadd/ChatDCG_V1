import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'models/auth_models.dart';

part 'authen_service.g.dart';

/// REST auth endpoints of ChatDCG_Backend (Django).
///
/// Errors come back as `{"error": "..."}` with status 400 (bad body),
/// 401 (wrong login) or 409 (account/username taken); Dio throws them
/// as [DioException].
@RestApi()
abstract class AuthenService {
  factory AuthenService(Dio dio, {String? baseUrl}) = _AuthenService;

  @POST('/api/auth/login/')
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST('/api/auth/register/')
  Future<AuthResponse> register(@Body() RegisterRequest request);
}
