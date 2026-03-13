import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/option_value.dart';
import '../models/select.dart';

import '../fields/select.dart';
import '../widgets/container.dart';

class SelectExtension extends HtmlExtension {
  final Map<String, dynamic> data;
  final void Function(String key, dynamic value) onChange;

  const SelectExtension({
    required this.data,
    required this.onChange,
  });

  @override
  Set<String> get supportedTags => {"select"};

  @override
  InlineSpan build(ExtensionContext context) {
    SelectModel dataModel = convertSelectModelFromRenderContext(context);

    if (dataModel.option.options.isNotEmpty) {
      OptionValueModel? value = data[dataModel.name] is OptionValueModel ? data[dataModel.name] : null;
      return WidgetSpan(
        child: ContainerWidget(
          child: SelectField(
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
