import 'package:flutter/foundation.dart';

import '../controllers/auth_controller.dart';
import '../models/staff_model.dart';

/// Holds the login session. main.dart's AuthGate watches [isLoggedIn] to
/// decide between LoginScreen and the main app.
class AuthProvider extends ChangeNotifier {
  StaffUser? _user;
  String? _error;
  bool _loading = false;

  StaffUser? get user => _user;
  String? get error => _error;
  bool get isLoading => _loading;
  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    _error = null;
    _loading = true;
    notifyListeners();

    // Small delay so the loading spinner is visible, like a real request.
    await Future.delayed(const Duration(milliseconds: 600));

    final message = AuthController.validate(email, password);
    if (message == null) {
      _user = AuthController.demoUser;
    } else {
      _error = message;
    }
    _loading = false;
    notifyListeners();
  }

  /// "Quick Login with Staff Badge" — simulates a successful badge scan.
  void quickLoginWithBadge() {
    _error = null;
    _user = AuthController.demoUser;
    notifyListeners();
  }

  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _error = null;
    notifyListeners();
  }
}
