import 'package:firebase_auth/firebase_auth.dart';
import 'package:mon_budget/models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AppUser(uid: user.uid, email: user.email ?? '');
  }

  Stream<AppUser?> get authStateChanges => _auth.authStateChanges().map((user) {
        if (user == null) return null;
        return AppUser(uid: user.uid, email: user.email ?? '');
      });

  Future<AppUser> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return AppUser(
      uid: credential.user!.uid,
      email: credential.user!.email ?? '',
    );
  }

  Future<AppUser> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return AppUser(
      uid: credential.user!.uid,
      email: credential.user!.email ?? '',
    );
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> deleteUserAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.delete();
  }

  String readableError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email ou mot de passe incorrect.';
        case 'email-already-in-use':
          return 'Un compte existe déjà avec cet email.';
        case 'weak-password':
          return 'Mot de passe trop court (6 caractères minimum).';
        case 'invalid-email':
          return 'Adresse email invalide.';
        case 'requires-recent-login':
          return 'Par sécurité, veuillez vous déconnecter puis vous reconnecter avant de supprimer votre compte.';
        default:
          return 'Erreur : ${error.message}';
      }
    }
    return 'Une erreur est survenue. Réessayez.';
  }
}
