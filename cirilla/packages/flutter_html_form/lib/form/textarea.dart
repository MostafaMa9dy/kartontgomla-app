import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../fields/textarea.dart';
import '../widgets/container.dart';

class TextareaExtension extends HtmlExtension {
  final Map<String, dynamic> data;
  final void Function(String key, dynamic value) onChange;
  final Map<String, dynamic> user;

  const TextareaExtension({
    required this.data,
    required this.onChange,
    required this.user,
  });

  @override
  Set<String> get supportedTags => {"textarea"};

  @override
  InlineSpan build(ExtensionContext context) {

    String? defaultValue;
    if (context.innerHtml.isNotEmpty) {
      defaultValue = context.innerHtml;
    }

    Map<String, String> attributes = context.attributes;
    String nameKey = attributes["name"] ?? "";

    dynamic value = data[nameKey] is String ? data[nameKey] : null;

    return WidgetSpan(
      child: ContainerWidget(
        child: TextareaField(
          value: value is String ? value : null,
          onChange: (newValue) => onChange(nameKey, newValue),
          attributes: {
            ...attributes,
            "type": "textarea",
            if (defaultValue != null) "value": defaultValue,
          },
          user: user,
        ),
      ),
    );
  }
}
