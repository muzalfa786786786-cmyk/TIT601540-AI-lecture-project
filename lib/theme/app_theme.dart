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

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: background,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        color: textDark, fontSize: 19, fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: textDark),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: divider),
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: textMuted,
      indicatorColor: primary,
    ),
  );
}
