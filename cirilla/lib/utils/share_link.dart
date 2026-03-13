import 'package:cirilla/register_service/appsflyer/appsflyer.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareLink({
  String? name,
  required String permalink,
  required BuildContext context,
}) async {

  String? url = await AppsFlyerDynamicLink().generateInviteLink(permalink);

  if (url != null) {
    Share.share(url, subject: name);
  } else {
    // Default sharing
    Share.share(permalink, subject: name);
  }
}
