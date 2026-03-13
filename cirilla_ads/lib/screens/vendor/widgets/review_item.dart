import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class VendorReviewItem extends StatelessWidget with VendorReviewMixin {
  final VendorReview? item;
  const VendorReviewItem({super.key, this.item,});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return  Column(
      children: [
        CommentContainedItem(
          image: Column(
            children: [
              buildAvatar(review: item),
              const SizedBox(height: 6),
              buildRate(review: item, theme: theme, translate: translate)
            ],
          ),
          name: buildUser(review: item, theme: theme),
          date: buildDate(review: item, theme: theme),
          rating: buildRatingList(review: item, theme: theme),
          comment: buildComment(review: item, theme: theme),
          onClick: () {},
        ),
        const Divider(height: 49, thickness: 1),
      ],
    );
  }
}