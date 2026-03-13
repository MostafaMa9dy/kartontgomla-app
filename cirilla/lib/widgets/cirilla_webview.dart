import 'dart:async';
import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/webview_open_applink.dart';
import 'package:cirilla/service/service.dart';
import 'package:flutter/foundation.dart';

import 'package:cirilla/utils/debug.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

class CirillaWebView extends StatefulWidget {
  final Uri uri;
  final LoadRequestMethod method;
  final Map<String, String> headers;
  final Uint8List? body;
  final String? userAgent;
  final FutureOr<NavigationDecision> Function(NavigationRequest request)? onNavigationRequest;
  final void Function(String)? onPageStarted;
  final void Function(String)? onPageFinished;
  final void Function(String, WebViewController)? onPageFinishedWithController;
  final String? javaScriptName;
  final void Function(JavaScriptMessage)? onJavaScriptMessageReceived;
  final bool isLoading;
  final Widget? loading;
  final bool syncLoggedUser;
  final bool restoreCookies;
  final String runJavaScript;

  const CirillaWebView({
    Key? key,
    required this.uri,
    this.method = LoadRequestMethod.get,
    this.headers = const <String, String>{},
    this.body,
    this.userAgent,
    this.onNavigationRequest,
    this.onPageStarted,
    this.onPageFinished,
    this.onPageFinishedWithController,
    this.isLoading = true,
    this.loading,
    this.javaScriptName,
    this.onJavaScriptMessageReceived,
    this.syncLoggedUser = false,
    this.restoreCookies = false,
    this.runJavaScript = '',
  }) : super(key: key);

  @override
  State<CirillaWebView> createState() => _CirillaWebViewState();
}

class _CirillaWebViewState extends State<CirillaWebView> with LoadingMixin {
  bool _loading = true;
  WebViewController? _controller;

  @override
  void initState() {
    initWebview();
    super.initState();
  }

  Future<void> initWebview() async {
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

    WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    final cookieService = AppServiceInject.instance.providerCookieService;

    if (widget.restoreCookies) {
      await cookieService.setWebviewCookies(Uri.parse(baseUrl));
    }

    if (widget.syncLoggedUser) {
      await cookieService.setUser();
    }

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            avoidPrint("WebView is loading (progress : $progress%)");
            if (progress == 100 && _loading) {
              if (mounted) {
                setState(() {
                  _loading = false;
                });
              }
            }
          },
          onPageStarted: widget.onPageStarted,
          onPageFinished: (url) {
            widget.onPageFinished?.call(url);
            widget.onPageFinishedWithController?.call(url, controller);
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (checkWhiteListOpenAppLink(request.url)) {
              return await openAppLink(request.url);
            }
            if (widget.onNavigationRequest != null) return widget.onNavigationRequest!(request);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..runJavaScript(widget.runJavaScript)
      ..setUserAgent(widget.userAgent)
      ..loadRequest(
        widget.uri,
        method: widget.method,
        headers: widget.headers,
        body: widget.body,
      );

    if (widget.javaScriptName != null && widget.onJavaScriptMessageReceived != null) {
      controller.addJavaScriptChannel(widget.javaScriptName!, onMessageReceived: widget.onJavaScriptMessageReceived!);
    }
    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
    if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController).setAllowsBackForwardNavigationGestures(true);
    }
    _controller = controller;
    // #enddocregion platform_features
  }

  @override
  void didUpdateWidget(covariant CirillaWebView oldWidget) {
    if (oldWidget.uri.toString() != widget.uri.toString() ||
        !mapEquals(oldWidget.headers, widget.headers) ||
        String.fromCharCodes(oldWidget.body ?? Uint8List.fromList([])) !=
            String.fromCharCodes(widget.body ?? Uint8List.fromList([]))) {
      _controller?.loadRequest(widget.uri, headers: widget.headers, body: widget.body);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_controller != null)
          WebViewWidget(
            controller: _controller!,
        ),
        if (widget.isLoading && _loading) Center(child: widget.loading ?? buildLoadingOverlay(context)),
      ],
    );
  }
}

/// Check Request.url in whitelist open app link
bool checkWhiteListOpenAppLink(String url) {
  return whiteListOpenAppLink.any((element) => url.startsWith(element));
}

/// Open app link
Future<NavigationDecision> openAppLink(String uri) async {
  if (await canLaunchUrl(Uri.parse(uri))) {
    await launchUrl(Uri.parse(uri));
  } else {
    avoidPrint('Could not launch $uri');
  }
  // Prevent the webview from navigating to the url
  return NavigationDecision.prevent;
}
