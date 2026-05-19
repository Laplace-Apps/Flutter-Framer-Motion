import 'package:flutter/material.dart';

abstract final class DemoTheme {
  static const bg = Color(0xFF0D1117);
  static const surface = Color(0xFF161B22);
  static const border = Color(0xFF30363D);
  static const accent = Color(0xFF58A6FF);
  static const accentMuted = Color(0xFF388BFD);
  static const text = Color(0xFFE6EDF3);
  static const muted = Color(0xFF8B949E);
  static const codeBg = Color(0xFF0D1117);

  static ThemeData materialTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      fontFamily: 'monospace',
      colorScheme: const ColorScheme.dark(
        primary: accent,
        surface: surface,
      ),
    );
  }
}
