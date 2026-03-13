import 'package:cirilla/register_service/register_service.dart';
import 'package:flutter/material.dart';

class AppsFlyerDynamicLink {
  Future<dynamic> startSDK() async {
    return await AppsFlyer.instance.startSDK();
  }

  Future<String?> generateInviteLink(String permalink) {
    return AppsFlyer.instance.generateInviteLink(permalink);
  }

  void onDeepLinking(BuildContext context) async {
    return AppsFlyer.instance.onDeepLinking(context);
  }
}
