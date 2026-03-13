import 'package:flutter/material.dart';

class ItemTotal extends StatelessWidget {
  final IconData? icon;
  final Widget? couponCode;
  final String? title;
  final String? count;
  final Color? backgroundColor;
  const ItemTotal({
    this.icon,
    this.couponCode,
    this.backgroundColor,
    this.count,
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    Color color = theme.colorScheme.onPrimaryContainer;
    return InkWell(
      child: LayoutBuilder(
        builder: (context, constraints) {
          MediaQueryData mediaQuery = MediaQuery.of(context);
          double maxWidth = constraints.maxWidth != double.infinity ? constraints.maxWidth : mediaQuery.size.width;
          return Container(
            width: (maxWidth / 3) - 20,
            height: 80,
            decoration: BoxDecoration(
              color: backgroundColor ?? theme.primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                couponCode ?? Icon(icon, color: color, size: 20),
                Text(
                  '$title',
                  style: textTheme.labelSmall?.copyWith(color: color),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('$count', style: textTheme.titleSmall?.copyWith(color: color)),
              ],
            ),
          );
        },
      ),
    );
  }
}
