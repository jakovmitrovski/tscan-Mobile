import 'dart:ui';
import 'package:flutter/material.dart';

class Utils {
  static Color hexToColor(String hex) {
    assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
    'hex color must be #rrggbb or #rrggbbaa');

    return Color(
      int.parse(hex.substring(1), radix: 16) +
          (hex.length == 7 ? 0xff000000 : 0x00000000),
    );
  }

  static TextStyle getFont({
    String fontFamily = 'Roboto',
    fontWeight = FontWeight.w400,
    fontSize = 18.0,
    color = Colors.black
}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color
    );
  }
}