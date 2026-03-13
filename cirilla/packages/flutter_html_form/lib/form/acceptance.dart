import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../fields/acceptance.dart';
import '../widgets/container.dart';

class AcceptanceExtension extends HtmlExtension {
  final Map<String, dynamic> data;
  final void Function(String key, dynamic value) onChange;

  const AcceptanceExtension({
    required this.data,
    required this.onChange,
  });

  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("acceptance");
  }

  @override
  InlineSpan build(ExtensionContext context) {
    Map<String, String> attributes = context.attributes;

    String key = attributes["data-name"] ?? "";
    return WidgetSpan(
      child: ContainerWidget(
        child: AcceptanceField(
          value: data[key] is String ? data[key] : null,
          onChange: (newValue) => onChange(key, newValue),
          attributes: attributes,
        ),
      )
    );
  }
}
