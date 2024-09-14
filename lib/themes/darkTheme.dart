import 'package:codesleuth/themes/customColors.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: customBackgroundColor,
    primary: customeLightBlueColor,
    secondary: Colors.white
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(color: customTextColor, fontFamily: 'Sansation'),
    bodyMedium: TextStyle(color: customTextColor, fontFamily: 'DMSans'),
    labelMedium: TextStyle(color: customTextColor, fontFamily: 'Sansation')
  ),
);