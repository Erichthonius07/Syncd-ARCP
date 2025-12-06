import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  // LOCKED: Always Light Mode
  ThemeMode themeMode = ThemeMode.light;
  bool get isDarkMode => false; // Always false

// Removed toggleTheme()
}

class SyncPalette {
  final Color background;
  final Color surface;
  final Color outline;
  final Color textMain;
  final Color textSub;
  final Color actionHost;
  final Color actionJoin;
  final Color actionLibrary;
  final Color actionInbox;
  final Color success;
  final Color accentIcon;

  const SyncPalette({
    required this.background,
    required this.surface,
    required this.outline,
    required this.textMain,
    required this.textSub,
    required this.actionHost,
    required this.actionJoin,
    required this.actionLibrary,
    required this.actionInbox,
    required this.success,
    required this.accentIcon,
  });
}

class AppTheme {
  // --- RAW COLORS ---
  static const Color cyberYellow = Color(0xFFFFE600);
  static const Color electricBlue = Color(0xFF2DE1FC);
  static const Color hotPink = Color(0xFFFF006E);
  static const Color matrixGreen = Color(0xFF06D6A0);

  // --- PALETTE (Single Source of Truth) ---
  static const lightPalette = SyncPalette(
    background: Color(0xFFF4F4F0), // Cream
    surface: Colors.white,
    outline: Colors.black, // Hard Ink
    textMain: Colors.black,
    textSub: Colors.grey,
    actionHost: hotPink,
    actionJoin: cyberYellow,
    actionLibrary: electricBlue,
    actionInbox: Colors.white,
    success: matrixGreen,
    accentIcon: Colors.black,
  );

  // Helper: Always returns Light Palette
  static SyncPalette c(BuildContext context) => lightPalette;

  static ThemeData get lightTheme => _buildTheme(lightPalette);
  // Dark theme is just Light theme now (Fallback)
  static ThemeData get darkTheme => _buildTheme(lightPalette);

  static ThemeData _buildTheme(SyncPalette palette) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: palette.background,
      primaryColor: palette.actionHost,
      cardColor: palette.surface,
      dividerColor: palette.outline,
      iconTheme: IconThemeData(color: palette.accentIcon, size: 28),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: 'Pixer', fontSize: 36, color: palette.textMain),
        displayMedium: TextStyle(fontFamily: 'Pixer', fontSize: 24, color: palette.textMain),
        displaySmall: TextStyle(fontFamily: 'Pixer', fontSize: 18, color: palette.textMain),
        bodyLarge: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w700, color: palette.textMain),
        bodyMedium: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w500, color: palette.textMain),
        labelSmall: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.bold, color: palette.textMain.withValues(alpha: 0.6)),
      ),
    );
  }

  static const double borderWidth = 3.0;
  static const double shadowOffset = 5.0;

  static const Color consoleGreyLight = Color(0xFFE0E0E0);
  static const Color consoleGreyDark = Color(0xFF2C2C2C);
}