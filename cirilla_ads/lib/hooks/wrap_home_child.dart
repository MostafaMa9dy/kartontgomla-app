import 'package:cirilla/register_service/appsflyer/appsflyer.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter/material.dart';

/// Wrap main home child widget.
///
/// Throws an [ArgumentError] if there is already an option build context [context] or
/// there is already an option setting store [store] or there is already an option
/// widget child [child]. Returns the widget.
Widget wrapHomeChild(BuildContext context, SettingStore store, Widget child) {
  AppsFlyerDynamicLink().onDeepLinking(context);
  return child;
}