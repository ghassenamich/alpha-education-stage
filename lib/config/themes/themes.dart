import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 0, 0, 0),
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 48, 48, 48),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    onSurfaceVariant: Colors.white,
    surface: Color.fromARGB(255, 255, 255, 255),
    onSurface: Color.fromARGB(255, 255, 255, 255),
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
    onPrimary: Colors.white,
    secondary: Color.fromARGB(255, 48, 48, 255),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Color.fromARGB(255, 36, 36, 36),
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 48, 48, 255),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 36, 36, 36),
    foregroundColor: Colors.white,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);