import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleAuthService() : _initialization = GoogleSignIn.instance.initialize();

  final Future<void> _initialization;
  Future<UserCredential> signInWithGoogle() async {
    await _initialization;
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    final GoogleSignInAccount googleUser =
        await googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final GoogleSignInClientAuthorization authorization =
        await googleUser.authorizationClient.authorizeScopes(
      <String>['email', 'profile'],
    );
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: authorization.accessToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }
}