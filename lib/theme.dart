import 'package:flutter/material.dart';

final lightThemeData = ThemeData(useMaterial3: true);
final darkThemeData = ThemeData.dark(useMaterial3: true);

bool isDarkMode(BuildContext context){
  return Theme.of(context).brightness == Brightness.dark;
}