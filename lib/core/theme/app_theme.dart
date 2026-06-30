import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF2A6F97);
  static const Color secondary = Color(0xFF014F86);
  static const Color tertiary = Color(0xFFA9D6E5);

  static final ColorScheme colorScheme = const ColorScheme.light(
    primary: primary,
    secondary: secondary,
    tertiary: tertiary,
    surface: Colors.white,
  ).copyWith(
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: Colors.black,
    onSurface: Colors.black,
    surfaceContainerHighest: tertiary.withAlpha(26),
    outline: secondary,
    shadow: Colors.black,
    inversePrimary: primary,
  );

  static ThemeData get themeData => ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.zero,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondary,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: tertiary.withAlpha(31),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: tertiary,
    ),
  );
}
