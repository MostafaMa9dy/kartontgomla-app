import 'package:flutter/material.dart';

class CouponSmartItem extends StatelessWidget {
  /// The widget show image in left layout
  final Widget image;

  /// The width title of layout
  final Widget title;

  /// Widget show description of layout
  final Widget? description;

  /// Widget show sort description of layout
  final Widget? sortDescription;

  /// Widget show conclusion of layout
  final Widget? conclusion;

  /// Widget show subtitle of layout
  final Widget? subtitle;

  /// Set visit avatar in start or end layout. If value is true, avatar will be end layout
  final bool enableEndAvatar;

  /// Width of layout. If not set width, will auto get max width of layout
  final double? width;

  /// Spacing image with content of layout
  final double pad;

  /// [BoxBorder] of layout
  final BoxBorder? border;

  /// [Color] of layout
  final Color? background;

  /// [BorderRadiusGeometry] of layout
  final BorderRadiusGeometry? borderRadius;

  /// [List<BoxShadow>] of layout
  final List<BoxShadow>? boxShadow;

  /// [EdgeInsetsGeometry] of layout
  final EdgeInsetsGeometry? padding;

  /// [GestureTapCallback] of layout
  final GestureTapCallback? onTap;

  /// [CrossAxisAlignment] of layout
  final CrossAxisAlignment? crossAxisAlignment;

  /// Create horizontal layout with two widgets.
  ///
  /// The title, image parameters must not be null.
  ///
  /// The others parameter can be null.
  ///
  /// If the subtitle, description, sortDescription, conclusion parameters are null,
  /// these not be shown.
  ///
  /// Example:
  ///
  /// ```dart
  /// CouponSmartItem(
  ///   image: const Image.asset('assets/image/image.png'),
  ///   title: const Text('My image'),
  /// )
  /// ```
  ///
  const CouponSmartItem({
    Key? key,
    required this.image,
    required this.title,
    this.description,
    this.sortDescription,
    this.conclusion,
    this.subtitle,
    this.enableEndAvatar = false,
    this.width,
    this.pad = 16,
    this.border,
    this.background,
    this.borderRadius,
    this.boxShadow,
    this.padding,
    this.onTap,
    this.crossAxisAlignment,
  }) : super(key: key);

  Widget buildContent(
    BuildContext context, {
    required Widget child,
    CrossAxisAlignment? crossAxisAlignment,
  }) {
    double widthScreen = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: width != null ? BoxConstraints(maxWidth: widthScreen) : null,
        width: width,
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: background,
            border: border,
            borderRadius: borderRadius,
            boxShadow: boxShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
            children: [
              if (!enableEndAvatar) ...[
                image,
                SizedBox(width: pad),
              ],
              Expanded(child: child),
              if (enableEndAvatar) ...[
                SizedBox(width: pad),
                image,
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(
      context,
      crossAxisAlignment: crossAxisAlignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: title,
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 12),
                subtitle!,
              ]
            ],
          ),
          if (description != null) description!,
          if (sortDescription != null) sortDescription!,
          if (conclusion != null) conclusion!,
        ],
      ),
    );
  }
}
