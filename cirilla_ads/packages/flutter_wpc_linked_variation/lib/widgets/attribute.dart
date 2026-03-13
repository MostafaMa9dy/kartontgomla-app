import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wpc_linked_variation/model.dart';

import 'term_list.dart';

class AttributeWidget extends StatelessWidget {
  final AttributeModel attribute;
  final List<Map<String, dynamic>> variations;
  final Map<String, String> selected;
  final void Function(String, String)? onChangeTerm;

  const AttributeWidget({
    Key? key,
    required this.attribute,
    required this.variations,
    required this.selected,
    this.onChangeTerm,
  }) : super(key: key);

  bool checkExistTermVariation(String slug, TermModel term) {
    return variations.any((element) {
      Map<String, String> attributes = Map<String, String>.from(element['attributes']);
      return attributes.keys.any((el) {
        String key = el.toLowerCase();
        if (attributes[key] == '') {
          return true;
        }
        return key == slug && attributes[key] == term.slug;
      });
    });
  }

  bool check(String option) {
    if (selected.isEmpty) return true;

    // Pre data if select the term
    Map<String, String> dataSelected = Map<String, String>.of(selected);
    if (dataSelected.containsKey(attribute.slug)) {
      dataSelected.update(attribute.slug, (value) => option);
    } else {
      dataSelected.putIfAbsent(attribute.slug, () => option);
    }

    return variations.any((element) {
      Map<String, String> attributes = Map<String, String>.from(element['attributes']);
      return dataSelected.keys.every(
        (el) {
          String key = el.toLowerCase();
          return attributes[key] == null || attributes[key] == '' || attributes[key] == dataSelected[el];
        },
      );
    });
  }

  TermModel? getTermSelected() {
    if (selected[attribute.slug] != null) {
      return attribute.terms.firstWhereOrNull((t) => t.slug == selected[attribute.slug]);
    }

    return null;
  }

  bool enableShowValueLabel() {
    if (attribute.layout == "dropdown") {
      return false;
    }

    if (attribute.layout == "swatch" && (attribute.type == "radio" || attribute.type == "select")) {
      return false;
    }

    return true;
  }

  String getTypeTerm() {
    if (attribute.layout == "images") {
      return "images";
    }

    if (attribute.layout == "dropdown") {
      return "dropdown";
    }

    if (attribute.layout == "swatch") {
      return attribute.type;
    }

    return "button";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TermModel? termSelected = getTermSelected();
    bool showValue = enableShowValueLabel();

    String type = getTypeTerm();

    /// Get terms exist in variations
    List<TermModel> termsVariation = attribute.terms.where((t) => checkExistTermVariation(attribute.slug, t)).toList();

    /// Get terms can select
    List<TermModel> terms = termsVariation.where((t) => check(t.slug)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          alignment: AlignmentDirectional.centerStart,
          child: RichText(
            text: TextSpan(
              text: '${attribute.name}: ',
              style: theme.textTheme.bodyMedium,
              children: [
                if (showValue && termSelected != null) TextSpan(text: termSelected.name),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (terms.isEmpty)
          Container()
        else
          TermListWidget(
            terms: terms,
            type: type,
            valueSelected: selected[attribute.slug],
            onSelectTerm: (String value) => onChangeTerm?.call(attribute.slug, value),
          ),
      ],
    );
  }
}
