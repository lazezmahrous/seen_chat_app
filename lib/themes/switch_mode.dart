// ignore_for_file: file_names, unused_element
import 'package:flutter/material.dart';
import 'package:seen/constanc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    colorScheme: ColorScheme.light(primary: Constanc.kOrignalColor),
    iconTheme: IconThemeData(
      color: Constanc.kOrignalColor,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    // brightness: Brightness.dark,
    fontFamily: 'Cairo',
    // s:ColorSchemeSeed.fromSeed(seedColor: Constans.kColor)
    colorScheme: ColorScheme.dark(primary: Constanc.kOrignalColor),
    // iconTheme: IconThemeData(
    //   color: Constans.kColor,
    // ),
    // iconButtonTheme: IconButtonThemeData(
    //   style: ButtonStyle(
    //     iconColor: MaterialStatePropertyAll(Constans.kColor),
    //   ),
    // ),
  );

  static ThemeMode _currentThemeMode = ThemeMode.light; // تعريف المتغير هنا

  static ThemeMode get currentThemeMode => _currentThemeMode;

  static Future<void> toggleThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentThemeMode =
        _currentThemeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await prefs.setInt('theme_mode', _currentThemeMode.index);
  }

  static Future<ThemeMode> getSavedThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return ThemeMode.values[prefs.getInt('theme_mode') ?? 0];
  }
}

ThemeClass _themeClass = ThemeClass();
