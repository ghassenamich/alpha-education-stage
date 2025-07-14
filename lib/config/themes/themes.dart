import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 16, 138, 238),
    onPrimary: Color.fromARGB(255, 0, 79, 143),
    secondary: Color.fromARGB(255, 36, 156, 255),
    onSecondary: Color.fromARGB(255, 34, 156, 255),
    error: Color.fromARGB(255, 172, 11, 0),
    onError: Color.fromARGB(255, 66, 66, 66),
    surface: Color.fromARGB(255, 255, 255, 255),
    onSurface: Color.fromARGB(255, 180, 216, 255),
    onSurfaceVariant: Color.fromARGB(255, 236, 245, 255),
    primaryContainer: Color.fromARGB(255, 164, 213, 253),
    onPrimaryContainer:  Color.fromARGB(255, 53, 148, 246),
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
    primary: Color.fromARGB(255, 33, 149, 245),
    onPrimary: Color.fromARGB(255, 0, 106, 192),
    secondary: Color.fromARGB(255, 0, 122, 223),
    onSecondary: Color.fromARGB(255, 0, 108, 197),
    error: Colors.red,
    onError: Colors.white,
    surface: Color.fromARGB(255, 23, 51, 92),
    onSurfaceVariant: Color.fromARGB(255, 0, 9, 20),
    onSurface: Color.fromARGB(255, 0, 33, 68),
    primaryContainer: Color.fromARGB(255, 52, 113, 183),
    onPrimaryContainer: Color.fromARGB(255, 44, 117, 214)
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 48, 48, 255),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 36, 36, 36),
    foregroundColor: Colors.white,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);
