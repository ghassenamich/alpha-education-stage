import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    // Primary - Modern Blue Gradient
    primary: Color(0xFF1976D2), // Deep Blue
    onPrimary: Color(0xFF0D47A1), // Darker Blue for text on primary
    
    // Secondary - Complementary Blue
    secondary: Color(0xFF42A5F5), // Light Blue
    onSecondary: Color(0xFF1565C0), // Medium Blue
    
    // Error Colors
    error: Color(0xFFD32F2F), // Material Red
    onError: Color(0xFF424242), // Dark Gray
    
    // Surface Colors - Clean and Modern
    surface: Color(0xFFFAFAFA), // Almost White with subtle warmth
    onSurface: Color(0xFF263238), // Dark Blue Gray for text
    onSurfaceVariant: Color(0xFF90A4AE), // Muted Blue Gray
    
    // Containers
    primaryContainer: Color(0xFFE3F2FD), // Very Light Blue
    onPrimaryContainer: Color(0xFF0D47A1), // Deep Blue
    
    // Additional colors
    tertiary: Color(0xFF37474F), // Blue Gray
  ),
  primaryColor: const Color(0xFF1976D2),
  scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Subtle Gray Background
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFAFAFA),
    foregroundColor: Color(0xFF263238),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    // Primary - Vibrant Blue for Dark Mode
    primary: Color(0xFF42A5F5), // Light Blue that pops on dark
    onPrimary: Color(0xFF0D47A1), // Deep Blue for contrast
    
    // Secondary - Electric Blue
    secondary: Color(0xFF40C4FF), // Cyan Blue
    onSecondary: Color(0xFF0277BD), // Deep Cyan
    
    // Error Colors
    error: Color(0xFFEF5350), // Lighter Red for dark mode
    onError: Color(0xFFFFFFFF), // White text on error
    
    // Surface Colors - Rich Dark Theme
    surface: Color(0xFF121212), // Material Dark Surface
    onSurface: Color(0xFFE0E0E0), // Light Gray text
    onSurfaceVariant: Color(0xFF78909C), // Muted Blue Gray
    
    // Containers
    primaryContainer: Color(0xFF1A237E), // Deep Blue Container
    onPrimaryContainer: Color(0xFF90CAF9), // Light Blue text
    
    // Additional colors
    tertiary: Color(0xFF37474F), // Dark Blue Gray
  ),
  scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Deep Black Background
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Color(0xFFE0E0E0),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
);

// Alternative Color Schemes for Different Aesthetics

// Option 1: Purple/Indigo Theme
ThemeData purpleTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF673AB7), // Deep Purple
    onPrimary: Color(0xFF4527A0), // Darker Purple
    secondary: Color(0xFF9C27B0), // Material Purple
    onSecondary: Color(0xFF7B1FA2), // Deep Magenta
    error: Color(0xFFD32F2F),
    onError: Color(0xFF424242),
    surface: Color(0xFFFAFAFA),
    onSurface: Color(0xFF263238),
    onSurfaceVariant: Color(0xFF90A4AE),
    primaryContainer: Color(0xFFEDE7F6), // Light Purple
    onPrimaryContainer: Color(0xFF4527A0),
    tertiary: Color(0xFF5E35B1),
  ),
  primaryColor: const Color(0xFF673AB7),
  scaffoldBackgroundColor: const Color(0xFFF8F5FF),
);

// Option 2: Green/Teal Theme
ThemeData greenTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF00796B), // Teal
    onPrimary: Color(0xFF004D40), // Dark Teal
    secondary: Color(0xFF26A69A), // Light Teal
    onSecondary: Color(0xFF00695C), // Medium Teal
    error: Color(0xFFD32F2F),
    onError: Color(0xFF424242),
    surface: Color(0xFFFAFAFA),
    onSurface: Color(0xFF263238),
    onSurfaceVariant: Color(0xFF90A4AE),
    primaryContainer: Color(0xFFE0F2F1), // Very Light Teal
    onPrimaryContainer: Color(0xFF004D40),
    tertiary: Color(0xFF4CAF50), // Green accent
  ),
  primaryColor: const Color(0xFF00796B),
  scaffoldBackgroundColor: const Color(0xFFF1F8E9),
);

// Option 3: Orange/Amber Theme
ThemeData orangeTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFFF7043), // Deep Orange
    onPrimary: Color(0xFFD84315), // Darker Orange
    secondary: Color(0xFFFFAB40), // Amber
    onSecondary: Color(0xFFF57C00), // Dark Amber
    error: Color(0xFFD32F2F),
    onError: Color(0xFF424242),
    surface: Color(0xFFFAFAFA),
    onSurface: Color(0xFF263238),
    onSurfaceVariant: Color(0xFF90A4AE),
    primaryContainer: Color(0xFFFFF3E0), // Very Light Orange
    onPrimaryContainer: Color(0xFFD84315),
    tertiary: Color(0xFFFF8A65),
  ),
  primaryColor: const Color(0xFFFF7043),
  scaffoldBackgroundColor: const Color(0xFFFFF8F3),
);