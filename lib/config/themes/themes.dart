import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Color.fromARGB(255, 0, 0, 0),
    secondary: Color.fromARGB(255, 0, 0, 0),
    onSecondary:  Color.fromARGB(255, 1, 0, 34),
    error: Color.fromARGB(255, 172, 11, 0),
    onError: Colors.white,
    surface: Color.fromARGB(255, 255, 255, 255),
    onSurface: Color.fromARGB(255, 205, 229, 255),
    onSurfaceVariant: Color.fromARGB(255, 255, 255, 255),
  ),
  primaryColor: const Color.fromARGB(255, 70, 172, 255),
  scaffoldBackgroundColor: const Color.fromARGB(255, 48, 48, 255),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 255, 255, 255),
    foregroundColor: Color.fromARGB(255, 0, 0, 0),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 255, 255, 255),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color.fromARGB(255, 255, 255, 255),
    onSecondary: Color.fromARGB(255, 167, 191, 236),
    error: Colors.red,
    onError: Colors.white,
    surface: Color.fromARGB(255, 36, 36, 36),
    onSurfaceVariant: Color.fromARGB(255, 0, 9, 20),
    onSurface: Color.fromARGB(255, 0, 33, 68),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 48, 48, 255),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 36, 36, 36),
    foregroundColor: Colors.white,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);