import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_package/connectivity_plus_package.dart';
import 'package:flutter/material.dart';

/// The InternetNotificationType has two values is 'default' and 'banner'.
/// If value is 'dialog', the message will be displayed as a dialog.
/// If value is 'banner', the message will be displayed as a mini banner at top of screen.
enum InternetNotificationType{dialog, banner}

class CheckAndSubscribeConnection extends StatefulWidget {
  final Widget child;
  final String? title;
  final String? subTitle1;
  final String? subTitle2;
  final String? connectedTitle;
  final String? letTitle;
  final InternetNotificationType internetNotificationType;
  const CheckAndSubscribeConnection({
    this.child = const SizedBox(),
    this.title,
    this.subTitle1,
    this.subTitle2,
    this.connectedTitle,
    this.letTitle,
    this.internetNotificationType = InternetNotificationType.dialog,
    super.key,
  });

  @override
  State<CheckAndSubscribeConnection> createState() => _CheckAndSubscribeConnectionState();
}

class _CheckAndSubscribeConnectionState extends State<CheckAndSubscribeConnection> with NoInternetMixin {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _checkConnectionTimer;
  Timer? _autoCloseTimer;
  @override
  void initState() {
    checkAndSubscribeConnection(
      context: context,
      subscription: _subscription,
      checkConnectionTimer: _checkConnectionTimer,
      autoCLoseTimer: _autoCloseTimer,
      title: widget.title,
      letTitle: widget.letTitle,
      subTitle1: widget.subTitle1,
      subTitle2: widget.subTitle2,
      connectedTitle: widget.connectedTitle,
      internetNotificationType: widget.internetNotificationType,
    );

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _checkConnectionTimer?.cancel();
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
