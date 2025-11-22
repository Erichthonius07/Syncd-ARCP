import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. Theme Provider to manage state
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppTheme {
  // --- PALETTE ---
  static const Color cyberYellow = Color(0xFFFFE600);
  static const Color electricBlue = Color(0xFF2DE1FC);
  static const Color hotPink = Color(0xFFFF006E);
  static const Color matrixGreen = Color(0xFF06D6A0);

  // Light Mode Colors
  static const Color bgLight = Color(0xFFF4F4F0);
  static const Color textLight = Color(0xFF121212);
  static const Color cardLight = Colors.white;
  static const Color consoleGreyLight = Color(0xFFE0E0E0);

  // Dark Mode Colors
  static const Color bgDark = Color(0xFF121212);
  static const Color textDark = Color(0xFFF4F4F0);
  static const Color cardDark = Color(0xFF1E1E1E); // Dark Grey
  static const Color consoleGreyDark = Color(0xFF2C2C2C);

  static const double borderWidth = 3.0;
  static const double shadowOffset = 5.0;

  // --- TEXT STYLES (Dynamic Color) ---
  static TextTheme _buildTextTheme(Color color) {
    return TextTheme(
      displayLarge: TextStyle(fontFamily: 'Pixer', fontSize: 36, color: color),
      displayMedium: TextStyle(fontFamily: 'Pixer', fontSize: 24, color: color),
      displaySmall: TextStyle(fontFamily: 'Pixer', fontSize: 18, color: color),
      bodyLarge: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w700, color: color),
      bodyMedium: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w500, color: color),
      labelSmall: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.bold, color: color.withValues(alpha: 0.6)),
    );
  }

  // --- THEME DATA GENERATORS ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgLight,
      primaryColor: electricBlue,
      iconTheme: const IconThemeData(color: textLight, size: 28),
      textTheme: _buildTextTheme(textLight),
      cardColor: cardLight,
      dividerColor: Colors.black,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: electricBlue,
      iconTheme: const IconThemeData(color: textDark, size: 28),
      textTheme: _buildTextTheme(textDark),
      cardColor: cardDark,
      dividerColor: Colors.white, // Borders become white in dark mode
    );
  }
}