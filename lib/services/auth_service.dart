import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Anonymous Sign In
  Future<User?> signInAnonymously() async {
    final userCred = await _auth.signInAnonymously();
    return userCred.user;
  }

  // Email Sign Up
  Future<User?> signUpWithEmail(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCred.user;
  }


  // Email Sign In
  Future<User?> signInWithEmail(String email, String password) async {
    final userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return userCred.user;
  }

  // Google Sign In
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCred = await _auth.signInWithCredential(credential);
    return userCred.user;
  }

  // Apple Sign In
  Future<User?> signInWithApple() async {
    final appleCred = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );
    final oauthCred = OAuthProvider("apple.com").credential(
      idToken: appleCred.identityToken,
      accessToken: appleCred.authorizationCode,
    );
    final userCred = await _auth.signInWithCredential(oauthCred);
    return userCred.user;
  }

  // Link anonymous to email
  Future<void> upgradeAnonymous(String email, String password) async {
    final credential = EmailAuthProvider.credential(email: email, password: password);
    await _auth.currentUser?.linkWithCredential(credential);
  }

  Future<void> signOut() async => await _auth.signOut();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
