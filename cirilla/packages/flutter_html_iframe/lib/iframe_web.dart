import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:math';
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IframeWidget extends StatelessWidget {
  final NavigationDelegate? navigationDelegate;
  final ExtensionContext extensionContext;

  const IframeWidget(
      {Key? key, required this.extensionContext, this.navigationDelegate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final givenWidth =
        double.tryParse(extensionContext.attributes['width'] ?? "");
    final givenHeight =
        double.tryParse(extensionContext.attributes['height'] ?? "");
    final html.IFrameElement iframe = html.IFrameElement()
      ..width = (givenWidth ?? (givenHeight ?? 150) * 2).toString()
      ..height = (givenHeight ?? (givenWidth ?? 300) / 2).toString()
      ..src = extensionContext.attributes['src']
      ..style.border = 'none';
    final String createdViewId = _getRandString(10);
    ui_web.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => iframe);

    return SizedBox(
      width: double.tryParse(extensionContext.attributes['width'] ?? "") ??
          (double.tryParse(extensionContext.attributes['height'] ?? "") ??
                  150) *
              2,
      height: double.tryParse(extensionContext.attributes['height'] ?? "") ??
          (double.tryParse(extensionContext.attributes['width'] ?? "") ?? 300) /
              2,
      child: CssBoxWidget(
        style: extensionContext.styledElement?.style ?? Style(),
        childIsReplaced: true,
        child: Directionality(
          textDirection: extensionContext.styledElement?.style.direction ??
              Directionality.of(context),
          child: HtmlElementView(viewType: createdViewId),
        ),
      ),
    );
  }
}

String _getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}
