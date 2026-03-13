import 'package:flutter/material.dart';

import '../model.dart';
import 'option_term_button.dart';
import 'option_term_color.dart';
import 'option_term_image.dart';
import 'term_dropdown.dart';
import 'term_radio.dart';

class TermListWidget extends StatelessWidget {
  final List<TermModel> terms;
  final String? valueSelected;
  final String type;
  final ValueChanged<String>? onSelectTerm;

  const TermListWidget({
    Key? key,
    this.type = "button",
    this.valueSelected,
    this.terms = const <TermModel>[],
    this.onSelectTerm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == "dropdown" || type == "select") {
      return TermDropdownWidget(
        value: valueSelected,
        terms: terms,
        onChange: (value) => onSelectTerm?.call(value),
      );
    }

    if (type == "radio") {
      return TermRadioWidget(
        value: valueSelected,
        terms: terms,
        onChange: (value) => onSelectTerm?.call(value),
      );
    }

    return SizedBox(
      height: 38,
      child: ListView.separated(
        itemCount: terms.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 1),
        itemBuilder: (context, index) {
          TermModel term = terms.elementAt(index);
          switch(type) {
            case "color":
              return OptionTermColorWidget(
                color: term.value,
                isSelected: term.slug == valueSelected,
                onClick: () => onSelectTerm?.call(term.slug),
              );
            case "image":
            case "images":
              return OptionTermImageWidget(
                url: type == "images" ? term.imageProduct: term.value,
                isSelected: term.slug == valueSelected,
                onClick: () => onSelectTerm?.call(term.slug),
              );
            default:
              return OptionTermButtonWidget(
                label: term.name,
                isSelected: term.slug == valueSelected,
                onClick: () => onSelectTerm?.call(term.slug),
              );
          }
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}
