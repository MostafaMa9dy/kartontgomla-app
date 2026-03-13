import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class FormExtension extends HtmlExtension {
  final Key formKey;

  const FormExtension({
    required this.formKey,
  });

  @override
  Set<String> get supportedTags => {"form"};

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(
      child: CssBoxWidget(
          style: context.styledElement?.style ?? Style(),
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              return Container(
                width: constraints.maxWidth == double.infinity ? 300 : constraints.maxWidth,
                child: _Form(
                  keyForm: formKey,
                  children: context.builtChildrenMap?.values.toList() ?? [],
                ),
              );
            },
          )
      ),
    );
  }
}

class _Form extends StatelessWidget {
  final Key? keyForm;
  final List<InlineSpan> children;

  const _Form({
    this.keyForm,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Form(
        key: keyForm,
        child: RichText(
          text: TextSpan(
            children: children,
          ),
        ),
      ),
    );
  }
}
