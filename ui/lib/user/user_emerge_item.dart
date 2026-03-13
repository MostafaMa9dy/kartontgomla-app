import 'package:flutter/material.dart';

class UserEmergeItem extends StatelessWidget {
  /// Widget Image

  final Widget? image;

  /// Widget title

  final Widget title;

  /// Widget subtitle

  final Widget subtitle;

  /// width item

  final double width;

  /// height emerge item

  final double emergeHeight;

  /// padding item

  final EdgeInsetsGeometry padding;

  /// Function click item

  final Function? onClick;

  /// Border radius of item

  final BorderRadius? borderRadius;

  /// Shadow of item

  final List<BoxShadow>? shadow;

  /// Color of item

  final Color? color;

  const UserEmergeItem({
    Key? key,
    this.image,
    required this.title,
    required this.subtitle,
    this.onClick,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.emergeHeight = 40,
    this.shadow,
    this.color,
    this.width = double.infinity,
    this.padding = const EdgeInsets.fromLTRB(20, 50, 20, 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              boxShadow: shadow,
              borderRadius: borderRadius,
            ),
            padding: padding,
            child: Column(
              children: [
                GestureDetector(
                  onTap: onClick as void Function()?,
                  child: title,
                ),
                subtitle,
              ],
            ),
          ),
          Positioned(
            top: -emergeHeight,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onClick as void Function()?,
                child: image,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
