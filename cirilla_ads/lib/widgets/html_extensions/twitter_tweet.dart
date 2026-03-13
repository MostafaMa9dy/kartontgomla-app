import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../cirilla_webview.dart';

class TwitterTweetExtension extends HtmlExtension {

  const TwitterTweetExtension();
  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("twitter-tweet");
  }

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(child: CssBoxWidget(style: context.styledElement?.style ?? Style(), child: _TwitterView(extensionContext: context),));
  }
}

class _TwitterView extends StatefulWidget {
  final ExtensionContext extensionContext;

  const _TwitterView({
    // required this.tree,
    required this.extensionContext,
  });

  @override
  State<StatefulWidget> createState() => _TwitterViewState();
}

class _TwitterViewState extends State<_TwitterView> with LoadingMixin {
  late SettingStore _settingStore;
  late WebViewController _controller;

  bool _loading = true;

  @override
  void initState() {
    _settingStore = Provider.of<SettingStore>(context, listen: false);

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    List<String> attrs = [];
    for (String key in widget.extensionContext.attributes.keys.toList()) {
      attrs.add('$key="${widget.extensionContext.attributes[key]}"');
    }
    String theme = _settingStore.darkMode ? "dark" : "light";
    attrs.add('data-theme="$theme"');
    attrs.add('data-align="center"');
    String html =
        '<html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head><body><blockquote ${attrs.join(" ")}>${widget.extensionContext.innerHtml}</blockquote>\n<p><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></p></body></html>';

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (progress == 100 && _loading) {
              setState(() {
                _loading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url != "about:blank" && !request.url.contains("platform.twitter.com")) {
              return await openAppLink(request.url);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setBackgroundColor(Colors.transparent)
      ..loadHtmlString(html);

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController).setAllowsBackForwardNavigationGestures(true);
    }

    _controller = controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 550),
            child: AspectRatio(
              aspectRatio: _loading ? 1 : 550 / 1015,
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
          ),
          if (_loading)
            Positioned.fill(
              child: Center(
                child: buildLoadingOverlay(context),
              ),
            )
        ],
      ),
    );
  }
}