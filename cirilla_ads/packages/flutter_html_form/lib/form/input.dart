import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_form/widgets/container.dart';

import '../fields/inputs.dart';
import '../fields/submit.dart';

class InputExtension extends HtmlExtension {
  final Map<String, dynamic> data;
  final void Function(String key, dynamic value) onChange;
  final Map<String, dynamic> user;
  final bool submitLoading;
  final Function submitOnPressed;
  final Widget submitLoadingWidget;

  const InputExtension({
    required this.data,
    required this.onChange,
    required this.user,
    this.submitLoading = false,
    required this.submitOnPressed,
    required this.submitLoadingWidget,
  });

  @override
  Set<String> get supportedTags => {"input"};

  @override
  InlineSpan build(ExtensionContext context) {
    String type = context.attributes["type"] ?? "text";

    late Widget child;
    if (type == "submit") {
      child = SubmitField(
        attributes: context.attributes,
        onSubmit: submitOnPressed,
        loading: submitLoading,
        loadingWidget: submitLoadingWidget,
      );
    } else {
      child = ContainerWidget(
        child: Inputs(
          data: data,
          onChange: onChange,
          attributes: context.attributes,
          user: user,
        ),
      );
    }

    return WidgetSpan(child: child);
  }
}
