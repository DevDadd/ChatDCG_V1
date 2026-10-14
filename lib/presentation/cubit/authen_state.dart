import 'package:chatdcg_demo/data/models/auth_models.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'authen_state.g.dart';

enum AuthenStatus { initial, loading, authenticated, failure }

@CopyWith()
class AuthenState extends Equatable {
  const AuthenState({
    this.status = AuthenStatus.initial,
    this.user,
    this.errorMessage,
  });

  final AuthenStatus status;

  // Set once login/register succeeds, cleared on logout
  final User? user;

  // Only meaningful when status is failure
  final String? errorMessage;

  bool get isLoading => status == AuthenStatus.loading;
  bool get isAuthenticated => status == AuthenStatus.authenticated;

  @override
  List<Object?> get props => [status, user, errorMessage];
}
