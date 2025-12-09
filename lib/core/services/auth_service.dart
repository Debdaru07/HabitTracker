import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/user_model.dart';
import 'auth_result.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Force account picker every time
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User?> get userStream => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult(error: "Google sign-in cancelled");
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final cred = await _auth.signInWithCredential(credential);
      final firebaseUser = cred.user;

      if (firebaseUser == null) {
        return AuthResult(error: "User not found");
      }

      final isFirstTime = cred.additionalUserInfo?.isNewUser ?? false;

      final model = UserModel(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName ?? "",
        email: firebaseUser.email ?? "",
        photoUrl: firebaseUser.photoURL ?? "",
        isFirstTime: isFirstTime,
      );

      return AuthResult(user: model);
    } catch (e) {
      return AuthResult(error: e.toString());
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
