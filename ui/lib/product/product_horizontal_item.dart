import 'package:flutter/material.dart';
import 'product_item.dart';

/// A post widget display full width on the screen
///
class ProductHorizontalItem extends ProductItem {
  /// Widget image
  final Widget image;

  /// Widget name. It must required
  final Widget name;

  /// Widget price
  final Widget price;

  /// Widget rating
  final Widget? rating;

  /// Widget button Add cart
  final Widget? addCart;

  /// Widget extra tags in information
  final Widget? tagExtra;

  /// Widget quantity
  final Widget? quantity;

  /// Widget above name
  final Widget? aboveName;

  /// Widget above price
  final Widget? abovePrice;

  /// Widget above rating
  final Widget? aboveRating;

  /// shadow card
  final List<BoxShadow>? boxShadow;

  /// Border of item post
  final Border? border;

  /// Color Card of item post
  final Color? color;

  /// Border of item post
  final BorderRadius? borderRadius;

  /// Function click item
  final Function onClick;

  /// Padding item
  final EdgeInsetsGeometry padding;

  /// Create Product Horizontal Item
  const ProductHorizontalItem({
    Key? key,
    required this.image,
    required this.name,
    required this.onClick,
    required this.price,
    this.rating,
    this.addCart,
    this.tagExtra,
    this.quantity,
    this.aboveName,
    this.abovePrice,
    this.aboveRating,
    this.borderRadius,
    this.border,
    this.color = Colors.transparent,
    this.boxShadow,
    this.padding = EdgeInsets.zero,
  }) : super(
          key: key,
          colorProduct: color,
          borderRadiusProduct: borderRadius,
          borderProduct: border,
          boxShadowProduct: boxShadow,
        );

  @override
  Widget buildLayout(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            image,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            tagExtra ?? Container(),
                            if (tagExtra != null) const SizedBox(height: 12),
                            if (aboveName != null) aboveName!,
                            name,
                            if (abovePrice != null) abovePrice!,
                            price,
                          ],
                        ),
                      ),
                      if (addCart != null)
                        const SizedBox(
                          width: 10,
                        ),
                      addCart ?? Container(),
                    ],
                  ),
                  if (quantity != null) const SizedBox(height: 8),
                  quantity ?? Container(),
                  if (rating != null || aboveRating != null) const SizedBox(height: 8),
                  if (aboveRating != null) aboveRating!,
                  rating ?? Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
