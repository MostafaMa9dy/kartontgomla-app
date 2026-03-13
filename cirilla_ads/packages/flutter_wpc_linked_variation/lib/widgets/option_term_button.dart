import 'package:flutter/material.dart';

class OptionTermButtonWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onClick;

  const OptionTermButtonWidget({
    Key? key,
    this.label = "",
    this.isSelected = false,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle? titleButton = theme.textTheme.bodyMedium;

    if (isSelected) {
      return OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.primaryColor,
          side: BorderSide(width: 2, color: theme.primaryColor),
          textStyle: titleButton,
          minimumSize: const Size(40, 0),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(label),
      );
    }

    return OutlinedButton(
      onPressed: onClick,
      style: OutlinedButton.styleFrom(
        foregroundColor: titleButton?.color,
        side: BorderSide(width: 1, color: theme.dividerColor),
        textStyle: titleButton,
        minimumSize: const Size(40, 0),
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Text(label),
    );
  }
}
