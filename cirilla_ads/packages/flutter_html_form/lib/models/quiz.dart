import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_form/convert.dart';
import 'package:html/dom.dart';

class OptionQuiz {
  final String question;
  final String answer;

  OptionQuiz({
    required this.question,
    required this.answer,
  });
}

class QuizModel {
  final String name;
  final List<OptionQuiz> options;
  final bool required;
  final int? minLength;
  final int? maxLength;
  final int? size;

  QuizModel({
    required this.name,
    required this.options,
    required this.required,
    this.minLength,
    this.maxLength,
    this.size,
  });
}

QuizModel convertQuizModelFromRenderContext(ExtensionContext context) {
  Map<String, String> attributes = context.attributes;
  List<Element> children = context.elementChildren;

  String name = attributes["data-name"] ?? "";
  bool requiredField = convertToBool(attributes["data-required"]) ?? false;
  int? minLength = convertStringToIntCanBeNull(attributes["data-minlength"]);
  int? maxLength = convertStringToIntCanBeNull(attributes["data-maxlength"]);
  int? size = convertStringToIntCanBeNull(attributes["data-size"]);

  return QuizModel(
    name: name,
    options: _getOptions(children, name),
    required: requiredField,
    minLength: minLength != null && maxLength != null && minLength > maxLength ? maxLength : minLength,
    maxLength: minLength != null && maxLength != null && minLength > maxLength ? minLength : maxLength,
    size: size,
  );
}

List<OptionQuiz> _getOptions(List<Element> children, String name) {
  List<OptionQuiz> options = [];
  for (var child in children) {
    if (child.localName == "span") {
      Map<Object, String> attributes = child.attributes;
      if (attributes["data-name"] == name) {
        String text = child.innerHtml;
        List<String> splitText = text.split("|");
        if (splitText.length == 2) {
          options.add(OptionQuiz(question: splitText[0], answer: splitText[1]));
        }
      }
    }
  }
  return options;
}
