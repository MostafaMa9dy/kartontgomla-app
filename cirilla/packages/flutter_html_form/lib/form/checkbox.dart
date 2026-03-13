import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/option_value.dart';
import '../models/checkbox.dart';

import '../fields/checkbox.dart';
import '../widgets/container.dart';

class CheckboxExtension extends HtmlExtension {
  final Map<String, dynamic> data;
  final void Function(String key, dynamic value) onChange;

  const CheckboxExtension({
    required this.data,
    required this.onChange,
  });

  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("checkbox");
  }

  @override
  InlineSpan build(ExtensionContext context) {
    CheckboxModel dataModel = convertCheckboxModelFromRenderContext(context);
    if (dataModel.option.options.isNotEmpty) {
      OptionValueModel? value = data[dataModel.name] is OptionValueModel ? data[dataModel.name] : null;
      return WidgetSpan(
        child: ContainerWidget(
          child: CheckboxField(
            value: value,
            onChange: (newValue) => onChange(dataModel.name, newValue),
            data: dataModel,
          ),
        ),
      );
    }
    return WidgetSpan(child: SizedBox());
  }
}
