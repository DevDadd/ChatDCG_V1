/// Thrown by [AuthenRepository] with a message ready to show to the user.
class AuthException implements Exception {
  const AuthException(this.message, {this.statusCode});

  final String message;

  // null when the request never got a response (timeout, no connection)
  final int? statusCode;

  @override
  String toString() => 'AuthException($statusCode): $message';
}
