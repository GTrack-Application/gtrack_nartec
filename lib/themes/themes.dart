import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtrack_mobile_app/global/common/colors/my_colors.dart';

class Themes {
  static ThemeData? lightTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF0D117F),
      primarySwatch: const MaterialColor(
        0xFF0D117F, // The primary color value in hexadecimal
        <int, Color>{
          50: Color(0xFFE2E4F7),
          100: Color(0xFFB6BAE8),
          200: Color(0xFF898FD8),
          300: Color(0xFF5D64C8),
          400: Color(0xFF3A43BB),
          500: Color(0xFF0D117F), // The primary color value in hexadecimal
          600: Color(0xFF0C0F6D),
          700: Color(0xFF0A0D5A),
          800: Color(0xFF080B47),
          900: Color(0xFF060935),
        },
      ),
      brightness: Brightness.light,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF0D117F),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF0D117F),
        textTheme: ButtonTextTheme.primary,
        padding: EdgeInsets.all(5),
      ),
      appBarTheme: AppBarTheme(
        color: const Color(0xFF0D117F),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ).bodyMedium,
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ).titleLarge,
      ),

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 72.0,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Inter',
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
          fontFamily: 'Inter',
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MyColors.primary,
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  static ThemeData? darkTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFF0D117F),
      primarySwatch: const MaterialColor(
        0xFF0D117F, // The primary color value in hexadecimal
        <int, Color>{
          50: Color(0xFFE2E4F7),
          100: Color(0xFFB6BAE8),
          200: Color(0xFF898FD8),
          300: Color(0xFF5D64C8),
          400: Color(0xFF3A43BB),
          500: Color(0xFF0D117F), // The primary color value in hexadecimal
          600: Color(0xFF0C0F6D),
          700: Color(0xFF0A0D5A),
          800: Color(0xFF080B47),
          900: Color(0xFF060935),
        },
      ),
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        color: const Color(0xFF0D117F),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ).bodyMedium,
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ).titleLarge,
      ),

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 72.0,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: 20.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Inter',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF0D117F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF0D117F),
        textTheme: ButtonTextTheme.primary,
        padding: EdgeInsets.all(5),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
