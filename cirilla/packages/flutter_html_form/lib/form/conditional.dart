import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../conditional.dart';

class ConditionalExtension extends HtmlExtension {
  final Map<String, dynamic> data;

  const ConditionalExtension({
    required this.data,
  });

  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("conditional");
  }

  @override
  InlineSpan build(ExtensionContext context) {
    Widget child = Container();
    print(checkShowField(data, context.attributes));
    if (context.builtChildrenMap?.values.toList().isNotEmpty == true) {
      child = RichText(
        text: TextSpan(children: context.builtChildrenMap?.values.toList(), style: TextStyle()),
      );
    }

    return WidgetSpan(
      child: Visibility(
        visible: checkShowField(data, context.attributes),
        maintainState: true,
        child: child,
      )
    );
  }
}
