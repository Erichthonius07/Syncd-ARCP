import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart'; // New Import
import 'screens/home_screen.dart';
import 'screens/host_screen.dart';
import 'screens/join_screen.dart';
import 'screens/friend_detail_screen.dart';
import 'screens/activity_screen.dart';

// Services
import 'services/friend_service.dart';
import 'services/chat_service.dart';
import 'services/activity_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FriendService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => ActivityService()),
      ],
      child: const SyncApp(),
    ),
  );
}

class SyncApp extends StatelessWidget {
  const SyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sync'd",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => FriendDetailScreen(friendName: args),
          );
        }
        return null;
      },
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(), // New Route
        '/home': (context) => const HomeScreen(),
        '/host': (context) => const HostScreen(),
        '/join': (context) => const JoinScreen(),
        '/activity': (context) => const ActivityScreen(),
      },
    );
  }
}