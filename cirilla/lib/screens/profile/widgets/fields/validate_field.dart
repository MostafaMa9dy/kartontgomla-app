import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';

String? validateField({
  required TranslateType translate,
  bool requiredInput = true,
  required List validate,
  String? value,
}) {
  String valueField = value ?? "";

  if (requiredInput && valueField.isEmpty) {
    return translate('validate_not_null');
  }

  if (valueField != "" && validate.contains('email')) {
    return emailValidator(value: valueField, errorEmail: translate('validate_email_value'));
  }

  if (valueField != "" && validate.contains('phone')) {
    return phoneValidator(value: valueField, errorPhone: translate('validate_phone_value'));
  }

  return null;
}

String? validateFieldNumber({
  required TranslateType translate,
  bool requiredInput = true,
  String? value,
  int? min,
  int? max,
}) {
  if (requiredInput && (value == null || value.isEmpty)) {
    return translate('validate_not_null');
  }

  if (value?.isNotEmpty == true && int.tryParse(value ?? '') == null) {
    return translate('validate_not_int');
  }

  if (value?.isNotEmpty == true &&
      min != null &&
      int.tryParse(value ?? '') != null &&
      int.tryParse(value ?? '')! < min) {
    return translate('validate_int_min', {'min': '$min'});
  }

  if (value?.isNotEmpty == true &&
      max != null &&
      int.tryParse(value ?? '') != null &&
      int.tryParse(value ?? '')! > max) {
    return translate('validate_int_max', {'max': '$max'});
  }

  return null;
}
