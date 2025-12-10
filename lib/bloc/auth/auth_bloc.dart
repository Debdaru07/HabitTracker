import 'dart:developer' as console;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/user_prefs.dart';
import '../../models/user_model.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(const AuthState()) {
    console.log("AuthBloc initialized");

    // Register event handlers first
    on<AuthCheckRequested>(_onAuthCheck);
    on<SignInWithGoogleRequested>(_onGoogleSignIn);
    on<SignOutRequested>(_onSignOut);
    on<UpdateUserRequested>(_onUserUpdate);

    // Listen to Firebase user changes
    Future.microtask(() {
      authService.userStream.listen((firebaseUser) async {
        console.log("Firebase AuthStream update → ${firebaseUser?.uid}");
        add(AuthCheckRequested());
      });
    });
  }

  // -------------------------------------------------------------
  // AUTH CHECK
  // -------------------------------------------------------------
  Future<void> _onAuthCheck(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    console.log("AuthCheckRequested → Checking stored user...");

    emit(state.copyWith(isLoading: true));

    final UserModel? savedUser = await UserPrefs.loadUser();

    if (savedUser != null) {
      console.log("User found in SharedPrefs → ${savedUser.uid}");
      emit(state.copyWith(user: savedUser, isLoading: false));
    } else {
      console.log("No user found → Redirect to Login");
      emit(state.copyWith(user: null, isLoading: false));
    }
  }

  // -------------------------------------------------------------
  // SIGN IN WITH GOOGLE
  // -------------------------------------------------------------
  Future<void> _onGoogleSignIn(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    console.log("Google Sign-In started...");
    emit(state.copyWith(isLoading: true));

    final result = await authService.signInWithGoogle();

    if (result.error != null) {
      console.log("Google Sign-In error: ${result.error}");
      emit(state.copyWith(error: result.error, isLoading: false));
      return;
    }

    final user = result.user!;
    console.log("Google Sign-In success → ${user.uid}");

    await UserPrefs.saveUser(user);

    emit(state.copyWith(user: user, isLoading: false));

    // Trigger navigation logic in AuthWrapper
    add(AuthCheckRequested());
  }

  // -------------------------------------------------------------
  // SIGN OUT
  // -------------------------------------------------------------
  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    console.log("Signing out user...");

    await authService.signOut();
    await UserPrefs.clear();

    console.log("User signed out & prefs cleared.");

    emit(const AuthState(user: null, isLoading: false));
  }

  // User Onboarding
  Future<void> _onUserUpdate(
    UpdateUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    console.log("Updating user in SharedPrefs...");

    final updated = event.updatedUser;

    // Save in SharedPreferences
    await UserPrefs.saveUser(updated);

    console.log("User updated → ${updated.toJson()}");

    // Emit updated state
    emit(state.copyWith(user: updated));
  }
}
