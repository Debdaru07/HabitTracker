import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheck);
    on<SignInWithGoogleRequested>(_onGoogleSignIn);
    on<SignOutRequested>(_onSignOut);

    // Listen to Firebase user stream
    authService.userStream.listen((user) {
      add(AuthCheckRequested());
    });
  }

  Future<void> _onAuthCheck(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(user: authService.currentUser, isLoading: false));
  }

  Future<void> _onGoogleSignIn(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await authService.signInWithGoogle();

    if (result.error != null) {
      emit(state.copyWith(isLoading: false, error: result.error));
    } else {
      emit(state.copyWith(isLoading: false, user: result.user));
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authService.signOut();
    emit(const AuthState(user: null));
  }
}
