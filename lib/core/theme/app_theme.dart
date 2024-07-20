import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFFFFFFFF),
      ),
      bodySmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: Color(0xFFFFFFFF),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: InputBorder.none,
      errorBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      isDense: false,
    ),
  );
}
