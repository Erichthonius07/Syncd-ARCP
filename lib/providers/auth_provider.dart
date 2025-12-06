import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _token;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  String? get token => _token;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(username, password);

    _isLoading = false;

    if (result['success']) {
      _token = result['token'];
      notifyListeners();
      return true;
    } else {
      _token = null;
      notifyListeners();
      return false;
    }
  }

  Future<String> register(String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.register(username, email, password);

    _isLoading = false;
    notifyListeners();

    if (result['success']) {
      return "Success";
    } else {
      return result['message'];
    }
  }

  void logout() {
    _authService.logout();
    _token = null;
    notifyListeners();
  }
}