import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

class ListAvatar extends StatefulWidget {
  final Function(String?, int?)? onChanged;

  const ListAvatar({
    super.key,
    this.onChanged,
  });

  @override
  State<ListAvatar> createState() => _ListAvatarState();
}

class _ListAvatarState extends State<ListAvatar> with AppBarMixin, LoadingMixin {
  final ScrollController _controller = ScrollController();
  UploadAvatarStore? _uploadAvatarStore;
  bool isMultiSelect = false;
  List<MediaModel> selectedMedias = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() async {
    _uploadAvatarStore = Provider.of<AuthStore>(context).uploadAvatarStore;
    await _uploadAvatarStore?.getListMediaByUser();
    super.didChangeDependencies();
  }

  void _onScroll() {
    if (!_controller.hasClients || _uploadAvatarStore!.isLoadingListAvatar || !_uploadAvatarStore!.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _uploadAvatarStore!.getListMediaByUser();
    }
  }

  void onSelectAvatar(MediaModel media) {
    setState(() {
      if (selectedMedias.any((element) => element.id == media.id)) {
        selectedMedias.removeWhere((element) => element.id == media.id);
      } else {
        selectedMedias.add(media);
      }
    });
  }

  void onRemoveSelectedAvatar() {
    if (selectedMedias.isNotEmpty) {
      TranslateType translate = AppLocalizations.of(context)!.translate;
      showDialog(
        context: context,
        builder: (context) {
          ThemeData theme = Theme.of(context);
          TextTheme textTheme = theme.textTheme;
          return AlertDialog(
            title: Text(
              translate('upload_remove_avatars'),
              style: textTheme.titleLarge,
            ),
            content: Text(
              translate('upload_description', {'count': "${selectedMedias.length}"}),
              style: textTheme.bodyMedium,
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(translate('upload_cancel')),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _uploadAvatarStore?.deleteMultiMedia(
                    mediaSelected: selectedMedias,
                  );
                  selectedMedias.clear();
                  isMultiSelect = false;
                },
                child: Text(translate('upload_confirm')),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    ButtonStyle buttonStyle = isMultiSelect
        ? ElevatedButton.styleFrom(
            textStyle: theme.textTheme.bodyMedium,
            minimumSize: const Size(0, 29),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          )
        : ElevatedButton.styleFrom(
            foregroundColor: theme.textTheme.titleMedium?.color,
            backgroundColor: theme.colorScheme.surface,
            textStyle: theme.textTheme.bodyMedium,
            minimumSize: const Size(0, 29),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          );
    return Observer(
      builder: (context) {
        List<MediaModel> medias = _uploadAvatarStore!.medias.toList();
        bool loading = _uploadAvatarStore!.isLoadingListAvatar;

        bool isShimmer = medias.isEmpty && loading;
        List<MediaModel> loadingMedia = List.generate(10, (index) => MediaModel()).toList();

        List<MediaModel> data = isShimmer ? loadingMedia : medias;

        return Scaffold(
          appBar: AppBar(
            title: Text(translate('upload_list_avatar')),
            leading: leading(),
            centerTitle: true,
            actionsPadding: const EdgeInsets.only(right: 20),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isMultiSelect = !isMultiSelect;
                        });
                      },
                      style: buttonStyle,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(FontAwesomeIcons.tasks, size: 16),
                          const SizedBox(width: 8),
                          Text(translate('upload_select_avatar')),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          body: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _uploadAvatarStore!.refresh,
                    builder: buildAppRefreshIndicator,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        MediaModel media = data[index];
                        return Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                if (!isShimmer) {
                                  if (isMultiSelect) {
                                    onSelectAvatar(media);
                                  } else {
                                    widget.onChanged?.call(
                                      media.sourceUrl,
                                      media.id,
                                    );
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: media.id == null
                                      ? CirillaShimmer(
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: theme.dividerColor,
                                          ),
                                        )
                                      : CirillaCacheImage(
                                          media.sourceUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: isShimmer
                                  ? const SizedBox()
                                  : isMultiSelect
                                      ? InkWell(
                                          onTap: () {
                                            onSelectAvatar(media);
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              border: Border.all(
                                                color: theme.cardColor,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: selectedMedias.any((element) => element.id == media.id)
                                                ? Icon(
                                                    Icons.check,
                                                    color: theme.cardColor,
                                                    size: 20,
                                                  )
                                                : null,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                            ),
                          ],
                        );
                      },
                      itemCount: data.length,
                    ),
                  ),
                  if (loading)
                    SliverToBoxAdapter(
                      child: buildLoading(
                        context,
                        isLoading: _uploadAvatarStore!.canLoadMore,
                      ),
                    ),
                  if (medias.isEmpty && !loading)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildNotificationEmpty(),
                    ),
                ],
              ),
              if (_uploadAvatarStore?.isLoadingRemoveAvatar ?? false)
                Center(
                  child: buildLoadingOverlay(context),
                ),
            ],
          ),
          bottomSheet: buildRemove(),
        );
      },
    );
  }

  Widget buildRemove() {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: theme.textTheme.bodyMedium,
      minimumSize: const Size(0, 29),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
    if (isMultiSelect && selectedMedias.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              translate('upload_selected_avatar', {'count': "${selectedMedias.length}"}),
              style: theme.textTheme.bodyMedium,
            ),
            ElevatedButton(
              onPressed: () {
                onRemoveSelectedAvatar();
              },
              style: buttonStyle,
              child: Text(translate('upload_remove')),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildNotificationEmpty() {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return NotificationScreen(
      title: Text(
        translate('upload_no_avatar'),
        style: textTheme.titleLarge,
      ),
      content: Text(
        translate('upload_have_no_avatar'),
        style: textTheme.bodyMedium,
      ),
      iconData: FeatherIcons.image,
      textButton: Text(translate('notifications_back')),
      styleBtn: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 61),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}
