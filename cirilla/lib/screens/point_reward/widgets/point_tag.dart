// Flutter libraries
import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:flutter/material.dart';

// Packages and dependencies or helper functions
import 'package:feather_icons/feather_icons.dart';

class PointTag extends StatelessWidget {
  const PointTag({
    Key? key,
    this.point,
    required this.theme,
    this.isLoading = true,
  }) : super(key: key);
  final String? point;
  final ThemeData theme;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CirillaShimmer(
        child: Container(
          height: 24,
          width: 80,
          color: Colors.white,
        ),
      );
    }
    int? pointVal = int.tryParse(point ?? '');
    String type = 'earn';
    if (pointVal != null) {
      if (pointVal <= 0) {
        type = 'purchase';
      }
    }

    Color color = ColorBlock.leaf;
    IconData icon = FeatherIcons.plusCircle;

    String text = type == 'earn' ? 'Earn' : 'Purchase';

    if (type == 'purchase') {
      color = ColorBlock.redLight;
      icon = FeatherIcons.minusCircle;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}