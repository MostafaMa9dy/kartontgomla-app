import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/option_value.dart';
import '../models/radio.dart';

import '../fields/radio.dart';
import '../widgets/container.dart';

class RadioExtension extends HtmlExtension {
  final Map<String, dynamic> data;
  final void Function(String key, dynamic value) onChange;

  const RadioExtension({
    required this.data,
    required this.onChange,
  });

  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("radio");
  }

  @override
  InlineSpan build(ExtensionContext context) {
    RadioModel dataModel = convertRadioModelFromRenderContext(context);
    if (dataModel.option.options.isNotEmpty) {
      OptionValueModel? value = data[dataModel.name] is OptionValueModel ? data[dataModel.name] : null;
      return WidgetSpan(
        child: ContainerWidget(
          child: RadioField(
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
