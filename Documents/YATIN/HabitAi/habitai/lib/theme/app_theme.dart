import 'package:flutter/material.dart';

/// Color palette for light and dark themes
class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF6366F1);
  static const Color lightSecondary = Color(0xFF7353AE);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1E293B);
  static const Color lightSecondaryText = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightSuccess = Color(0xFF10B981);
  static const Color lightError = Color(0xFFEF4444);
  static const Color lightWarning = Color(0xFFF59E0B);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF6366F1);
  static const Color darkSecondary = Color(0xFF7353AE);
  static const Color darkBackground = Color(0xFF1C1C1E);
  static const Color darkSurface = Color(0xFF2A2A3A);
  static const Color darkCard = Color(0xFF2A2A3A);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF374151);
  static const Color darkSuccess = Color(0xFF4ECDC4);
  static const Color darkError = Color(0xFFFF6B6B);
  static const Color darkWarning = Color(0xFFFFD93D);
}

/// Main theme class containing light and dark theme definitions
class AppTheme {
  static const String fontFamily = 'Roboto';

  /// Light Theme Configuration
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,
    dividerColor: AppColors.lightBorder,
    
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
      error: AppColors.lightError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.lightText,
      onBackground: AppColors.lightText,
      onError: Colors.white,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        color: AppColors.lightText,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        color: AppColors.lightText,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        color: AppColors.lightText,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        color: AppColors.lightText,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        color: AppColors.lightText,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        color: AppColors.lightText,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        color: AppColors.lightText,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Caveat',
        fontSize: 18,
        color: AppColors.lightText,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        color: AppColors.lightSecondaryText,
      ),
      labelLarge: TextStyle(
        fontFamily: 'RobotoMono',
        fontSize: 20,
        color: AppColors.lightText,
        fontWeight: FontWeight.bold,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(44, 44),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
      elevation: 2,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightPrimary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),



    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.lightPrimary;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.lightPrimary.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
  );

  /// Dark Theme Configuration
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.darkBorder,
    
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.darkError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkText,
      onBackground: AppColors.darkText,
      onError: Colors.white,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        color: AppColors.darkText,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        color: AppColors.darkText,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        color: AppColors.darkText,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        color: AppColors.darkText,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        color: AppColors.darkText,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        color: AppColors.darkText,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        color: AppColors.darkText,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Caveat',
        fontSize: 18,
        color: AppColors.darkText,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        color: AppColors.darkSecondaryText,
      ),
      labelLarge: TextStyle(
        fontFamily: 'RobotoMono',
        fontSize: 20,
        color: AppColors.darkText,
        fontWeight: FontWeight.bold,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(44, 44),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
      elevation: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkPrimary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),



    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkPrimary;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkPrimary.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
  );
}

/// Extension methods for easy theme access
extension ThemeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get cardColor => Theme.of(this).cardColor;
  Color get surfaceColor => Theme.of(this).colorScheme.surface;
  Color get textColor => Theme.of(this).colorScheme.onBackground;
  Color get secondaryTextColor => isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText;
  Color get borderColor => isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
  
  LinearGradient get primaryGradient => LinearGradient(
    colors: isDarkMode 
      ? [AppColors.darkPrimary, AppColors.darkSecondary]
      : [AppColors.lightPrimary, AppColors.lightSecondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}