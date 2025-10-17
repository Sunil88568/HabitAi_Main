import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBackground = Color(0xFF1C1C1E); // Dark background
  static const Color progressBarElement = Color(0xFF4ECDC4); // Progress green
  static const Color supportingColor1 = Color(0xFF6366F1); // Purple accent
  static const Color supportingColor2 = Color(0xFF7353AE); // Deep purple
  static const Color textColor = Colors.white;
  static const Color disabledColor = Color(0xFF48484A);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryBackground,
    primaryColor: supportingColor1,
    textTheme: TextTheme(
      displayLarge: TextStyle(fontFamily: 'Roboto', fontSize: 32, color: textColor, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: textColor),
      bodyMedium: TextStyle(fontFamily: 'Caveat', fontSize: 18, color: textColor), // Habit font
      labelLarge: TextStyle(fontFamily: 'RobotoMono', fontSize: 20, color: textColor, fontWeight: FontWeight.bold), // Stats numbers
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: supportingColor1,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(44, 44), // Accessible tap target
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF444444),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: supportingColor1)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}