import 'package:flutter/material.dart';

import '../convert_data.dart';

class OptionTermColorWidget extends StatelessWidget {
  final String? color;
  final bool isSelected;
  final VoidCallback? onClick;

  const OptionTermColorWidget({
    Key? key,
    this.color,
    this.isSelected = false,
    this.onClick,
  }) : super(key: key);

  Container boxCircle({
    double? size,
    Color? color,
    Border? border,
  }) {
    return Container(
      width: size ?? 39,
      height: size ?? 39,
      decoration: BoxDecoration(
        color: color,
        border: border,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color? colorBox = ConvertData.fromHex(color ?? "", Colors.transparent);

    return GestureDetector(
      onTap: !isSelected ? onClick : null,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: boxCircle(color: colorBox, size: 27),
          ),
          isSelected
              ? boxCircle(border: Border.all(width: 2, color: theme.primaryColor))
              : boxCircle(border: Border.all(color: theme.dividerColor))
        ],
      ),
    );
  }
}
