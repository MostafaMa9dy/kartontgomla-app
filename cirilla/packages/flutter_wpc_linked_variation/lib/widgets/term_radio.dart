import 'package:flutter/material.dart';

import '../model.dart';
import 'tile.dart';

class TermRadioWidget extends StatelessWidget {
  final String? value;
  final List<TermModel> terms;
  final ValueChanged<String>? onChange;

  const TermRadioWidget({
    Key? key,
    this.value,
    this.terms = const <TermModel>[],
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: List.generate(
        terms.length,
        (index) {
          TermModel term = terms.elementAt(index);
          bool selected = term.slug == value;
          Color? textColor = selected ? theme.textTheme.titleMedium?.color : null;

          return TileWidget(
            leading: _RadioWidget(isSelect: selected),
            title: Text(term.name, style: theme.textTheme.bodyMedium?.copyWith(color: textColor)),
            onTap: () {
              if (!selected) {
                onChange?.call(term.slug);
              }
            },
          );
        },
      ),
    );
  }
}

class _RadioWidget extends StatelessWidget {
  final bool isSelect;

  const _RadioWidget({
    Key? key,
    this.isSelect = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Color colorItem = theme.dividerColor;
    Color colorActiveItem = const Color(0xFF21BA45);
    double widthBorder = isSelect ? 7 : 2;

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(width: widthBorder, color: isSelect ? colorActiveItem : colorItem),
        shape: BoxShape.circle,
      ),
    );
  }
}
