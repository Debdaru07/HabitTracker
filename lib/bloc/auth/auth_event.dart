import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class SignInWithGoogleRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class UpdateUserRequested extends AuthEvent {
  final UserModel updatedUser;
  UpdateUserRequested(this.updatedUser);
}
