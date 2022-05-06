import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewStyles {
  static final String fontNameDefault = 'Open Sans';

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    // primarySwatch: MaterialColor(Color(0xFFF3643b).hashCode, <int, Color>{}),
    // scaffoldBackgroundColor: Colors.white,
    // textTheme: TextTheme()
  );

  static final normalText = GoogleFonts.getFont(
    fontNameDefault,
    color: Colors.black,
    fontWeight: FontWeight.w500,
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
              color: Colors.grey,
            );
          }
          return BorderSide(
            color: Colors.black,
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
              color: Colors.grey,
            );
          }
          return normalText.copyWith(
            color: Colors.black,
          );
        },
      ),
    ),
  );
}
