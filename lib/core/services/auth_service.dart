import 'dart:developer' as console;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_result.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Force account picker every time
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User?> get userStream => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<AuthResult> signInWithGoogle() async {
    try {
      // Always show account picker
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult(error: "Sign-in cancelled");
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

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}
