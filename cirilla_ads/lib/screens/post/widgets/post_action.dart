import 'package:cirilla/models/models.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class PostAction extends StatelessWidget {
  final Post? post;
  final Color? color;
  final Axis axis;
  final Map<String, dynamic>? configs;
  final GlobalKey? dataKey;
  final bool enablePinned;

  const PostAction({
    Key? key,
    this.post,
    this.color,
    this.axis = Axis.horizontal,
    this.configs,
    this.dataKey,
    this.enablePinned = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool enableComment = get(configs, ['enableAppbarComment'], true);
    bool enableWishlist = get(configs, ['enableAppbarWishList'], true);
    bool enableShare = get(configs, ['enableAppbarShare'], true);

    if (axis == Axis.vertical) {
      return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              if (enableComment) ...[
                PostNavigateComment(
                  post: post,
                  color: color,
                  dataKey: dataKey,
                  enablePinned: enablePinned,
                ),
                SizedBox(height: enablePinned ? 16 : 32),
              ],
              if (enableWishlist) ...[
                PostWishlist(post: post, color: color, enablePinned: enablePinned),
                SizedBox(height: enablePinned ? 16 : 32),
              ],
              if (enableShare) PostShare(post: post, color: color, enablePinned: enablePinned,),
            ],
          ));
    }
    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: enablePinned ? 16 : 32,
        children: [
          if (enableComment)
            PostNavigateComment(
              post: post,
              color: color,
              dataKey: dataKey,
              enablePinned: enablePinned,
            ),
          if (enableWishlist) PostWishlist(post: post, color: color, enablePinned: enablePinned),
          if (enableShare) PostShare(post: post, color: color, enablePinned: enablePinned),
        ],
      ),
    );
  }
}

class PostWishlist extends StatefulWidget {
  final Post? post;
  final Color? color;
  final bool enablePinned;

  const PostWishlist({
    Key? key,
    this.post,
    this.color,
    this.enablePinned = false,
  }) : super(key: key);

  @override
  State<PostWishlist> createState() => _PostWishlistState();
}

class _PostWishlistState extends State<PostWishlist> with PostWishListMixin, AppBarMixin {
  ///
  /// Handle wishlist
  void _wishlist(BuildContext context) {
    if (widget.post == null || widget.post!.id == null) return;
    addWishList(postId: widget.post!.id);
  }

  @override
  Widget build(BuildContext context) {
    bool select = existWishList(postId: widget.post!.id);

    if (widget.enablePinned) {
      return leadingButton(
        icon: !select ? Icons.bookmark_border : Icons.bookmark,
        onPress: ()=> _wishlist(context),
      );
    }

    return InkWell(
      onTap: () => _wishlist(context),
      child: Icon(!select ? Icons.bookmark_border : Icons.bookmark, size: 20, color: widget.color),
    );
  }
}

class PostNavigateComment extends StatelessWidget with AppBarMixin {
  final Post? post;
  final Color? color;
  final GlobalKey? dataKey;
  final bool enablePinned;

  const PostNavigateComment({
    Key? key,
    this.post,
    this.color,
    this.dataKey,
    this.enablePinned = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enablePinned) {
      return leadingButton(
        icon: FeatherIcons.messageCircle,
        onPress: () {
          if (dataKey?.currentContext != null) {
            Scrollable.ensureVisible(dataKey!.currentContext!,
                duration: const Duration(
                  milliseconds: 600,
                ));
          }
        },
      );
    }
    return InkWell(
      onTap: () {
        if (dataKey?.currentContext != null) {
          Scrollable.ensureVisible(dataKey!.currentContext!,
              duration: const Duration(
                milliseconds: 600,
              ));
        }
      },
      child: Icon(FeatherIcons.messageCircle, size: 18, color: color),
    );
  }
}

class PostShare extends StatelessWidget with AppBarMixin {
  final Post? post;
  final Color? color;
  final bool enablePinned;

  const PostShare({
    Key? key,
    this.post,
    this.color,
    this.enablePinned = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (enablePinned) {
      return leadingButton(
        icon: FeatherIcons.share2,
        onPress: () => shareLink(
          permalink: post?.link ?? "",
          name: post?.postTitle,
          context: context,
        ),
      );
    }

    return InkWell(
      onTap: () => shareLink(
        permalink: post?.link ?? "",
        name: post?.postTitle,
        context: context,
      ),
      child: Icon(FeatherIcons.share2, size: 18, color: color),
    );
  }
}
