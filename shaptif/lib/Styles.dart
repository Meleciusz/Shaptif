import 'package:flutter/material.dart';

class Styles {

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.red,


      useMaterial3: true,
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
        color: isDarkTheme ? Colors.black : Colors.white
      ),
      primaryColor: isDarkTheme ? Colors.black : Colors.white,

      listTileTheme: Theme.of(context).listTileTheme.copyWith(
        iconColor: Colors.yellowAccent,
      ),



      disabledColor: Colors.grey,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      canvasColor: isDarkTheme ? Color.fromARGB(255, 31, 31, 31) : Colors.grey[50],

      drawerTheme: Theme.of(context).drawerTheme.copyWith(
        backgroundColor: isDarkTheme ? Color.fromARGB(255, 31, 31, 31) : Colors.grey[50],
      ),

      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
    );

  }
}