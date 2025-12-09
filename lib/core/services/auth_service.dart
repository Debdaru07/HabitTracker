import 'dart:developer' as console;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_result.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Single instance for Google Sign In
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream to detect sign-in / sign-out
  Stream<User?> get userStream => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // ----------------------------------------------------------
  //  GOOGLE SIGN IN
  // ----------------------------------------------------------
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult(error: "Google sign-in cancelled.");
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCred = await _auth.signInWithCredential(credential);

      return AuthResult(user: userCred.user);
    } catch (e) {
      console.log("Google Sign-In failed: $e");
      return AuthResult(error: e.toString());
    }
  }

  // ----------------------------------------------------------
  //  EMAIL SIGN-IN / REGISTER (Optional)
  // ----------------------------------------------------------
  Future<AuthResult> signInWithEmail(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(user: userCred.user);
    } catch (e) {
      console.log("Email Sign-In failed: $e");
      return AuthResult(error: e.toString());
    }
  }

  Future<AuthResult> registerWithEmail(String email, String password) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthResult(user: userCred.user);
    } catch (e) {
      console.log("Email Register failed: $e");
      return AuthResult(error: e.toString());
    }
  }

  // ----------------------------------------------------------
  //  SIGN OUT
  // ----------------------------------------------------------
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    try {
      await _auth.signOut();
    } catch (e) {
      console.log("Firebase Sign-Out failed: $e");
    }
  }
}
