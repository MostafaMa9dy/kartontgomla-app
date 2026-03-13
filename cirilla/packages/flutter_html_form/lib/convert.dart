import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

/// Convert any value to bool or null
bool? convertToBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value == "" || value == "true" || value == 1 || value == "1") {
    return true;
  }

  if (value == "false" || value == 0 || value == "0") {
    return false;
  }

  return null;
}

double? convertStringToDoubleCanBeNull(dynamic value, [double? defaultValue]) {
  if (value == null || value == "") {
    return defaultValue;
  }

  if (value is int) {
    return value.toDouble();
  }

  if (value is double) {
    return value;
  }

  if (value is String) {
    return double.tryParse(value) ?? defaultValue;
  }

  return defaultValue;
}

int? convertStringToIntCanBeNull(dynamic value, [int? defaultValue]) {
  if (value == null || value == "") {
    return defaultValue;
  }

  if (value is double) {
    return value.toInt();
  }

  if (value is int) {
    return value;
  }

  if (value is String) {
    return int.tryParse(value) ?? defaultValue;
  }

  return defaultValue;
}

EdgeInsets convertToMargins(Margins? margin, TextDirection direction) {
  Margin? top = margin?.top;
  Margin? bottom = margin?.bottom;
  Margin? left = margin?.left;
  Margin? right = margin?.right;
  Margin? blockStart = margin?.blockStart;
  Margin? blockEnd = margin?.blockEnd;
  Margin? inlineStart = margin?.inlineStart;
  Margin? inlineEnd = margin?.inlineEnd;

  late double? leftPad;
  late double? rightPad;
  double? topPad = top?.value ?? blockStart?.value ?? 0;
  double? bottomPad = bottom?.value ?? blockEnd?.value ?? 0;

  switch (direction) {
    case TextDirection.rtl:
      leftPad = left?.value ?? inlineEnd?.value ?? 0;
      rightPad = right?.value ?? inlineStart?.value ?? 0;
      break;
    case TextDirection.ltr:
      leftPad = left?.value ?? inlineStart?.value ?? 0;
      rightPad = right?.value ?? inlineEnd?.value ?? 0;
      break;
  }

  return EdgeInsets.fromLTRB(leftPad, topPad, rightPad, bottomPad);
}
