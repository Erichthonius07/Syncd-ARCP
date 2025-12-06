import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/game_scan_service.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class MyGamesScreen extends StatefulWidget {
  const MyGamesScreen({super.key});

  @override
  State<MyGamesScreen> createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  final GameScanService _scanService = GameScanService();

  // State Variables
  bool _isLoading = true;
  List<AppInfo> _allInstalledApps = [];
  List<String> _syncedGameNames = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final apps = await _scanService.getInstalledApps();
      final syncedGames = await _fetchUserLibrary();

      if (mounted) {
        setState(() {
          _allInstalledApps = apps;
          _syncedGameNames = syncedGames;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading games: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Fetch current library from Backend
  Future<List<String>> _fetchUserLibrary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) return [];

      // Use the same IP as your GameScanService
      const String baseUrl = 'http://192.168.29.250:8080/api/user/me';

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> lib = data['gameLibrary'] ?? [];
        return lib.cast<String>();
      }
    } catch (e) {
      print("Failed to fetch profile: $e");
    }
    return [];
  }

  // Handle moving games
  Future<void> _toggleGame(String appName, bool isAdding) async {
    setState(() {
      if (isAdding) {
        _syncedGameNames.add(appName);
      } else {
        _syncedGameNames.remove(appName);
      }
    });
    await _scanService.syncLibraryToBackend(_syncedGameNames);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.c(context);

    final myGamesApps = _allInstalledApps
        .where((app) => _syncedGameNames.contains(app.name))
        .toList();

    final availableApps = _allInstalledApps
        .where((app) => !_syncedGameNames.contains(app.name))
        .toList();

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("LIBRARY", style: TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Using the specific headers from your snapshot
                const Text("INSTALLED", style: TextStyle(fontFamily: 'Pixer', fontSize: 20)),
                const SizedBox(height: 12),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildGameGrid(myGamesApps, isInstalled: true, colors: colors),

                const SizedBox(height: 24),

                const Text("ON DEVICE", style: TextStyle(fontFamily: 'Pixer', fontSize: 20)),
                const SizedBox(height: 12),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildGameGrid(availableApps, isInstalled: false, colors: colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameGrid(List<AppInfo> apps, {required bool isInstalled, required SyncPalette colors}) {
    if (apps.isEmpty) {
      return NeoCard(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: const Text("No games found.", textAlign: TextAlign.center)
          )
      );
    }

    return Expanded(
      flex: isInstalled ? 3 : 2,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Updated to 4 columns as requested
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85
        ),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          final appName = app.name ?? "Unknown";

          return NeoCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Real App Icon
                app.icon != null
                    ? Image.memory(app.icon!, width: 28, height: 28) // Smaller icon size
                    : const Icon(Icons.android, size: 28, color: Colors.grey),

                const SizedBox(height: 4),

                // App Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                      appName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Pixer',
                          fontSize: 10, // Smaller font size
                          color: colors.textMain
                      )
                  ),
                ),
                const Spacer(),

                // Action Button
                GestureDetector(
                  onTap: () => _toggleGame(appName, !isInstalled),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isInstalled ? AppTheme.hotPink : AppTheme.matrixGreen,
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.5),
                    ),
                    child: Icon(
                        isInstalled ? Icons.remove : Icons.add,
                        size: 12, // Smaller action icon
                        color: Colors.white
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          );
        },
      ),
    );
  }
}