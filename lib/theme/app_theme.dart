import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary      = Color(0xFFDC2626);
  static const Color primaryLight = Color(0xFFF87171);
  static const Color primaryDark  = Color(0xFF991B1B);
  static const Color background   = Color(0xFFFFFFFF);
  static const Color surface      = Color(0xFFFEF2F2);
  static const Color textDark     = Color(0xFF111827);
  static const Color textMuted    = Color(0xFF6B7280);
  static const Color divider      = Color(0xFFE5E7EB);
  static const Color success      = Color(0xFF16A34A);
  static const Color warning      = Color(0xFFD97706);
  static const Color info         = Color(0xFF2563EB);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: background,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 19,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: divider, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(color: textMuted, fontSize: 14),
      hintStyle: GoogleFonts.poppins(color: textMuted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: textMuted,
      indicatorColor: primary,
      dividerColor: Colors.transparent,
      labelStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 14),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    dividerTheme: const DividerThemeData(
      color: divider,
      thickness: 1,
      space: 1,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w700, fontSize: 24),
      headlineMedium: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w600, fontSize: 20),
      titleLarge: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w600, fontSize: 18),
      bodyLarge: GoogleFonts.poppins(color: textDark, fontSize: 14),
      bodyMedium: GoogleFonts.poppins(color: textMuted, fontSize: 12),
      labelLarge: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
    ),
  );
}
