import 'package:chatdcg_demo/data/gRPC/gRPC_client.dart';
import 'package:chatdcg_demo/data/models/auth_models.dart';
import 'package:chatdcg_demo/data/models/user_status.dart';
import 'package:chatdcg_demo/di.dart';
import 'package:chatdcg_demo/domain/exceptions/auth_exception.dart';
import 'package:chatdcg_demo/domain/repository/authen_repository.dart';
import 'package:chatdcg_demo/generated/chat.pb.dart' as pb;
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

  String _message(GrpcError e) => switch (e.code) {
    StatusCode.unauthenticated => 'Sai tài khoản hoặc mật khẩu',
    StatusCode.alreadyExists => 'Tài khoản đã tồn tại',
    StatusCode.invalidArgument => e.message ?? 'Thông tin không hợp lệ',
    StatusCode.deadlineExceeded => 'Máy chủ phản hồi quá lâu, vui lòng thử lại',
    StatusCode.unavailable => 'Không kết nối được tới máy chủ',
    _ => 'Có lỗi xảy ra (${e.codeName})',
  };
}
