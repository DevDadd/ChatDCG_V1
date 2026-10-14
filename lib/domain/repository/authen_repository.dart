import 'package:chatdcg_demo/data/models/auth_models.dart';

abstract class AuthenRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
}
