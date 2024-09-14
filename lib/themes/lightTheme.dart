import 'package:codesleuth/themes/customColors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color(0XFFebe9e6),
    primary: customeLightBlueColor,
    secondary: Colors.blueAccent
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(color: Colors.black, fontFamily: 'Sansation'),
    bodyMedium: TextStyle(color: Colors.black, fontFamily: 'DMSans'),
    labelMedium: TextStyle(color: Colors.black, fontFamily: 'Sansation')
  ),
);