import 'dart:convert';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GameScanService {
  // ⚠️ REPLACE WITH YOUR PC IP ADDRESS
  // For Android Emulator, use 'http://10.0.2.2:8080/api/user'
  // For Real Device, use 'http://192.168.x.x:8080/api/user'
  static const String baseUrl = 'http://localhost:8080/api/user';

  /// Scans the device for installed apps
  Future<List<AppInfo>> getInstalledApps() async {
    // Uses the installed_apps package
    // Arguments: (bool withIcon, bool withPackageName)
    return await InstalledApps.getInstalledApps(true, true);
  }

  /// Sends the list of game names to the backend
  Future<bool> syncLibraryToBackend(List<String> gameNames) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        print("❌ Sync Failed: No auth token found");
        return false;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/library/sync'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(gameNames),
      );

      if (response.statusCode == 200) {
        print("✅ Library Synced: ${gameNames.length} games");
        return true;
      } else {
        print("❌ Sync Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Connection Error: $e");
      return false;
    }
  }
}