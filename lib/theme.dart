import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Gamer Pop Palette ---
  static const Color background = Color(0xFFF4F4F0); // "Old Paper" White
  static const Color textMain = Color(0xFF121212);   // Ink Black

  // Electric Accents
  static const Color cyberYellow = Color(0xFFFFE600); // Arcade Coin
  static const Color electricBlue = Color(0xFF2DE1FC); // Glitch Blue
  static const Color hotPink = Color(0xFFFF006E);     // 80s Neon
  static const Color matrixGreen = Color(0xFF06D6A0); // Success/Online
  static const Color consoleGrey = Color(0xFFE0E0E0); // Controller Plastic

  // The "Ink" properties
  static const Color border = Colors.black;
  static const double borderWidth = 3.0;
  static const double shadowOffset = 5.0; // Deep clicky buttons

  static TextTheme textTheme = TextTheme(
    // PIXER is non-negotiable for the Gamer Feel
    displayLarge: const TextStyle(fontFamily: 'Pixer', fontSize: 36, color: textMain),
    displayMedium: const TextStyle(fontFamily: 'Pixer', fontSize: 24, color: textMain),
    displaySmall: const TextStyle(fontFamily: 'Pixer', fontSize: 18, color: textMain),

    // Space Grotesk feels "Techy" but clean
    bodyLarge: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w700, color: textMain),
    bodyMedium: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w500, color: textMain),
    labelSmall: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.bold, color: textMain.withValues(alpha: 0.6)),
  );

  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: textMain, size: 28),
      brightness: Brightness.light,
    );
  }
}