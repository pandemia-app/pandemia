import 'package:flutter/material.dart';

class CustomPalette {
  static const MaterialColor palette = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFAAAAAA),
      200: Color(0xFF666666),
      300: Color(0xFF222222),
      400: Color(0xFF000000),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF333333),
      700: Color(0xFF222222),
      800: Color(0xFF444444),
      900: Color(0xFF44FFAA),
    },
  );
  static const int _blackPrimaryValue = 0xFF000000;
}