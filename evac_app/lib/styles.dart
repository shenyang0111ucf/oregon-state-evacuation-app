import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static final String _fontNameDefault = 'Quicksand';
  static const Color backgroundColor = Color(0xFF241C35);
  static const Color primaryColor = Color(0xFFF9A826);
  static final Color _secondaryColor = Color(0xFFFF6584);
  static final Color _textColorStrong = Color(0xFFFFFFFF);
  static final Color _noInteractionMaterialColor = Colors.grey[800]!;
  static final Color _snackbarBackground = Color(0xFF141414);
  // static final Color _highlightSwatch = Color(0xFFFFFFFF);
  // static final Color _shadowSwatch = Color(0x33000000);

  static final MaterialColor _primarySwatch = MaterialColor(
    Color(0xFFF9A826).hashCode,
    <int, Color>{
      50: Color(0xFFFFF8E1),
      100: Color(0xFFFFECB3),
      200: Color(0xFFFFE082),
      300: Color(0xFFFFD54F),
      400: Color(0xFFFFCA28),
      500: Color(0xFFF9A826),
      600: Color(0xFFFFA000),
      700: Color(0xFFFF8F00),
      800: Color(0xFFFF6F00),
      900: Color(0xFFFFD96B),
    },
  );

  static final MaterialColor _possibleOtherColors = MaterialColor(
    Color(0xFFF9A826).hashCode,
    <int, Color>{
      00: Color(0xFF241C35),
      01: Color(0xFFF9A826),
      02: Color(0xFFFF6584),
      10: Color(0xFF8FE388),
      11: Color(0xFF58BC82),
      20: Color(0xFFF2F2F2),
      21: Color(0xFFE8D7FF),
      30: Color(0xFF5EB1BF),
      31: Color(0xFFCDEDF6),
      40: Color(0xFF91171F),
      41: Color(0xFF85FFC7),
    },
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    primarySwatch: _primarySwatch,
    primaryColor: primaryColor,
    accentColor: _secondaryColor,
    backgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      titleTextStyle: navBarTitle,
      backgroundColor: backgroundColor,
    ),
    snackBarTheme: snackbar,
  );

  static final darkCupertinoTheme = Styles.darkTheme.copyWith(
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: Brightness.dark,
      barBackgroundColor: Styles.backgroundColor,
      textTheme: CupertinoTextThemeData(
        textStyle: Styles.normalText.copyWith(fontSize: 24),
      ),
    ),
    outlinedButtonTheme: Styles.outlinedButtonTheme,
    textButtonTheme: Styles.textButtonTheme,
  );

  static final normalText = GoogleFonts.getFont(
    _fontNameDefault,
    color: _textColorStrong,
    fontWeight: FontWeight.w500,
  );

  static final boldText = GoogleFonts.getFont(
    _fontNameDefault,
    color: _textColorStrong,
    fontWeight: FontWeight.w800,
  );

  static final boldAccentText = GoogleFonts.getFont(
    _fontNameDefault,
    color: primaryColor,
    fontWeight: FontWeight.w800,
  );

  static final navBarTitle = GoogleFonts.getFont(
    _fontNameDefault,
    color: primaryColor,
    fontWeight: FontWeight.w800,
  );

  static final timerText = GoogleFonts.getFont(
    _fontNameDefault,
    color: _textColorStrong,
    fontWeight: FontWeight.w800,
    fontSize: 90,
  );

  static final duringDrillDashLabel = GoogleFonts.getFont(
    _fontNameDefault,
    color: _textColorStrong,
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  static final duringDrillDashData = GoogleFonts.getFont(
    _fontNameDefault,
    color: _textColorStrong,
    fontWeight: FontWeight.w800,
    fontSize: 48,
  );

  static final snackbar = SnackBarThemeData(
    actionTextColor: _textColorStrong,
    backgroundColor: _snackbarBackground,
    contentTextStyle: Styles.boldAccentText,
    shape: RoundedRectangleBorder(),
  );

  static final outlinedButtonTheme = OutlinedButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all(
        Size(150.0, 60.0),
      ),
      side: MaterialStateProperty.resolveWith(
        (Set<MaterialState> state) {
          if (state.contains(MaterialState.disabled)) {
            return BorderSide(
              color: _noInteractionMaterialColor,
            );
          }
          return BorderSide(
            color: primaryColor,
          );
        },
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      textStyle: MaterialStateProperty.resolveWith(
        (Set<MaterialState> state) {
          if (state.contains(MaterialState.disabled)) {
            return normalText.copyWith(
              color: _noInteractionMaterialColor,
            );
          }
          return normalText.copyWith(
            color: primaryColor,
          );
        },
      ),
    ),
  );

  static final textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        normalText.copyWith(
          color: primaryColor,
        ),
      ),
    ),
  );

  static final landingPageButton = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(9.6),
      ))
      // decoration: BoxDecoration(
      //                                 borderRadius: BorderRadius.circular(9.6),
      //                                 color: Colors.white),
      );
}
