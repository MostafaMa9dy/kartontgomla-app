import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class LabelExtension extends HtmlExtension {
  const LabelExtension();

  @override
  Set<String> get supportedTags => {"label"};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(
      child: CssBoxWidget(
          style: context.styledElement?.style ?? Style(),
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              return SizedBox(
                width: constraints.maxWidth == double.infinity ? null : constraints.maxWidth,
                child: RichText(
                  text: TextSpan(children: context.builtChildrenMap?.values.toList() ?? []),
                ),
              );
            },
          ),
      ),
    );
  }
}