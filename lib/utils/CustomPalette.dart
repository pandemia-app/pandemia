import 'package:flutter/material.dart';

class CustomPalette {
  static const int primaryValue = 0xFF000000;
  static const MaterialColor text = MaterialColor(
      primaryValue,
      <int, Color>{
        100: Color(0xFFFFFFFF),
        200: Color(0xFFEEEEEE),
        300: Color(0xFFDDDDDD),
        400: Color(0xFFCCCCCC),
        500: Color(0xFFBBBBBB),
        600: Color(0xFFAAAAAA),
        700: Color(0xFF999999)
      }
  );

  static const MaterialColor background = MaterialColor(
      primaryValue,
      <int, Color>{
        100: Color(0xFF888888),
        200: Color(0xFF777777),
        300: Color(0xFF666666),
        400: Color(0xFF555555),
        500: Color(0xFF444444),
        600: Color(0xFF333333),
        700: Color(0xFF222222),
        800: Color(0xFF111111),
        900: Color(0xFF000000)
      }
  );
}