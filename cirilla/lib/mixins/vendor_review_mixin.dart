import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:cirilla/utils/url_launcher.dart';

mixin VendorReviewMixin {
  Widget buildAvatar({VendorReview? review}) {
    if (review == null) {
      return CirillaShimmer(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: const CirillaCacheImage(
        Assets.noImageUrl,
        width: 48,
        height: 48,
      ),
    );
  }

  Widget buildRate({VendorReview? review, required ThemeData theme, required TranslateType translate}) {
    if (review == null) {
      return Column(
        children: [
          CirillaShimmer(
            child: Container(
              width: 30,
              height: 10,
              color: Colors.white,
            ),
          ),
          CirillaShimmer(
            child: Container(
              width: 40,
              height: 14,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    double value = double.tryParse(review.reviewRating) ?? 0;

    return Column(
      children: [
        Text(
          translate('vendor_rated'),
          style: theme.textTheme.labelSmall,
        ),
        Container(
          color: theme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          child: Text(
            value.toStringAsFixed(1),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        )
      ],
    );
  }

  Widget buildUser({
    VendorReview? review,
    double shimmerWidth = 60,
    double shimmerHeight = 14,
    required ThemeData theme,
  }) {
    if (review == null) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          color: Colors.white,
        ),
      );
    }
    return Text(review.authorName, style: theme.textTheme.titleSmall);
  }

  Widget buildDate({
    VendorReview? review,
    double shimmerWidth = 95,
    double shimmerHeight = 12,
    required ThemeData theme,
  }) {
    if (review == null) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          color: Colors.white,
        ),
      );
    }
    return Text(formatDate(date: review.created), style: theme.textTheme.bodySmall);
  }

  Widget buildComment({
    VendorReview? review,
    double shimmerWidth = 200,
    double shimmerHeight = 12,
    required ThemeData theme,
  }) {
    if (review == null) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          color: Colors.white,
        ),
      );
    }
    Style styleDefault = Style(
      lineHeight: const LineHeight(1.5),
      padding: HtmlPaddings.zero,
      margin: Margins.zero,
      color: theme.textTheme.bodySmall?.color,
      fontSize: FontSize(theme.textTheme.bodySmall?.fontSize ?? 12),
      fontWeight: theme.textTheme.bodySmall?.fontWeight,
    );

    return Html(
      data: review.reviewDescription,
      style: {
        'html': styleDefault,
        'body': Style(
          padding: HtmlPaddings.zero,
          margin: Margins.zero,
        ),
        'p': Style(
          margin: Margins.zero,
        ),
        'blockquote': Style(
          margin: Margins(left: Margin(itemPaddingMedium)),
        ),
        'h1': Style(margin: Margins.zero),
        'h2': Style(margin: Margins.zero),
        'h3': Style(margin: Margins.zero),
        'h4': Style(margin: Margins.zero),
        'h5': Style(margin: Margins.zero),
        'h6': Style(margin: Margins.zero),
        "div": styleDefault,
        "a": Style(color: theme.primaryColor),
      },
      onLinkTap: (
        String? url,
        Map<String, String> attributes,
        dom.Element? element,
      ) {
        if (url is String && Uri.parse(url).isAbsolute) {
          launch(url);
        }
      },
    );
  }

  Widget buildRatingList({
    VendorReview? review,
    double shimmerWidth = 100,
    double shimmerHeight = 14,
    required ThemeData theme,
  }) {
    if (review == null) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          color: Colors.white,
        ),
      );
    }

    if (review.meta.isEmpty) {
      double value = double.tryParse(review.reviewRating) ?? 0;
      return CirillaRating(value: value);
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (_, int i) {
        VendorReviewMeta meta = review.meta[i];
        double value = double.tryParse(meta.value ?? "0") ?? 0;
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: [
            CirillaRating(value: value),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(meta.name, style: theme.textTheme.labelSmall),
            )
          ],
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 1),
      itemCount: review.meta.length,
    );
  }
}
