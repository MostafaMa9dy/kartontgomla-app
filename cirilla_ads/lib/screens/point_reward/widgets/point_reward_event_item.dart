// Flutter library
import 'package:cirilla/models/models.dart';
import 'point_tag.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:flutter/material.dart';



import 'package:cirilla/mixins/mixins.dart';


class PointRewardEventItem extends StatelessWidget with TransitionMixin {
  final PointRewardEvent? item;
  final bool loading;

  PointRewardEventItem({
    Key? key,
    this.item,
    this.loading = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: VerticalTableExcelItem(
        title: buildDate(date: item?.date, theme: theme, isLoading: loading),
        titleTrailing: const Text(''),
        subtitle: buildName(name: item?.description, theme: theme, isLoading: loading),
        description: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PointTag(
              point: item?.points,
              theme: theme,
              isLoading: loading,
            )
          ],
        ),
        sortDescription: buildContent(
          content: item?.points ?? '0',
          theme: theme,
          isLoading: loading,
        ),
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.all(16),
        onTap: () {},
      ),
    );
  }
}
class VerticalTableExcelItem extends StatelessWidget {
  /// The widget title of layout
  final Widget title;

  /// The widget title trailing of layout
  final Widget titleTrailing;

  /// The widget subtitle of layout
  final Widget subtitle;

  /// The widget sort description of layout
  final Widget sortDescription;

  /// The widget description of layout
  final Widget description;

  /// [EdgeInsetsGeometry] of layout
  final EdgeInsetsGeometry? padding;

  /// [GestureTapCallback] of layout
  final GestureTapCallback? onTap;

  /// [Color] of layout
  final Color? background;

  /// [BoxBorder] of layout
  final BoxBorder? border;

  /// [BorderRadiusGeometry] of layout
  final BorderRadiusGeometry? borderRadius;

  /// [List<BoxShadow>] of layout
  final List<BoxShadow>? boxShadow;

  /// Create vertical layout with five widgets.
  ///
  /// The title, subtitle, titleTrailing,  description, sortDescription and bottom parameters must not be null.
  ///
  /// The others parameter can be null.
  ///
  /// Example:
  ///
  /// ```dart
  /// VerticalTableExcelItem(
  ///   title: Text('title'),
  ///   titleTrailing: Text('icon'),
  ///   subtitle: Text('subtitle'),
  ///   description: Text('description'),
  ///   sortDescription: Text('sort'),
  /// )
  /// ```
  ///
  const VerticalTableExcelItem({
    Key? key,
    required this.title,
    required this.titleTrailing,
    required this.subtitle,
    required this.sortDescription,
    required this.description,
    this.padding,
    this.background,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxWidth: widthScreen),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: background,
            border: border,
            borderRadius: borderRadius,
            boxShadow: boxShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: title),
                  const SizedBox(width: 12),
                  titleTrailing,
                ],
              ),
              const SizedBox(height: 2),
              subtitle,
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: description),
                  const SizedBox(width: 16),
                  sortDescription,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildDate({
  String? date,
  required ThemeData theme,
  double shimmerWidth = 70,
  double shimmerHeight = 12,
  bool isLoading = true,
}) {
  if (isLoading) {
    return CirillaShimmer(
      child: Container(
        width: shimmerWidth,
        height: shimmerHeight,
        decoration: const BoxDecoration(color: Colors.white),
      ),
    );
  }
  return Text(date ?? '', style: theme.textTheme.bodySmall);
}

Widget buildName({
  String? name,
  required ThemeData theme,
  double shimmerWidth = 140,
  double shimmerHeight = 16,
  bool isLoading = true,
}) {
  if (isLoading) {
    return CirillaShimmer(
      child: Container(
        width: shimmerWidth,
        height: shimmerHeight,
        decoration: const BoxDecoration(color: Colors.white),
      ),
    );
  }
  return Text(name ?? '', style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium!.color));
}

Widget buildContent({
  String? content,
  required ThemeData theme,
  double shimmerWidth = 120,
  double shimmerHeight = 14,
  bool isLoading = true,
}) {
  if (isLoading) {
    return CirillaShimmer(
      child: Container(
        width: shimmerWidth,
        height: shimmerHeight,
        decoration: const BoxDecoration(color: Colors.white),
      ),
    );
  }
  return Text(
    content ?? '',
    style: theme.textTheme.bodySmall,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}