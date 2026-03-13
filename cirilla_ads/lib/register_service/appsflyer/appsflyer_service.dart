import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:cirilla/constants/app.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// URL schemes need to begin with an alphabetic Character
/// And be comprised of alphanumeric characters, the period, the hyphen or the plus sign only
/// Example: cirilla or cirilla3
const String urlSchemes = "cirilla";

final AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
  afDevKey: "xxxxxxxxxxxxxxxx",
  appId: "xxxxx", // only ios
  showDebug: false,
  timeToWaitForATTUserAuthorization: 15,
  appInviteOneLink: "xxx",
  manualStart: true,
);

class AppsFlyer {
  AppsFlyer._();

  static final AppsFlyer _instance = AppsFlyer._();

  static AppsFlyer get instance => _instance;

  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

  Future<dynamic> startSDK() async {
    await appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
    appsflyerSdk.startSDK(
      onSuccess: () {
        debugPrint("=====> initial appflyer");
      },
      onError: (errorCode, errorMessage) {
        debugPrint("=====> Appsflyer Error: $errorCode $errorMessage");
      },
    );
  }

  Future<String?> generateInviteLink(String permalink) {
    String? afdp = permalink.replaceAll(baseUrl, "$urlSchemes://");
    AppsFlyerInviteLinkParams inviteLinkParams = AppsFlyerInviteLinkParams(
      baseDeepLink: permalink,
      customParams: {
        "af_dp": afdp,
        "af_ios_url": permalink,
        "af_android_url": permalink,
        "link": permalink,
        "af_web_dp": permalink,
        "af_force_deeplink": "true",
      },
    );

    Completer<String?> completer = Completer();

    appsflyerSdk.generateInviteLink(
      inviteLinkParams,
      (result) {
        if (result is! Map) return;
        final payload = result.containsKey("payload") ? result["payload"] : null;
        if (payload is! Map) return;
        final userInviteURL = payload.containsKey("userInviteURL") ? payload["userInviteURL"] : null;
        completer.complete(userInviteURL);
      },
      (error) {
        completer.completeError(error.toString());
      },
    );

    return completer.future;
  }

  void onDeepLinking(BuildContext context) async {
    appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          String url = dp.deepLink?.getStringValue("link").toString() ?? "";
          String? scheme = dp.deepLink?.getStringValue("scheme").toString();
          String? mediaSource = dp.deepLink?.getStringValue("media_source");
          Uri uri = Uri.parse(url);
          if (scheme == "https" && mediaSource != null) {
            Navigator.pushNamed(context, uri.path);
          }
          break;
        case Status.NOT_FOUND:
          debugPrint("=====> AppsFlyer not found");
          break;
        case Status.ERROR:
          debugPrint("=====> AppsFlyer error");
          break;
        case Status.PARSE_ERROR:
          debugPrint("=====> AppsFlyer parse error");
          break;
      }
    });
  }
}
