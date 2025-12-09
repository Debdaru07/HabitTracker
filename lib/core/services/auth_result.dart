class AuthResult {
  final dynamic user;
  final String? error;

  const AuthResult({this.user, this.error});

  bool get isSuccess => user != null && error == null;
}
