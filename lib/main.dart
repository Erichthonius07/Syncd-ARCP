import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/host_screen.dart';
import 'screens/join_screen.dart';
import 'screens/friend_detail_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/my_games_screen.dart';
import 'screens/controller_screen.dart';

// Services & Providers
import 'services/friend_service.dart';
import 'services/chat_service.dart';
import 'services/activity_service.dart';
import 'services/socket_service.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // 1. Theme State
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // 2. Data Services
        // Note: AuthService is used internally by AuthProvider, so we don't need to provide it directly here
        // unless other parts of the app need direct access to the raw service.
        // If you want to access AuthService directly, uncomment the next line:
        // Provider(create: (_) => AuthService()),

        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FriendService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => ActivityService()),

        // 3. Backend Services
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: const SyncApp(),
    ),
  );
}

class SyncApp extends StatelessWidget {
  const SyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: "Sync'd",
      debugShowCheckedModeBanner: false,

      // --- THEME SETUP ---
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // --- ROUTING ---
      initialRoute: '/',

      // Handle routes with arguments (like Chat)
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final args = settings.arguments;
          if (args is String) {
            return MaterialPageRoute(
                builder: (_) => FriendDetailScreen(friendName: args)
            );
          } else if (args is Map) {
            return MaterialPageRoute(
                builder: (_) => FriendDetailScreen(
                    friendName: args['name'],
                    isSquad: args['isSquad'] ?? false
                )
            );
          }
        }
        return null;
      },

      // Static Routes
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/host': (context) => const HostScreen(),
        '/join': (context) => const JoinScreen(),
        '/activity': (context) => const ActivityScreen(),
        '/games': (context) => const MyGamesScreen(),
        // Ensure gameCode is passed or defaulted if accessed via route name
        '/controller': (context) => const ControllerScreen(gameCode: "DEMO"),
      },
    );
  }
}