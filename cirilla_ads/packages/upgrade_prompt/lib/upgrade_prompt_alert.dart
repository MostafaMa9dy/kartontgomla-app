import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpgradePromptAlert extends StatefulWidget {
  final Widget child;

  final String? languageKey;

  /// Enable prompt when an upgraded version is available, which defaults to true
  final bool enableUpgradePromptAlert;

  /// duration until alerting user again, which defaults to 3 days
  final Duration durationUntilAlertAgain;

  /// Hide or show Ignore button, which defaults to false
  final bool showIgnore;

  /// Hide or show Later button, which defaults to true
  final bool showLater;

  /// Used to indicate whether tapping on the barrier will dismiss the dialog, which defaults to false
  final bool barrierDismissible;

  /// Hide or show release notes, which defaults to false
  final bool showReleaseNotes;

  /// The [Key] assigned to the dialog when it is shown.
  final GlobalKey? dialogKey;

  /// The minimum app version supported by this app
  final String? minAppVersion;

  final Upgrader? upgrader;

  final String appcastURL;

  const UpgradePromptAlert({
    required this.child,
    this.enableUpgradePromptAlert = true,
    this.durationUntilAlertAgain = const Duration(days: 3),
    this.languageKey,
    this.showIgnore = true,
    this.showLater = true,
    this.barrierDismissible = false,
    this.showReleaseNotes = true,
    this.dialogKey,
    this.minAppVersion,
    this.upgrader,
    required this.appcastURL,
    super.key,
  });

  @override
  State<UpgradePromptAlert> createState() => _UpgradePromptAlertState();
}

class _UpgradePromptAlertState extends State<UpgradePromptAlert> {
  late final Upgrader upgraderEdit;

  @override
  void initState() {
    UpgraderAppcastStore upgraderAppcastStore = UpgraderAppcastStore(appcastURL: widget.appcastURL);
    upgraderEdit = Upgrader(
      languageCode: widget.languageKey,
      minAppVersion: widget.minAppVersion == '' ? null : widget.minAppVersion,
      durationUntilAlertAgain: widget.durationUntilAlertAgain,
      storeController: UpgraderStoreController(
        onAndroid: () => upgraderAppcastStore,
        oniOS: () => upgraderAppcastStore,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enableUpgradePromptAlert) {
      return UpgradeAlert(
        showReleaseNotes: widget.showReleaseNotes,
        showIgnore: widget.showIgnore,
        showLater: widget.showLater,
        barrierDismissible: widget.barrierDismissible,
        dialogStyle: UpgradeDialogStyle.cupertino,
        dialogKey: widget.dialogKey,
        upgrader: widget.upgrader ?? upgraderEdit,
        child: widget.child,
      );
    }
    return widget.child;
  }
}
