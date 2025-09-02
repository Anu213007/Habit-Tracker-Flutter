import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Studio Ghibli-inspired color palette
  static const Color parchmentBackground = Color(0xFFFFF5E1);
  static const Color cardBackground = Color(0xFFFFFDF5);
  static const Color warmBrown = Color(0xFF8D6E63);
  static const Color softYellow = Color(0xFFFFE082);
  static const Color sageGreen = Color(0xFFA5D6A7);
  static const Color softBlue = Color(0xFF90CAF9);
  static const Color gentlePink = Color(0xFFF8BBD9);
  static const Color mutedText = Color(0xFF6D4C41);
  static const Color accentOrange = Color(0xFFFFB74D);
  
  // Dark theme colors
  static const Color darkBackground = Color(0xFF2C2C2C);
  static const Color darkCard = Color(0xFF3C3C3C);
  static const Color darkText = Color(0xFFE0E0E0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: warmBrown,
        secondary: sageGreen,
        surface: cardBackground,
        background: parchmentBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: mutedText,
        onBackground: mutedText,
      ),
      scaffoldBackgroundColor: parchmentBackground,
      cardTheme: const CardThemeData(
        color: cardBackground,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cardBackground,
        foregroundColor: warmBrown,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.sawarabiMincho(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: warmBrown,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sawarabiMincho(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: warmBrown,
        ),
        displayMedium: GoogleFonts.sawarabiMincho(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: warmBrown,
        ),
        displaySmall: GoogleFonts.sawarabiMincho(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: warmBrown,
        ),
        headlineLarge: GoogleFonts.sawarabiMincho(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: warmBrown,
        ),
        headlineMedium: GoogleFonts.sawarabiMincho(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: warmBrown,
        ),
        headlineSmall: GoogleFonts.sawarabiMincho(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: warmBrown,
        ),
        titleLarge: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: mutedText,
        ),
        titleMedium: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: mutedText,
        ),
        titleSmall: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: mutedText,
        ),
        bodyLarge: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: mutedText,
        ),
        bodyMedium: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: mutedText,
        ),
        bodySmall: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: mutedText,
        ),
        labelLarge: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: warmBrown,
        ),
        labelMedium: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: warmBrown,
        ),
        labelSmall: GoogleFonts.quicksand(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: warmBrown,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: warmBrown,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: warmBrown.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: warmBrown,
          side: const BorderSide(color: warmBrown, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: warmBrown, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: warmBrown.withOpacity(0.5), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: warmBrown, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: GoogleFonts.quicksand(
          color: mutedText,
          fontSize: 16,
        ),
        hintStyle: GoogleFonts.quicksand(
          color: mutedText.withOpacity(0.6),
          fontSize: 16,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return warmBrown;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: warmBrown,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: sageGreen,
        secondary: softBlue,
        surface: darkCard,
        background: darkBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkText,
        onBackground: darkText,
      ),
      scaffoldBackgroundColor: darkBackground,
      cardTheme: const CardThemeData(
        color: darkCard,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkCard,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.sawarabiMincho(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sawarabiMincho(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        displayMedium: GoogleFonts.sawarabiMincho(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        displaySmall: GoogleFonts.sawarabiMincho(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        headlineLarge: GoogleFonts.sawarabiMincho(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        headlineMedium: GoogleFonts.sawarabiMincho(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        headlineSmall: GoogleFonts.sawarabiMincho(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        titleLarge: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        titleMedium: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        titleSmall: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        bodyLarge: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: darkText,
        ),
        bodyMedium: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: darkText,
        ),
        bodySmall: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: darkText,
        ),
        labelLarge: GoogleFonts.quicksand(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: sageGreen,
        ),
        labelMedium: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: sageGreen,
        ),
        labelSmall: GoogleFonts.quicksand(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: sageGreen,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: sageGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: sageGreen.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: sageGreen,
          side: const BorderSide(color: sageGreen, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: sageGreen, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: sageGreen.withOpacity(0.5), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: sageGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: GoogleFonts.quicksand(
          color: darkText,
          fontSize: 16,
        ),
        hintStyle: GoogleFonts.quicksand(
          color: darkText.withOpacity(0.6),
          fontSize: 16,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return sageGreen;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: sageGreen,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
