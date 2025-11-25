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

// Services
import 'services/friend_service.dart';
import 'services/chat_service.dart';
import 'services/activity_service.dart';
import 'services/socket_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FriendService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => ActivityService()),
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
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final args = settings.arguments;
          if (args is String) {
            return MaterialPageRoute(builder: (_) => FriendDetailScreen(friendName: args));
          } else if (args is Map) {
            return MaterialPageRoute(builder: (_) => FriendDetailScreen(
                friendName: args['name'],
                isSquad: args['isSquad'] ?? false
            ));
          }
        }
        return null;
      },
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/host': (context) => const HostScreen(),
        '/join': (context) => const JoinScreen(),
        '/activity': (context) => const ActivityScreen(),
        '/games': (context) => const MyGamesScreen(),
      },
    );
  }
}