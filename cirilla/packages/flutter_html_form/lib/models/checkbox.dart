import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_form/convert.dart';
import 'package:html/dom.dart';

import 'option_data.dart';

class CheckboxModel {
  final String name;
  final OptionDataModel option;
  final bool required;
  final bool labelFirst;
  final bool exclusive;

  CheckboxModel({
    required this.name,
    required this.option,
    required this.required,
    required this.labelFirst,
    required this.exclusive,
  });
}

CheckboxModel convertCheckboxModelFromRenderContext(ExtensionContext context) {
  Map<String, String> attributes = context.attributes;
  List<Element> children = context.elementChildren;

  String name = attributes["data-name"] ?? "";
  bool labelFirst = convertToBool(attributes["data-labelfirst"]) ?? false;
  bool requiredField = convertToBool(attributes["data-required"]) ?? false;
  bool exclusive = convertToBool(attributes["data-exclusive"]) ?? false;
  return CheckboxModel(name: name, option: _getOption(children, name), required: requiredField, labelFirst: labelFirst, exclusive: exclusive);
}

OptionDataModel _getOption(List<Element> children, String name) {
  List<String> options = [];
  List<String> images = [];
  List<int> defaultValues = [];

  var i = 1;
  for(var child in children) {
    if (child.localName == "input") {
      Map<Object, String> attributes = child.attributes;
      if (attributes["type"] == "checkbox" || attributes["name"] == name) {
        String value = attributes["value"] ?? "";
        options.add(value);
        if (attributes.keys.toList().contains("src")) {
          images.add(attributes["src"] ?? "");
        }

        if (convertToBool(attributes["checked"]) ?? false) {
          defaultValues.add(i);
        }
        i ++;
      }
    }

  }
  return OptionDataModel(options: options, imageOptions: images.isNotEmpty ? images : null, defaultValues: defaultValues);
}