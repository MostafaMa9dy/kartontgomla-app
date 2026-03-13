import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/currencies.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/checkout/order_received.dart';
import 'package:cirilla/service/cookie_service.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/widgets/cirilla_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/webview_flutter.dart';

class CheckoutWebView extends StatefulWidget {
  static const routeName = '/checkout-webview';

  const CheckoutWebView({Key? key}) : super(key: key);

  @override
  State<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> with TransitionMixin, AppBarMixin {
  late SettingStore _settingStore;
  late AuthStore _authStore;
  int _attempt = 0;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  void navigateOrderReceived(BuildContext context, String url) {
    Navigator.of(context).pop();
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, _, __) => OrderReceived(url: url),
      transitionsBuilder: slideTransition,
    ));
  }

  // Load cookies for webview
  Future<bool> _loadCookie(Uri checkoutUri) async {
    // Init cookie service
    CookieService cookieService = AppServiceInject.instance.providerCookieService;
    // Clear webview cookies.
    await cookieService.clearWebviewCookie();
    if (!_authStore.isLogin) {
      await cookieService.setWebviewCookies(checkoutUri);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Map<String, String?> queryParams = {
        'app-builder-checkout-body-class': 'app-builder-checkout',
        if (_settingStore.languageKey != "text") 'lang': _settingStore.locale,
        if (_settingStore.isCurrencyChanged) CURRENCY_PARAM: _settingStore.currency,
      };

      Uri checkoutUri = Uri.parse(_settingStore.checkoutUrl ?? '');

      TranslateType translate = AppLocalizations.of(context)!.translate;
      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate('cart_checkout')),
        body: Builder(builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.only(top: layoutPadding),
              child: FutureBuilder<bool>(
                future: _loadCookie(checkoutUri),
                builder: (context, snapshot) {
                  Uri checkoutPage = Uri(
                    scheme: checkoutUri.scheme,
                    host: checkoutUri.host,
                    port: checkoutUri.port,
                    path: checkoutUri.path,
                    queryParameters: {
                      ...checkoutUri.queryParameters,
                      ...queryParams,
                    },
                  );
                  if (snapshot.hasData && snapshot.data == true) {
                    return CirillaWebView(
                      uri: checkoutPage,
                      syncLoggedUser: true,
                      onNavigationRequest: (NavigationRequest request) {
                        avoidPrint(request.url);

                        if (request.url.contains('/order-received/')) {
                          navigateOrderReceived(context, request.url);
                          return NavigationDecision.prevent;
                        }

                        if (_attempt > 0 && request.url.contains('/cart')) {
                          Navigator.of(context).pop();
                          return NavigationDecision.navigate;
                        }

                        if (request.url.contains('/my-account/')) {
                          return NavigationDecision.prevent;
                        }

                        return NavigationDecision.navigate;
                      },
                      onPageStarted: (String url) {
                        if (url.contains('/order-received/')) {
                          navigateOrderReceived(context, url);
                        }
                        avoidPrint('Page started loading: $url');
                      },
                      onPageFinishedWithController: (String url, WebViewController controller) {
                        Uri uri = Uri.parse(url);
                        if (uri.path == checkoutUri.path) {
                          controller.runJavaScript("const meta = document.createElement('meta');"
                              "meta.name = 'viewport';"
                              "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';"
                              "document.getElementsByTagName('head')[0].appendChild(meta);");
                        }
                        String jsSetCookie = '''
                          setTimeout(function() {
                            var source_type = document.querySelector('input[name="wc_order_attribution_source_type"]');
                            if (source_type) {
                              source_type.value = 'referral';
                            }
                            var origin = document.querySelector('input[name="wc_order_attribution_utm_source"]');
                            if (origin) {
                              origin.value = 'Mobile App';
                            }
                          }, 300);
                        ''';
                        controller.runJavaScript(jsSetCookie);
                        // If the page go to cart page, try load checkout page again
                        if (_attempt < 1 && uri.path.contains('/cart')) {
                          _attempt++;
                          controller.loadRequest(checkoutPage);
                        }
                      },
                    );
                  }
                  return Container();
                },
              ));
        }),
      );
    });
  }
}
