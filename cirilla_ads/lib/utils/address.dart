import 'package:cirilla/utils/text_dynamic.dart';
import 'package:collection/collection.dart';
import 'package:cirilla/constants/app.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/models/address/country_address.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';

import 'package:cirilla/screens/profile/widgets/fields/validate_field.dart';
import 'convert_data.dart';

enum FieldFormType {
  billing,
  shipping,
  checkoutBilling,
  checkoutShipping,
  additional,
}

Map<String, dynamic> getBillingCustomer(Customer? customer) {
  if (customer == null) {
    return {};
  }
  Map<String, dynamic> data = customer.billing ?? {};
  if (customer.metaData?.isNotEmpty == true) {
    for (var meta in customer.metaData!) {
      String keyElement = get(meta, ['key'], '');
      if (keyElement.contains('billing_wooccm')) {
        dynamic valueElement = meta['value'];
        String nameData = keyElement.replaceFirst('billing_', '');
        data[nameData] = valueElement;
      }
    }
  }
  return data;
}

String getKeyAddress(String country, String lang, String countryDefault) {
  String valueCountry = country != "" ? country : "default";
  String valueLang = lang != "" ? lang : defaultLanguage;

  if (countryDefault != "" && country == country) {
    valueCountry = "default";
  }
  return "${valueCountry}_$valueLang";
}

AddressData? getAddressByKey(Map<String, AddressData> address, String country, String lang, String countryDefault) {
  String key = getKeyAddress(country, lang, countryDefault);
  return address[key];
}

String getDefaultNameFieldAddress(String key, FieldFormType type) {
  switch (type) {
    case FieldFormType.billing:
    case FieldFormType.checkoutBilling:
      return key.replaceFirst("billing_", "");
    case FieldFormType.shipping:
    case FieldFormType.checkoutShipping:
      return key.replaceFirst("shipping_", "");
    case FieldFormType.additional:
      return key.replaceFirst("additional_", "");
    default:
      return key;
  }
}

Map<String, dynamic> getFieldNicknameToAddress(
    FieldFormType formType, AddressData addressData, bool isBooking, TranslateType translate) {
  dynamic nickname = {
    "label": translate('address_book_input_nickname'),
    "placeholder": translate('address_book_hint_nickname'),
    "class": ["form-row-wide"],
    "autocomplete": "organization",
    "priority": 1,
    "required": false
  };

  if (formType == FieldFormType.additional) {
    return (addressData.additional ?? {}).cast<String, dynamic>();
  }

  if (formType == FieldFormType.shipping || formType == FieldFormType.checkoutShipping) {
    return {
      if (isBooking) 'shipping_address_nickname': nickname,
      ...addressData.shipping ?? {},
    }.cast<String, dynamic>();
  }
  return {
    if (isBooking) 'billing_address_nickname': nickname,
    ...addressData.billing ?? {},
  }.cast<String, dynamic>();
}

Map<String, dynamic> getConvertFieldsAddress(Map<String, dynamic> fields, Map<String, dynamic> additionFields,
    List<String> includeKeys, FieldFormType formType) {
  Map<String, dynamic> data = {};

  for (String key in fields.keys) {
    dynamic value = fields[key];
    bool disabled = ConvertData.toBoolValue(get(value, ['disabled'])) ?? false;

    if (includeKeys.isNotEmpty) {
      String defaultName = getDefaultNameFieldAddress(key, formType);
      String name = get(value, ['name'], defaultName);
      if (includeKeys.contains(name)) {
        data.addAll({
          key: value,
        });
      }
    } else {
      if (!disabled) {
        data.addAll({
          key: value,
        });
      }
    }
  }

  if (additionFields.isNotEmpty) {
    for (String key in additionFields.keys) {
      dynamic value = additionFields[key];
      bool disabled = ConvertData.toBoolValue(get(value, ['disabled'])) ?? false;

      if (includeKeys.isNotEmpty && !data.keys.toList().contains(key)) {
        String defaultName = getDefaultNameFieldAddress(key, formType);
        String name = get(value, ['name'], defaultName);
        if (includeKeys.contains(name) && !disabled) {
          data.addAll({
            key: value,
          });
        }
      } else {
        if (!disabled) {
          data.addAll({
            key: value,
          });
        } else if (disabled && data.keys.toList().contains(key)) {
          data.removeWhere((keyField, __) => keyField == key);
        }
      }
    }
  }
  return data;
}

bool checkValidateAddress(
  Map<String, dynamic> data,
  Map<String, dynamic> fields,
  FieldFormType formType,
  TranslateType translate,
) {
  bool check = true;

  if (fields.isNotEmpty == true) {
    for (String key in fields.keys.toList()) {
      Map<String, dynamic> field = (fields[key] as Map).cast<String,dynamic>();

      String defaultName = getDefaultNameFieldAddress(key, formType);
      String name = get(field, ['name'], defaultName);

      dynamic value = data[name];

      String typeField = get(field, ['type'], 'text');
      bool requiredInput = ConvertData.toBoolValue(field["required"]) ?? false;
      List validate = ConvertData.toListValue(field["validate"]);
      String max = get(field, ['max'], '');
      String min = get(field, ['min'], '');
      int? valueMax = max.isNotEmpty ? ConvertData.stringToInt(max) : null;
      int? valueMin = min.isNotEmpty ? ConvertData.stringToInt(min) : null;

      String? validateDataField = typeField == "number"
          ? validateFieldNumber(
              translate: translate,
              requiredInput: requiredInput,
              value: value,
              min: valueMin,
              max: valueMax,
            )
          : validateField(translate: translate, requiredInput: requiredInput, validate: validate, value: value);

      if (validateDataField != null) {
        check = false;
        break;
      }
    }
  }
  return check;
}

String getFormatAddress(Map<String, dynamic> data, AddressData address, FieldFormType type) {
  String format = address.format?[data["country"]] ?? "{name}\n{company}\n{address_1}\n{address_2}\n{city}\n{state}\n{postcode}\n{country}";

  Map<String, String> dataReplace = {};
  for(String key in data.keys.toList()) {
    if (data[key] is String) {
      dataReplace[key] = data[key];
    } else if (data[key] == null) {
      dataReplace[key] = "";
    } else {
      data[key] = data[key].toString();
    }
  }

  dataReplace["name"] = "${data["first_name"]} ${data["last_name"]}".toString();

  String countryCode = data["country"] ?? "";
  String stateCode = data["state"] ?? "";

  List<CountryAddressData>? countries = type == FieldFormType.shipping || type == FieldFormType.checkoutShipping ? address.shippingCountries : address.billingCountries;
  String? country = countries?.firstWhereOrNull((c) => c.code == countryCode)?.name;
  if (country != null) {
    dataReplace["country"] = country;
  }

  List<CountryAddressData>? states = type == FieldFormType.shipping || type == FieldFormType.checkoutShipping ? (address.shippingStates?[countryCode]) : (address.billingStates?[countryCode]);
  dataReplace["state_code"] =  stateCode;
  dataReplace["state"] =  states?.firstWhereOrNull((c) => c.code == stateCode)?.name ?? stateCode;

  return TextDynamic.replace(format, dataReplace).replaceAll(RegExp(r'(\n){2,}'), "\n");
}