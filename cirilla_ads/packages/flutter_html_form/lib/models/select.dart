import 'dart:convert';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_form/convert.dart';
import 'package:html/dom.dart';

import 'option_data.dart';

class SelectModel {
  final String name;
  final OptionDataModel option;
  final bool required;
  final bool includeBlank;
  final bool multiple;

  SelectModel({
    required this.name,
    required this.option,
    required this.required,
    required this.includeBlank,
    required this.multiple,
  });
}

SelectModel convertSelectModelFromRenderContext(ExtensionContext context) {
  Map<String, String> attributes = context.attributes;
  List<Element> children = context.elementChildren;

  String name = attributes["name"] ?? "";
  bool multiple = convertToBool(attributes["multiple"]) ?? false;
  bool requiredField = convertToBool(attributes["required"]) ?? false;
  bool includeBlank = convertToBool(attributes["data-includeblank"]) ?? false;
  return SelectModel(name: name, option: _getOption(children, name), required: requiredField, multiple: multiple, includeBlank: includeBlank);
}

OptionDataModel _getOption(List<Element> children, String name) {
  List<String> options = [];
  List<int> defaultValues = [];

  var i = 1;
  for(var child in children) {
    if (child.localName == "option") {

      Map<Object, String> attributes = child.attributes;
      String value = attributes["value"] ?? "";
      bool selected = convertToBool(attributes["selected"]) ?? false;

      options.add(value);
      if (selected) {
        defaultValues.add(i);
      }
      i++;
    }

  }
  return OptionDataModel(options: options, defaultValues: defaultValues);
}