import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/activity_service.dart';
import 'services/chat_service.dart';
import 'services/game_service.dart';
import 'services/friend_service.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameService()),
        ChangeNotifierProvider(create: (context) => FriendService()),
        ChangeNotifierProvider(create: (context) => ActivityService()),
        ChangeNotifierProvider(create: (context) => ChatService()),
      ],
      child: const SyncdApp(),
    ),
  );
}

class SyncdApp extends StatelessWidget {
  const SyncdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sync'd",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}