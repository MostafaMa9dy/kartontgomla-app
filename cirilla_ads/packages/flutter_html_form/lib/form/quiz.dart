import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../fields/quiz.dart';
import '../models/quiz.dart';
import '../widgets/container.dart';

class QuizExtension extends HtmlExtension {
  final Map<String, dynamic> data;
  final void Function(String key, dynamic value) onChange;

  const QuizExtension({
    required this.data,
    required this.onChange,
  });

  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("quiz");
  }

  @override
  InlineSpan build(ExtensionContext context) {
    QuizModel dataModel = convertQuizModelFromRenderContext(context);
    if (dataModel.options.isNotEmpty) {
      String? value = data[dataModel.name] is String ? data[dataModel.name] : null;
      return WidgetSpan(
        child: ContainerWidget(
          child: QuizField(
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
