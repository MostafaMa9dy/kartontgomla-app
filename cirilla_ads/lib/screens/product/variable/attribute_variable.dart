import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/store/product/variation_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'term_variable.dart';

class AttributeVariable extends StatelessWidget {
  final String? id;
  final String? label;
  final VariationStore? store;
  final TextAlign alignTitle;
  final bool productShowOutOfStock;
  final Size imageAttriSize;

  const AttributeVariable({
    Key? key, this.id,
    this.label,
    this.store,
    this.alignTitle = TextAlign.start,
    this.productShowOutOfStock = false,
    this.imageAttriSize = const Size(38, 38),
  }) : super(key: key);

  bool checkExistTermVariation(String? id, String option) {
    List<dynamic> dataVariations = store!.data!['variations'];
    return dataVariations.any((element) {
      Map<String, String> attributes = Map<String, String>.from(element['attributes']);
      return attributes.keys.any((el) {
        String key = el.toLowerCase();
        if (attributes[key] == '') {
          return true;
        }
        return key == id && attributes[key] == option;
      });
    });
  }

  bool check(String option) {
    if (store!.selected.isEmpty) return true;

    // Pre data if select the term
    Map<String?, String?> selected = Map<String?, String?>.of(store!.selected);
    if (selected.containsKey(id)) {
      selected.update(id, (value) => option);
    } else {
      selected.putIfAbsent(id, () => option);
    }

    return store!.data!['variations'].any((element) {
      Map<String, String> attributes = Map<String, String>.from(element['attributes']);
      return selected.keys.every(
        (el) {
          String key = el!.toLowerCase();
          return attributes[key] == null || attributes[key] == '' || attributes[key] == selected[el];
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List labelList = ['Image'];
    return Observer(
      builder: (_) {
        Map<String, List<String>> terms = store!.data!['attribute_terms'];
        Map<String, String>? labels = store!.data!['attribute_terms_labels'];
        Map<String, Map<String, String>>? values = store!.data!['attribute_terms_values'];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              alignment: AlignmentDirectional.centerStart,
              child: RichText(
                textAlign: alignTitle,
                text: TextSpan(text: '$label: ', style: theme.textTheme.bodyMedium, children: [
                  if (store!.selected[id] != null)
                    TextSpan(
                      text: labels!['${id}_${store!.selected[id]}'],
                    )
                ]),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: labelList.contains(label) ? imageAttriSize.height : 38,
              child: buildTerm(terms, labels, values),
            ),
          ],
        );
      },
    );
  }

  Widget buildTerm(
      Map<String, List<String>> terms, Map<String, String>? labels, Map<String, Map<String, String>>? values) {
    List<String> term = get(terms, [id], []) ?? [];
    List<String> newTerm = term.where((e) => checkExistTermVariation(id, e)).toList();

    if (newTerm.isEmpty) {
      return Container();
    }

    return ListView.separated(
      itemCount: newTerm.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        String nameTerm = newTerm[index];
        return TermVariable(
          label: labels!['${id}_$nameTerm'],
          value: values != null ? values['${id}_$nameTerm'] : null,
          option: nameTerm,
          isSelected: nameTerm == store!.selected[id],
          canSelect: check(nameTerm),
          onSelectTerm: () => store!.selectTerm(key: id, value: nameTerm),
          store: store,
          productShowOutOfStock: productShowOutOfStock,
          imageAttriSize: imageAttriSize,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 10),
    );
  }
}
