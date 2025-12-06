import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ⚠️ CRITICAL: BASE URL CONFIGURATION
  // This logic attempts to use the correct localhost for Emulator vs Device.
  static String get _baseURL {
    // Android Emulator uses 10.0.2.2 to access host localhost
    // Physical Device + ADB Reverse uses localhost
    // iOS Simulator uses localhost

    if (Platform.isAndroid) {
      // If you are using ADB Reverse (recommended), use localhost
      // If you are NOT using ADB Reverse, use your PC IP: 'http://192.168.29.250:8080/api/auth'
      return 'http://localhost:8080/api/auth';
    }
    return 'http://localhost:8080/api/auth';
  }

  static final String baseUrl = _baseURL;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🚀 Sending Login Request to: $baseUrl/login');

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      print('📥 Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        // Save token securely
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('username', username);

        return {'success': true, 'token': token};
      } else {
        return {'success': false, 'message': 'Invalid credentials or status ${response.statusCode}'};
      }
    } catch (e) {
      print('DEBUG: Exception caught: $e');
      String msg = 'Connection failed.';
      if (e.toString().contains('SocketException')) {
        msg = 'Cannot reach server. Ensure backend is running and ADB reverse is active.';
      }
      return {'success': false, 'message': msg};
    }
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email, // Backend expects email
          'password': password,
          'avatarIcon': '👾'
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Registration successful'};
      } else {
        return {'success': false, 'message': 'Registration failed: ${response.body}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('username');
  }
}