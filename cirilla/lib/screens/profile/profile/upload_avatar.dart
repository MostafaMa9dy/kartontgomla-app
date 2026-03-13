import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:provider/provider.dart';

import 'list_avatar.dart';

class UploadAvatar extends StatefulWidget {
  final String? avatarUrl;
  final double? size;

  const UploadAvatar({
    Key? key,
    this.avatarUrl,
    this.size = 56,
  }) : super(key: key);

  @override
  State<UploadAvatar> createState() => _UploadAvatarState();
}

class _UploadAvatarState extends State<UploadAvatar> with TransitionMixin, AppBarMixin, LoadingMixin {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  ImageProvider? imageProvider;
  UploadAvatarStore? _uploadAvatarStore;
  SettingStore? _settingStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uploadAvatarStore = Provider.of<AuthStore>(context).uploadAvatarStore;
    _settingStore = Provider.of<SettingStore>(context);
  }

  // View image fullscreen - pass imageProvider
  void _viewImage(BuildContext context, ImageProvider initialProvider) {
    final currentProviderNotifier = ValueNotifier<ImageProvider>(initialProvider);
    File? tempImageFile;
    int? tempMediaId;
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    TranslateType translate = AppLocalizations.of(context)!.translate;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) {
          Future<void> pickImageInFullscreen() async {
            await showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return CupertinoActionSheet(
                  actions: [
                    // Take Photo
                    CupertinoActionSheetAction(
                      isDefaultAction: true,
                      onPressed: () async {
                        Navigator.pop(context); // Close action sheet
                        try {
                          XFile? pickedFile = await _picker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 50,
                            maxWidth: 600,
                          );
                          if (pickedFile != null) {
                            File file = File(pickedFile.path);
                            // Save to temporary variable
                            tempImageFile = file;
                            // Update image in fullscreen (not saved to main state yet)
                            currentProviderNotifier.value = FileImage(file);
                          }
                        } catch (e) {
                          avoidPrint(e);
                        }
                      },
                      child: Text(translate('upload_camera')),
                    ),
                    // Photo Library
                    CupertinoActionSheetAction(
                      onPressed: () async {
                        Navigator.pop(context);
                        try {
                          XFile? pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 50,
                            maxWidth: 600,
                          );
                          if (pickedFile != null) {
                            File file = File(pickedFile.path);
                            // Save to temporary variable
                            tempImageFile = file;
                            // Update image in fullscreen (not saved to main state yet)
                            currentProviderNotifier.value = FileImage(file);
                          }
                        } catch (e) {
                          avoidPrint(e);
                        }
                      },
                      child: const Text("Photo Library"),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () async {
                        Navigator.pop(context);
                        try {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, _, __) {
                                return ListAvatar(
                                  onChanged: (String? url, int? mediaId) {
                                    if (url != null) {
                                      tempImageFile = File(url); // Clear temp file
                                      tempMediaId = mediaId; // Save temporary media ID
                                      currentProviderNotifier.value = NetworkImage(url);
                                    }
                                  },
                                );
                              },
                              transitionsBuilder: slideTransition,
                            ),
                          );
                        } catch (e) {
                          avoidPrint(e);
                        }
                      },
                      child: Text(translate('upload_media_library')),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: Text(translate('upload_cancel')),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          }

          Color? iconAppBar = theme.appBarTheme.iconTheme?.color;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                translate('avatar'),
                style: textTheme.bodyMedium?.copyWith(
                  color: iconAppBar,
                ),
              ),
              leading: leading(color: iconAppBar),
              elevation: 0,
              centerTitle: true,
              actions: [
                IconButton(
                  iconSize: 20,
                  splashRadius: 20,
                  icon: Icon(
                    Icons.camera_alt,
                    color: iconAppBar,
                  ),
                  onPressed: () {
                    pickImageInFullscreen();
                  },
                ),
                IconButton(
                  iconSize: 20,
                  splashRadius: 20,
                  icon: Icon(
                    Icons.save_as_rounded,
                    color: iconAppBar,
                  ),
                  onPressed: () async {
                    // Only save if there is a new image picked
                    if (tempImageFile != null) {
                      setState(() {
                        _imageFile = tempImageFile;
                        imageProvider = FileImage(tempImageFile!);
                      });
                    }
                    if (tempImageFile != null || tempMediaId != null) {
                      await _uploadAvatarStore?.uploadAvatar(
                        filePath: tempMediaId != null ? null : tempImageFile?.path,
                        mediaId: tempMediaId,
                      );
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
            body: Observer(
              builder: (_) {
                bool isLoading = _uploadAvatarStore?.isLoading ?? false;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: ValueListenableBuilder<ImageProvider>(
                        valueListenable: currentProviderNotifier,
                        builder: (context, provider, child) {
                          return InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: Image(
                              image: provider,
                              key: ValueKey(provider.hashCode), // Force rebuild when provider changes
                            ),
                          );
                        },
                      ),
                    ),
                    if (isLoading) buildLoadingOverlay(context),
                  ],
                );
              },
            ),
          );
        },
        transitionsBuilder: slideTransition,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    WidgetConfig widgetConfig = _settingStore!.data!.screens!['profile']!.widgets!['profilePage']!;
    Map<String, dynamic>? fields = widgetConfig.fields;
    bool enableUploadAvatar = get(fields, ['enableUploadAvatar'], false);
    String? avatarUrl = widget.avatarUrl;
    Widget avatar = ClipRRect(
      borderRadius: BorderRadius.circular(widget.size! / 2),
      child: CirillaCacheImage(
        avatarUrl,
        width: widget.size,
        height: widget.size,
      ),
    );

    if (!enableUploadAvatar) {
      return avatar;
    }

    // Display image: prioritize newly selected image, then avatarUrl
    if (_imageFile != null) {
      if (_imageFile!.path.contains('http')) {
        imageProvider = NetworkImage(_imageFile!.path);
      } else {
        imageProvider = FileImage(_imageFile!);
      }
    } else if (avatarUrl != null && avatarUrl.isNotEmpty) {
      imageProvider = NetworkImage(avatarUrl);
    }

    return InkWell(
      onTap: () {
        if (imageProvider != null) {
          _viewImage(context, imageProvider!);
        }
      },
      child: Stack(
        children: [
          avatar,
          PositionedDirectional(
            bottom: 0,
            end: 0,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: theme.cardColor,
              child: Icon(
                Icons.camera_alt,
                size: 12,
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
