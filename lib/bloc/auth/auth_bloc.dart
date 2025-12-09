import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/user_prefs.dart';
import '../../core/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheck);
    on<SignInWithGoogleRequested>(_onGoogleSignIn);
    on<SignOutRequested>(_onSignOut);

    authService.userStream.listen((_) {
      add(AuthCheckRequested());
    });
  }

  Future<void> _onAuthCheck(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final savedUser = await UserPrefs.loadUser();
    emit(state.copyWith(user: savedUser, isLoading: false));
  }

  Future<void> _onGoogleSignIn(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await authService.signInWithGoogle();

    if (result.error != null) {
      emit(state.copyWith(error: result.error, isLoading: false));
      return;
    }

    await UserPrefs.saveUser(result.user!);
    emit(state.copyWith(user: result.user, isLoading: false));
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authService.signOut();
    await UserPrefs.clear();
    emit(const AuthState(user: null));
  }
}
