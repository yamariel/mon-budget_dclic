import 'package:flutter/foundation.dart';
import 'package:mon_budget/models/app_user.dart';
import 'package:mon_budget/services/auth_service.dart';
import 'package:mon_budget/services/google_auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final GoogleAuthService _googleAuth = GoogleAuthService();

  AppUser? currentUser;
  bool isLoading = false;
  String? errorMessage;

  AuthController() {
    currentUser = _authService.currentUser;
    _authService.authStateChanges.listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      currentUser = await _authService.signIn(email, password);
      return true;
    } catch (e) {
      errorMessage = _authService.readableError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      currentUser = await _authService.signUp(email, password);
      return true;
    } catch (e) {
      errorMessage = _authService.readableError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() => _authService.signOut();

  Future<bool> deleteAccount() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _authService.deleteUserAccount();
      return true;
    } catch (e) {
      errorMessage = _authService.readableError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> google() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _googleAuth.signInWithGoogle();
      currentUser = _authService.currentUser;
      return true;
    } catch (e) {
      errorMessage = _authService.readableError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
