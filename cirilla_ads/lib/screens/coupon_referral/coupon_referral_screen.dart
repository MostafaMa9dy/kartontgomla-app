import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/url_launcher.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'widgets/widgets.dart';

class CouponReferralScreen extends StatelessWidget with AppBarMixin {
  static const routeName = '/profile/couponReferral';

  final bool openPopup;

  const CouponReferralScreen({
    this.openPopup = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (context) {
        bool isLogin = Provider.of<AuthStore>(context).isLogin;
        if (!isLogin) {
          if (openPopup) {
            return CouponPopup(
              code: '',
              btnCopy: (code) {
                return const SizedBox();
              },
            );
          }
          return Scaffold(
            appBar: baseStyleAppBar(context, title: translate('referral')),
            body: Center(
              child: Text(translate("you_must_login")),
            ),
          );
        }

        return Provider(
          create: (_) => CouponReferralStore(
            Provider.of<RequestHelper>(context),
          ),
          child: CouponReferralBody(openPopup: openPopup),
        );
      },
    );
  }
}

class CouponReferralBody extends StatefulWidget {
  final bool openPopup;
  const CouponReferralBody({
    Key? key,
    this.openPopup = false,
  }) : super(key: key);
  @override
  State<CouponReferralBody> createState() => _CouponReferralBodyState();
}

class _CouponReferralBodyState extends State<CouponReferralBody> with AppBarMixin, LoadingMixin {
  late AppStore _appStore;
  late AuthStore _authStore;
  late CouponReferralStore _couponReferralStore;
  late SettingStore _settingStore;
  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    String? keyStore = StringGenerate.getCouponReferralKeyStore(
      'coupon_referral',
      userId: Provider.of<AuthStore>(context).user?.id,
    );
    if (_appStore.getStoreByKey(keyStore) == null) {
      CouponReferralStore store = CouponReferralStore(
        Provider.of<RequestHelper>(context),
        key: keyStore,
      )..getCouponReferrals(userId: ConvertData.stringToInt(_authStore.user?.id));

      _appStore.addStore(store);
      _couponReferralStore = store;
    } else {
      _couponReferralStore = _appStore.getStoreByKey(keyStore);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  void onCopy(BuildContext context, {required String text}) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      if (context.mounted) showSuccess(context, 'Copied "$text"');
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (context) {
        CouponReferralData couponReferralData = _couponReferralStore.couponReferralData;

        bool loading = _couponReferralStore.loadingReferral;

        if (loading && !widget.openPopup) {
          return Container(
            color: theme.cardColor,
            child: Center(
              child: buildLoadingOverlay(context),
            ),
          );
        } else if (loading && widget.openPopup) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: buildLoadingOverlay(context),
              )
            ],
          );
        }

        String code = couponReferralData.referralCode ?? 'null';

        String referralLink = "$baseUrl?ref=$code";

        if (widget.openPopup) {
          return CouponPopup(
            code: code,
            couponReferralData: couponReferralData,
            btnCopy: (code) {
              return btnCopy(theme: theme, text: code);
            },
          );
        }

        return Scaffold(
          appBar: baseStyleAppBar(context, title: translate('referral')),
          body: SingleChildScrollView(
            padding: paddingHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('referral_description'),
                  style: textTheme.titleSmall,
                ),
                Padding(
                  padding: paddingVerticalMedium,
                  child: ItemReferral(
                    titleCode: translate('referral_code'),
                    code: code,
                    description: translate('referral_des_code'),
                    btnCopy: btnCopy(theme: theme, text: code),
                  ),
                ),
                ItemReferral(
                  titleCode: translate('referral_link'),
                  code: referralLink,
                  description: translate('referral_des_link'),
                  btnCopy: btnCopy(theme: theme, text: referralLink),
                ),
                Padding(
                  padding: paddingVerticalMedium,
                  child: socicalRow(code, referralLink),
                ),
                totalRow(data: couponReferralData, translate: translate),
                const SizedBox(height: 20),
                CouponList(
                  couponData: couponReferralData.couponData,
                  authStore: _authStore,
                  btnCopy: (code) {
                    return btnCopy(theme: theme, text: code);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget socicalRow(String code, String referralLink) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ItemSocical(
          onTap: () {
            launch('https://www.facebook.com/sharer/sharer.php?u=$referralLink');
          },
        ),
        ItemSocical(
          icon: FontAwesomeIcons.twitter,
          backgroundColor: ColorBlock.twitter,
          onTap: () {
            launch('https://twitter.com/intent/tweet?text=$referralLink');
          },
        ),
        ItemSocical(
          icon: FontAwesomeIcons.whatsapp,
          backgroundColor: ColorBlock.green,
          onTap: () {
            launch('https://web.whatsapp.com/send?text=$referralLink');
          },
        ),
        // const ItemSocical(
        //   icon: FeatherIcons.mail,
        //   backgroundColor: ColorBlock.gray2,
        // ),
      ],
    );
  }

  Widget totalRow({
    required CouponReferralData data,
    required TranslateType translate,
  }) {
    String? utilize = convertCurrency(context, currency: '', price: data.utilize);
    String referredUsers = data.referredUsers ?? '0';
    String noOfCoupons = data.noOfCoupons ?? '0';
    String? currency = _settingStore.currency;
    String? newCurrency = get(getCurrencies[currency], ['symbol'], '\$');
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ItemTotal(
          couponCode: Text(
            "$newCurrency",
            style: TextStyle(
              color: theme.cardColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          title: translate('referral_total_utili'),
          count: utilize,
        ),
        ItemTotal(
          icon: FontAwesomeIcons.users,
          title: translate('referral_total_users'),
          count: referredUsers,
        ),
        ItemTotal(
          icon: FontAwesomeIcons.creditCard,
          title: translate('referral_total_coupons'),
          count: noOfCoupons,
        ),
      ],
    );
  }

  Widget btnCopy({required ThemeData theme, required String text}) {
    return TextButton(
      onPressed: () => onCopy(context, text: text),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        textStyle: theme.textTheme.bodyMedium,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Icon(FeatherIcons.copy, size: 26),
    );
  }
}
