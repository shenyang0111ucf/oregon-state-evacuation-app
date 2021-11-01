import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static final String _fontNameDefault = 'Quicksand';
  static final Color _backgroundColor = Color(0xFF241C35);
  static final Color _primarySwatch = Color(0xFFF9A826);
  static final Color _secondarySwatch = Color(0xFFFF6584);
  // static final Color _highlightSwatch = Color(0xFFFFFFFF);
  // static final Color _shadowSwatch = Color(0x33000000);
  static final Color _textColorStrong = Color(0xFFFFFFFF);

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _backgroundColor,
    primarySwatch: MaterialColor(
      _primarySwatch.hashCode,
      {900: _primarySwatch},
    ),
    accentColor: _secondarySwatch,
    appBarTheme: AppBarTheme(titleTextStyle: navBarTitle),
    snackBarTheme: snackyTheme,
  );

  static final normalText = GoogleFonts.getFont(
    _fontNameDefault,
    color: _textColorStrong,
    fontWeight: FontWeight.w500,
    fontSize: 12,
  );

  static final boldText = GoogleFonts.getFont(
    _fontNameDefault,
    color: _textColorStrong,
    fontWeight: FontWeight.w800,
  );

  static final boldAccentText = GoogleFonts.getFont(
    _fontNameDefault,
    color: _primarySwatch,
    fontWeight: FontWeight.w800,
  );

  static final navBarTitle = GoogleFonts.getFont(
    _fontNameDefault,
    color: _primarySwatch,
    fontWeight: FontWeight.w800,
  );

  static final snackyTheme = SnackBarThemeData(
    actionTextColor: _primarySwatch,
    backgroundColor: _backgroundColor,
    contentTextStyle: Styles.boldAccentText,
    shape: RoundedRectangleBorder(),
  );
}
