import 'package:chatdcg_demo/data/models/auth_models.dart';
import 'package:chatdcg_demo/data/models/user_status.dart';

abstract class AuthenRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<UserStatusDto> getUserStatus();

  /// Online/offline changes of other users. The caller counts as online
  /// while this stream is open.
  Stream<UserStatus> presence();
}
