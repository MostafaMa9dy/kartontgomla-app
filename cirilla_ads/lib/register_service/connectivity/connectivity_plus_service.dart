import 'package:flutter/material.dart';
import 'package:connectivity_plus_package/no_internet/check_and_subscribe_connection.dart' as service;

import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';

class Connectivity extends StatelessWidget {
  final Widget child;
  const Connectivity({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return service.CheckAndSubscribeConnection(
      title: translate('no_internet'),
      subTitle1: translate('no_internet_content_1'),
      subTitle2: translate('no_internet_content_2'),
      letTitle: translate('internet_let'),
      connectedTitle: translate('internet_connected'),
      child: child,
    );
  }
}
