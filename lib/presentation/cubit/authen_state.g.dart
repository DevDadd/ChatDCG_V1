// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authen_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuthenStateCWProxy {
  AuthenState status(AuthenStatus status);

  AuthenState user(User? user);

  AuthenState errorMessage(String? errorMessage);

  AuthenState userStatus(UserStatusDto? userStatus);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AuthenState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AuthenState(...).copyWith(id: 12, name: "My name")
  /// ```
  AuthenState call({
    AuthenStatus status,
    User? user,
    String? errorMessage,
    UserStatusDto? userStatus,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfAuthenState.copyWith(...)` or call `instanceOfAuthenState.copyWith.fieldName(value)` for a single field.
class _$AuthenStateCWProxyImpl implements _$AuthenStateCWProxy {
  const _$AuthenStateCWProxyImpl(this._value);

  final AuthenState _value;

  @override
  AuthenState status(AuthenStatus status) => call(status: status);

  @override
  AuthenState user(User? user) => call(user: user);

  @override
  AuthenState errorMessage(String? errorMessage) =>
      call(errorMessage: errorMessage);

  @override
  AuthenState userStatus(UserStatusDto? userStatus) =>
      call(userStatus: userStatus);

  /// Creates a new instance with the provided field values.
  /// Omitted fields keep their values; explicit `null` clears nullable fields.
  /// The public API rejects `null` for non-nullable fields. To update a single field use `AuthenState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// AuthenState(...).copyWith(id: 12, name: "My name")
  /// ```
  @override
  AuthenState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? errorMessage = const $CopyWithPlaceholder(),
    Object? userStatus = const $CopyWithPlaceholder(),
  }) {
    return AuthenState(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as AuthenStatus,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as User?,
      errorMessage: errorMessage == const $CopyWithPlaceholder()
          ? _value.errorMessage
          // ignore: cast_nullable_to_non_nullable
          : errorMessage as String?,
      userStatus: userStatus == const $CopyWithPlaceholder()
          ? _value.userStatus
          // ignore: cast_nullable_to_non_nullable
          : userStatus as UserStatusDto?,
    );
  }
}

extension $AuthenStateCopyWith on AuthenState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfAuthenState.copyWith(...)` or `instanceOfAuthenState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuthenStateCWProxy get copyWith => _$AuthenStateCWProxyImpl(this);
}
