import 'package:cirilla/constants/constants.dart';
import 'package:flutter/material.dart';

class ItemReferral extends StatelessWidget {
  final String? titleCode;
  final String? code;
  final String? description;
  final Widget? btnCopy;
  const ItemReferral({
    this.titleCode,
    this.code,
    this.description,
    this.btnCopy,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$titleCode:', style: textTheme.bodyMedium),
        Container(
          decoration: BoxDecoration(
            color: theme.dividerColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: layoutPadding, vertical: itemPadding),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '$code',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: 10),
              btnCopy ?? const SizedBox(),
            ],
          ),
        ),
        Text('$description', style: textTheme.labelMedium),
      ],
    );
  }
}
