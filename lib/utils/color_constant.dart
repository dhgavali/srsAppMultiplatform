import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray600 = fromHex('#818181');

  static Color tealA700 = fromHex('#14b5ac');

  static Color blue900 = fromHex('#0037c3');

  static Color gray400 = fromHex('#b6b6b6');

  static Color blueGray400 = fromHex('#8e8e8e');

  static Color blueA100 = fromHex('#7aa6f3');

  static Color gray200 = fromHex('#efefef');

  static Color black9003f = fromHex('#3f000000');

  static Color gray300 = fromHex('#e6e6e6');

  static Color black900 = fromHex('#000000');

  static Color indigoA700 = fromHex('#0047ff');

  static Color bluegray400 = fromHex('#888888');

  static Color gray20001 = fromHex('#e7e7e7');

  static Color deepOrange400 = fromHex('#ec7f44');

  static Color whiteA700 = fromHex('#ffffff');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
