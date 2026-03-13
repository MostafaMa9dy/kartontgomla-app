import 'package:cirilla/constants/app.dart';
import 'package:cirilla/utils/cookie_mgr.dart';
import 'package:cirilla/utils/debug.dart';
import 'package:cirilla/webview_flutter.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'helpers/persist_helper.dart';

const String tokenCookieName = 'cirilla_auth_token';

class CookieService {
  late final WebViewCookieManager _webViewCookieManager = WebViewCookieManager();
  final PersistHelper _persistHelper;
  late final PersistCookieJar _persistCookieJar;
  late final CookieManager _cookieManager;

  CookieService(this._persistHelper) {
    _persistCookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("${_persistHelper.getString('appDocDir')}/.cookies/"),
    );
    _cookieManager = CookieManager(_persistCookieJar);
  }

  PersistCookieJar get persistCookieJar => _persistCookieJar;
  WebViewCookieManager get webViewCookieManager => _webViewCookieManager;
  CookieManager get cookieManager => _cookieManager;

  /// Clear persisted cookies
  Future<void> clearPersistedCookies() async {
    // await _persistCookieJar.delete(Uri.parse(baseUrl));
  }

  // Clear all cookies
  Future<void> clearAllCookies() async {
    // await _persistCookieJar.deleteAll();
  }

  /// Set user token as cookie
  Future<void> setToken(String token) async {
    Uri url = Uri.parse(baseUrl);
    await _webViewCookieManager.setCookie(
      WebViewCookie(
        name: tokenCookieName,
        value: token,
        domain: url.host,
        path: '/',
      ),
    );
  }

  /// Set User
  Future<void> setUser() async {
    String? token = _persistHelper.getToken();
    if (token != null) {
      await setToken(token);
    } else {
      await setToken('deleted');
    }
  }

  /// Set webview cookie
  Future<void> setWebviewCookie(String name, String value) async {
    Uri url = Uri.parse(baseUrl);
    await _webViewCookieManager.setCookie(
      WebViewCookie(
        name: name,
        value: value,
        domain: url.host,
        path: '/',
      ),
    );
  }

  /// Clean webview cookies
  Future<bool> clearWebviewCookie() async {
    final bool hadCookies = await _webViewCookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    avoidPrint("CookieService.clearWebviewCookie: $message");
    return hadCookies;
  }

  /// Get Cookie from Uri
  Future<List<Cookie>> loadForRequest(Uri uri) async {
    return await _persistCookieJar.loadForRequest(uri);
  }

  /// Set webview cookies
  Future<void> setWebviewCookies(Uri uri) async {
    List<Cookie> results = await loadForRequest(uri);
    if (results.isNotEmpty) {
      int i = 0;
      Future.doWhile(() async {
        Cookie cookie = results[i];
        await _webViewCookieManager.setCookie(WebViewCookie(
          name: cookie.name,
          value: Uri.decodeComponent(cookie.value),
          domain: uri.host,
          path: cookie.path ?? '/',
        ));
        i++;
        return i < results.length;
      });
    }
  }
}
