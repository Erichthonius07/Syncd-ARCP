import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Core Palette
  static const Color deepCharcoal = Color(0xFF1B1717);
  static const Color tealCyan = Color(0xFF00BFA6);
  static const Color vividPink = Color(0xFFFF4081);
  static const Color softOffWhite = Color(0xFFF5F5F5);
  static const Color mutedGray = Color(0xFF888888);

  // Accent colors derived from the core palette
  static final Color tealCyanAccent = tealCyan.withAlpha(100);
  static final Color vividPinkAccent = vividPink.withAlpha(100);

  // 🌐 ThemeData
  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: deepCharcoal,
      // Sets the default font, but we will also be explicit below
      fontFamily: 'Pixer',
      colorScheme: const ColorScheme.dark(
        primary: tealCyan,
        secondary: vividPink,
        surface: deepCharcoal,
        onPrimary: softOffWhite,
        onSecondary: softOffWhite,
        onSurface: mutedGray,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: deepCharcoal,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: softOffWhite,
          // ✅ Explicitly set the font for the AppBar
          fontFamily: 'Pixer',
        ),
        iconTheme: IconThemeData(
          color: softOffWhite,
        ),
      ),
      textTheme: const TextTheme(
        // ✅ Your pixelated headline font
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: softOffWhite,
          fontFamily: 'Pixer',
        ),
        // A standard, readable font for body text
        bodyMedium: TextStyle(
          fontSize: 16,
          color: mutedGray,
          fontFamily: 'Roboto', // We'll keep this readable for paragraphs
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tealCyan,
          foregroundColor: softOffWhite,
          shadowColor: tealCyanAccent,
          elevation: 8,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            // ✅ Explicitly set the font for buttons
            fontFamily: 'Pixer',
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: vividPink, width: 2),
          foregroundColor: vividPink,
          backgroundColor: vividPinkAccent.withAlpha(25),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            // ✅ Explicitly set the font for buttons
            fontFamily: 'Pixer',
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
    );
  }
}