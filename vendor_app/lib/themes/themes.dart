import 'package:flutter/material.dart';

class MyThemeData {
  static MaterialAccentColor colorPrimary = Colors.deepPurpleAccent;
  static MaterialAccentColor buttonColor = Colors.deepPurpleAccent;
  static Color iconColor = Colors.black;
  static Color textColor = Colors.black;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    // Floating Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: buttonColor,
      elevation: 0,
    ),

    // Elevated Button design
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
      ),
    ),

    // Input Fields Design e.g TextField
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: colorPrimary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: colorPrimary,
          width: 1.00,
        ),
      ),
    ),

    // AppBar Design
    appBarTheme: AppBarTheme(
      backgroundColor: colorPrimary,
    ),

    // BottomAppBAr Design
    bottomAppBarTheme: BottomAppBarTheme(color: colorPrimary),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
      ),
    ),
  );
}
