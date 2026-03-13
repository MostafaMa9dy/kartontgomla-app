import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IframeWidget extends StatelessWidget {
  final NavigationDelegate? navigationDelegate;
  final ExtensionContext extensionContext;

  const IframeWidget({
    Key? key,
    required this.extensionContext,
    this.navigationDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController();

    final sandboxMode = extensionContext.attributes["sandbox"];
    controller.setJavaScriptMode(
        sandboxMode == null || sandboxMode == "allow-scripts"
            ? JavaScriptMode.unrestricted
            : JavaScriptMode.disabled);

    if (navigationDelegate != null) {
      controller.setNavigationDelegate(navigationDelegate!);
    }

    final UniqueKey key = UniqueKey();
    final givenWidth =
    double.tryParse(extensionContext.attributes['width'] ?? "");
    final givenHeight =
    double.tryParse(extensionContext.attributes['height'] ?? "");

    final width = givenWidth ?? (givenHeight ?? 150) * 2;
    final height = givenHeight ?? (givenWidth ?? 300) / 2;

    String src = extensionContext.attributes['src'] ?? "";
    String url = src.length > 2 && src.substring(0, 2) == "//" ? "https:$src" : src;

    return AspectRatio(
      aspectRatio: width/height,
      child: CssBoxWidget(
        style: extensionContext.styledElement?.style ?? Style(),
        childIsReplaced: true,
        child: WebViewWidget(
          controller: controller
            ..loadHtmlString('<html><body><iframe loading="lazy" src="$url" frameborder="0" scrolling="auto" style="width: 100vw; height: 100vh" allow="fullscreen"></iframe></body></html>'),
          key: key,
          gestureRecognizers: {Factory(() => VerticalDragGestureRecognizer())},
        ),
      ),
    );
  }
}
