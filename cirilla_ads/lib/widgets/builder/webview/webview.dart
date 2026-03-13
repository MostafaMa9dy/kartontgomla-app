import 'dart:async';

import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/models/models.dart';
import 'package:provider/provider.dart';
import 'package:cirilla/webview_flutter.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/widgets/cirilla_webview.dart';

class WebviewWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  const WebviewWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  @override
  State<WebviewWidget> createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> with LoadingMixin, NavigationMixin, ContainerMixin {
  SettingStore? _settingStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double heightWindow = MediaQuery.of(context).size.height;

    String themeModeKey = _settingStore?.themeModeKey ?? 'value';
    String languageKey = _settingStore?.languageKey ?? "text";

    // Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Map<String, dynamic>? margin = get(styles, ['margin'], {});
    Map<String, dynamic>? padding = get(styles, ['padding'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);

    // general config
    Map<String, dynamic> fields = widget.widgetConfig?.fields ?? {};
    double? height = ConvertData.stringToDouble(get(fields, ['height'], 200), 200);
    String url = ConvertData.textFromConfigs(fields['url'], languageKey);
    bool syncAuthWebToApp = get(fields, ['syncAuthWebToApp'], false);
    List<dynamic> items = get(fields, ['items'], []);
    bool syncAuth = get(fields, ['syncAuth'], false);

    // Check validate URL
    // bool validURL = Uri.parse(url).isAbsolute;

    Uri uri = Uri.parse(url);
    bool validURL = uri.isAbsolute;
    Map<String, String> headers = {};

    if (validURL) {
      String? currency = _settingStore?.currency;
      String? locale = _settingStore?.locale;

      if (currency != null) {
        uri = uri.replace(queryParameters: {
          ...uri.queryParameters,
          'currency': currency,
        });
      }

      if (locale != null) {
        uri = uri.replace(queryParameters: {
          ...uri.queryParameters,
          'lang': locale,
        });
      }
    }

    return Container(
      decoration: decorationColorImage(color: background),
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      height: url.isNotEmpty
          ? height == 0
              ? heightWindow
              : height
          : null,
      child: validURL
          ? CirillaWebView(
              /// CookieManager
              uri: uri,
              headers: headers,
              userAgent: !syncAuthWebToApp
                  ? null
                  : 'Mozilla/5.0 (Linux; Android 11; LM-V500N Build/RKQ1.210420.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/102.0.5005.125 Mobile Safari/537.36 Cirilla/3.0.0',
              onNavigationRequest: (NavigationRequest request) {
                Uri uri = Uri.parse(request.url);
                String? token = uri.queryParameters['cirilla-token'];
                if (token != null) {
                  _handleLogin(token);
                }
                return _handleNavigate(request.url, items);
              },
              loading: buildLoading(context, isLoading: true),
              syncLoggedUser: syncAuth,
            )
          : const SizedBox(),
    );
  }

  /// Handle redirect URL
  NavigationDecision _handleNavigate(String url, List<dynamic> items) {
    Map<String, dynamic>? action;

    for (dynamic item in items) {
      Map<String, dynamic>? data = item['data'];
      if (data != null && data['value'] != null && data['value'] != '' && data['condition'] != 'no_condition') {
        if ((data['condition'] == 'url_start' && url.startsWith(data['value'])) ||
            (data['condition'] == 'url_end' && url.endsWith(data['value'])) ||
            (data['condition'] == 'equal_to' && url == data['value']) ||
            (data['condition'] == 'url_contain' && url.contains(data['value']))) {
          action = data['action'];
          break;
        }
      }
    }

    if (action != null) {
      navigate(context, action);
    }

    return NavigationDecision.navigate;
  }

  /// Handle login with param Token
  Future<void> _handleLogin(String token) async {
    try {
      await _authStore.loginByToken(token);
    } catch (e) {
      avoidPrint(e);
    }
  }
}
