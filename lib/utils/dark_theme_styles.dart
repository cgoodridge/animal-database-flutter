import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,

      scaffoldBackgroundColor: isDarkTheme ? const Color(0xFF151515) : Color(0xffececec),
      iconTheme: IconThemeData(color: isDarkTheme ? Color(0xffececec) : Color(0xFF151515)),
      primaryIconTheme: IconThemeData(color: isDarkTheme ? Color(0xffececec) : Color(0xFF151515)),
      // primaryIconTheme: colo,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),

      hintColor: isDarkTheme ? Color(0xffececec) : Color(0xFF151515),

      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xffe0e0e0),

      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Color(0xFF151515) : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
      textSelectionTheme: TextSelectionThemeData(selectionColor: isDarkTheme ? Colors.white : Colors.black),
    );

  }
}