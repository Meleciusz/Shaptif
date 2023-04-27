import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.red,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,

      disabledColor: Colors.grey,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      canvasColor: isDarkTheme ? Color.fromARGB(100, 31, 31, 31) : Colors.grey[50],

      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
    );

  }
}