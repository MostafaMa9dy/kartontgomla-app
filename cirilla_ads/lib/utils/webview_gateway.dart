import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cirilla/webview_flutter.dart';
import 'package:cirilla/widgets/cirilla_webview.dart';

Widget buildCirillaWebViewGateway(
  String url,
  BuildContext context, {
  String Function(String url)? customHandle,
  bool isLoading = false,
  String runJavaScript = '',
  String? javaScriptName,
  Function(String)? onJavaScriptMessageReceived,
}) {
  if (url.contains("https://cirrilla-stripe-form.web.app")) {
    return CirillaWebView(
      uri: Uri.parse(url),
      javaScriptName: "Flutter_Cirilla",
      onJavaScriptMessageReceived: (JavaScriptMessage message) {
        Navigator.pop(context, message.message);
      },
      isLoading: isLoading,
    );
  }
  return CirillaWebView(
    uri: url.startsWith('<html>') ? Uri.dataFromString(url, mimeType: 'text/html', encoding: utf8) : Uri.parse(url),
    onNavigationRequest: (NavigationRequest request) {
      String url = request.url;
      if (customHandle != null) {
        String value = customHandle(url);
        switch (value) {
          case "prevent":
            return NavigationDecision.prevent;
          default:
            return NavigationDecision.navigate;
        }
      }
      if (url.contains('/order-received/')) {
        Navigator.of(context).pop({'order_received_url': url});
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    },
    runJavaScript: runJavaScript,
    javaScriptName: javaScriptName,
    onJavaScriptMessageReceived: (JavaScriptMessage message) {
      if (message.message.isEmpty) {
        return;
      } else {
        onJavaScriptMessageReceived?.call(message.message);
      }
    },
    isLoading: isLoading,
    syncLoggedUser: true,
    restoreCookies: true,
  );
}
