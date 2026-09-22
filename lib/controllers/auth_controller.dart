import 'package:flutter/foundation.dart';
import 'package:mon_budget/models/app_user.dart';
import 'package:mon_budget/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

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
}