import 'package:flutter/material.dart';

/// This is utility convert data for app
///
class ConvertData {

  /// Convert String to int
  static int stringToInt([dynamic value = '0', int initValue = 0]) {
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? initValue;
    }
    return initValue;
  }

  ///
  /// Convert color from hex
  static Color? fromHex(String hex, [defaultColor = Colors.white]) {
    if (!RegExp(r'^#+([a-fA-F0-9]{6}|[a-fA-F0-9]{5}|[a-fA-F0-9]{3})$').hasMatch(hex)) {
      return defaultColor;
    }
    String color = hex.replaceAll('#', '');
    String value = color.length == 6 ? color : '';
    if (value.length != 6) {
      if (color.length == 3) {
        for (int i = 0; i < color.length; i++) {
          value = '$value${color[i]}${color[i]}';
        }
      } else if (color.length == 5) {
        value = '${color.substring(0, 4)}0${color[4]}';
      }
    }
    return Color(int.parse('0xff$value'));
  }
}
