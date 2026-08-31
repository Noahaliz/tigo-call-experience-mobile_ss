import 'package:flutter/material.dart';

class AdminColors {
  static const primary = Color(0xFF0066CC);
  static const navy = Color(0xFF003C71);
  static const bg = Color(0xFFF4F7FB);
  static const muted = Color(0xFF65758B);
}

ThemeData adminTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AdminColors.primary),
  scaffoldBackgroundColor: AdminColors.bg,
  cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
  inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
);
