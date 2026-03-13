bool toBool(dynamic value, {bool defaultValue = false}) {
  if (value is bool) {
    return value;
  }
  if (value is int) {
    return value == 1;
  }
  if (value is String) {
    return value == '1' || value == 'true';
  }
  return defaultValue;
}

int toInt(dynamic value, {int defaultValue = 0}) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? defaultValue;
  }
  return defaultValue;
}

String toStr(dynamic value, {String defaultValue = ''}) {
  if (value is String) {
    return value;
  }
  if (value is int || value is double || value is bool || value is num) {
    return value.toString();
  }
  return defaultValue;
}
