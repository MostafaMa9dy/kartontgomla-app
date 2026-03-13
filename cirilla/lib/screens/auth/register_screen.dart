import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/auth/login_screen.dart';
import 'package:cirilla/screens/home/home.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';

///
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

///
import 'layout/register_screen_logo_top.dart';
import 'layout/register_screen_social_top.dart';
import 'layout/register_screen_image_header_top.dart';
import 'layout/register_screen_header_conner.dart';

///
import 'widgets/register_form.dart';
import 'widgets/social_login.dart';
import 'widgets/heading_text.dart';
import 'package:intl/intl.dart';
import 'package:cirilla/constants/constants.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  final SettingStore? store;
  final String? refKey;

  const RegisterScreen({
    Key? key,
    this.store,
    this.refKey,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with AppBarMixin, LoadingMixin, SnackMixin, Utility {
  AuthStore? _authStore;

  CouponReferralStore? _couponReferralStore;

  String? referralKey;

  bool _enableReferralSignup = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore ??= Provider.of<AuthStore>(context);
    referralKey = widget.refKey;
    _handleCouponReferral();
  }

  Future<void> _handleCouponReferral() async {
    if (enableCouponReferral) {
      _couponReferralStore ??= _authStore?.couponReferralStore;
      await _couponReferralStore?.enableReferralSignup();
      _enableReferralSignup = get(
        _couponReferralStore?.enableRefSignup,
        ["enable_ref_signup"],
        false,
      );
      if (!_enableReferralSignup && mounted) {
        referralKey = null;
      }
    }
  }

  Future<void> _handleRegisterWithReferral() async {
    if (enableCouponReferral && _enableReferralSignup && referralKey != null) {
      String expirydate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await _couponReferralStore?.referralSignup(
        referralKey: "$referralKey",
        expirydate: expirydate,
        userId: int.tryParse("${_authStore?.user?.id}"),
      );
    }
  }

  void _handleLogin(Map<String, dynamic> queryParameters) async {
    try {
      await _authStore!.loginStore.login(queryParameters);
      if (mounted) Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  void _handleRegister(Map<String, dynamic> queryParameters) async {
    try {
      await _authStore!.registerStore.register(queryParameters);
      _handleRegisterWithReferral();
      if (mounted) Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.store!.data == null || widget.store!.data!.screens!['register'] == null) return Container();

    WidgetConfig widgetConfig = widget.store!.data!.screens!['register']!.widgets!['register']!;
    TranslateType translate = AppLocalizations.of(context)!.translate;

    // Get configs
    Map<String, dynamic>? configsRegister = widget.store!.data!.screens!['register']!.configs;
    Color appbarColor =
        ConvertData.fromRGBA(get(configsRegister, ['appbarColor', widget.store!.themeModeKey]), Colors.white);
    bool extendBodyBehindAppBar = get(configsRegister, ['extendBodyBehindAppBar'], false);

    // Get fields
    Map<String, dynamic> fields = widgetConfig.fields ?? {};
    bool titleAppBar = get(fields, ['titleAppBar'], false);
    bool enableEmail = get(fields, ['enableEmail'], true);
    String? initCountryCode = get(fields, ['codeCountry', widget.store!.languageKey], '');

    // Get styles
    Map<String, dynamic>? stylesRegister = widgetConfig.styles;
    Color background =
        ConvertData.fromRGBA(get(stylesRegister, ['background', widget.store!.themeModeKey]), Colors.white);

    // Layout
    String layout = widgetConfig.layout ?? Strings.loginLayoutSocialTop;
    return Scaffold(
      backgroundColor: background,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: titleAppBar ? Text(translate('register_app_bar_title')) : null,
        elevation: 0,
        leading: leading(),
      ),
      body: Observer(
        builder: (_) {
          bool loadingCouponRef = enableCouponReferral && _couponReferralStore!.loadingEnableRefCode;

          return Stack(
            children: [
              buildLayout(layout, initCountryCode, enableEmail, widgetConfig, background, translate),
              if (referralKey != null && _authStore?.isLogin == true) ...[
                buildDialogReferral(translate),
              ],
              if (_authStore!.registerStore.loading || _authStore!.loginStore.loading || loadingCouponRef)
                Align(
                  alignment: FractionalOffset.center,
                  child: buildLoadingOverlay(context),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildLayout(
    String layout,
    String? initCountryCode,
    bool enableEmail,
    WidgetConfig widgetConfig,
    Color background,
    TranslateType translate,
  ) {
    String? headerImage = get(widgetConfig.styles, ['headerImage', 'src'], Assets.noImageUrl);
    EdgeInsetsDirectional padding = ConvertData.space(get(widgetConfig.styles, ['padding']));

    bool? registerFacebook = get(widgetConfig.fields, ['registerFacebook'], true);
    bool? registerGoogle = get(widgetConfig.fields, ['registerGoogle'], true);
    bool? registerApple = get(widgetConfig.fields, ['registerApple'], true);
    bool? registerPhoneNumber = get(widgetConfig.fields, ['registerPhoneNumber'], true);

    String? term = get(widgetConfig.fields, ['term', widget.store!.languageKey], '');

    Map<String, bool?> enable = {
      'facebook': registerFacebook,
      'google': registerGoogle,
      'sms': registerPhoneNumber,
      'apple': registerApple,
    };

    Widget social = SocialLogin(
      store: _authStore!.loginStore,
      handleLogin: _handleLogin,
      enable: enable,
      type: 'register',
    );

    Widget registerForm = RegisterForm(
      handleRegister: _handleRegister,
      enableRegisterPhoneNumber: registerPhoneNumber,
      term: term,
      initCountryCode: initCountryCode,
      enableEmail: enableEmail,
      referralKey: referralKey,
      handleReferralKey: (key) {
        setState(() {
          referralKey = key;
        });
      },
    );
    EdgeInsetsDirectional paddingFooter = const EdgeInsetsDirectional.only(top: 24, bottom: 24, start: 20, end: 20);

    switch (layout) {
      case Strings.loginLayoutLogoTop:
        return RegisterScreenLogoTop(
          header: headerImage != "" ? Image.network(headerImage!, height: 48) : Container(),
          registerForm: registerForm,
          socialLogin: social,
          loginText: const _TextLogin(),
          padding: padding,
          paddingFooter: paddingFooter,
        );
      case Strings.loginLayoutImageHeaderTop:
        return RegisterScreenImageHeaderTop(
          header: headerImage != ""
              ? Image.network(
                  headerImage!,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                )
              : Container(),
          title: HeadingText(title: translate('login_txt_register_now')),
          registerForm: registerForm,
          socialLogin: social,
          loginText: const _TextLogin(),
          padding: padding,
          paddingFooter: paddingFooter,
          background: background,
        );
      case Strings.loginLayoutImageHeaderCorner:
        return RegisterScreenImageHeaderConner(
          header: headerImage != ""
              ? Image.network(
                  headerImage!,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                )
              : Container(),
          title: HeadingText(title: translate('login_txt_register_now')),
          registerForm: registerForm,
          socialLogin: social,
          loginText: const _TextLogin(),
          background: background,
          padding: padding,
          paddingFooter: paddingFooter,
        );
      default:
        return RegisterScreenSocialTop(
          padding: padding,
          paddingFooter: paddingFooter,
          header: HeadingText.animated(title: translate('login_txt_register'), enable: enable),
          registerForm: registerForm,
          socialLogin: SocialLogin(
            store: _authStore!.loginStore,
            handleLogin: _handleLogin,
            mainAxisAlignment: MainAxisAlignment.start,
            enable: enable,
            type: 'register',
          ),
          loginText: const _TextLogin(),
        );
    }
  }

  Widget buildDialogReferral(TranslateType translate) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Stack(
      children: [
        const Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Align(
          alignment: FractionalOffset.center,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    translate("referral_signup"),
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    translate("referral_signup_description"),
                    style: textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 48,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(translate("referral_close")),
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _authStore?.logout();
                          },
                          child: Text(translate("sign_out")),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TextLogin extends StatelessWidget {
  const _TextLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    TextTheme textTheme = Theme.of(context).textTheme;
    return TextButton(
      onPressed: () => Navigator.of(context).pushNamed(LoginScreen.routeName),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: textTheme.bodySmall,
      ),
      child: Text(translate('register_btn_login')),
    );
  }
}
