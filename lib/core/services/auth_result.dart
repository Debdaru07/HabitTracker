import '../../models/user_model.dart';

class AuthResult {
  final UserModel? user;
  final String? error;

  const AuthResult({this.user, this.error});

  bool get isSuccess => user != null && error == null;
}
