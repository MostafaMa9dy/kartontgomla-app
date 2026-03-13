import 'package:cirilla/constants/color_block.dart';
import 'package:flutter/material.dart';

class ItemSocical extends StatelessWidget {
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final GestureTapCallback? onTap;
  const ItemSocical({
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.onTap,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        MediaQueryData mediaQuery = MediaQuery.of(context);
        double maxWidth = constraints.maxWidth != double.infinity ? constraints.maxWidth : mediaQuery.size.width;
        return InkWell(
          onTap: onTap,
          child: Container(
            width: (maxWidth / 4) - 20,
            height: 32,
            decoration: BoxDecoration(
              color: backgroundColor ?? ColorBlock.facebook,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon ?? Icons.facebook,
              size: 20,
              color: iconColor ?? Colors.white,
            ),
          ),
        );
      },
    );
  }
}
