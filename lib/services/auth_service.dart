import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  // MOCK MODE: Purely in-memory state for now
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> checkLoginStatus() async {
    // Since we aren't storing tokens, we always start logged out on restart
    // This is fine for development/demos
    _isAuthenticated = false;
    notifyListeners();
    return false;
  }

  Future<String?> login(String username, String password) async {
    // Mock Network Delay
    await Future.delayed(const Duration(seconds: 2));

    // Always succeed
    _isAuthenticated = true;
    notifyListeners();
    return null;
  }

  Future<String?> register(String username, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners();
  }
}