import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class YithMessageVariationHideExtension extends HtmlExtension {
  const YithMessageVariationHideExtension();

  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("yith-par-message-variation") &&
        context.classes.contains("hide");
  }

  @override
  InlineSpan build(ExtensionContext context) {
    return const WidgetSpan(child: SizedBox());
  }
}