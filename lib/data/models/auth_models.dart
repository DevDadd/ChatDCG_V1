import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class User extends Equatable {
  const User({
    required this.id,
    required this.account,
    required this.username,
    required this.displayName,
  });

  final int id;
  final String account;
  final String username;
  final String displayName;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, account, username, displayName];
}

@JsonSerializable(createFactory: false)
class LoginRequest {
  const LoginRequest({required this.account, required this.password});

  final String account;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable(
  createFactory: false,
  fieldRename: FieldRename.snake,
  includeIfNull: false,
)
class RegisterRequest {
  const RegisterRequest({
    required this.account,
    required this.password,
    this.username,
    this.displayName,
  });

  final String account;
  final String password;

  // The backend falls back to account when these are omitted
  final String? username;
  final String? displayName;

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable(createToJson: false)
class AuthResponse {
  const AuthResponse({required this.user});

  final User user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
