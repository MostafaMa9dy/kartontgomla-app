import 'package:cirilla/constants/app.dart';
import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

class CouponPopup extends StatelessWidget {
  final String code;
  final Widget Function(String code)? btnCopy;
  final CouponReferralData? couponReferralData;
  const CouponPopup({
    required this.code,
    this.couponReferralData,
    this.btnCopy,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    Widget child;
    if (code == '') {
      child = Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(translate("referral_signup_share")),
      );
    } else {
      String? referralDiscount = couponReferralData?.referralDiscount ?? "";
      String? referralUpto = couponReferralData?.referralUpto ?? "";
      String? signupDiscount = couponReferralData?.signupDiscount ?? "";
      String? refreeSignup = couponReferralData?.refreeSignup ?? "";
      child = Column(
        children: [
          const SizedBox(height: 20),
          ItemReferral(
            titleCode: translate('referral_code'),
            code: code,
            description: translate('referral_des_code'),
            btnCopy: btnCopy!(code),
          ),
          Padding(
            padding: paddingVertical,
            child: ItemReferral(
              titleCode: translate('referral_link'),
              code: '$baseUrl?ref=$code',
              description: translate('referral_des_link'),
              btnCopy: btnCopy!('$baseUrl?ref=$code'),
            ),
          ),
          Text(translate("referral_steps"), style: TextStyle(color: theme.colorScheme.error)),
          Container(
            padding: paddingMedium,
            margin: paddingVertical,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: borderRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(translate("referral_des_1"), style: textTheme.labelLarge),
                Text(translate("referral_des_2"), style: textTheme.labelLarge),
                buildReferralDiscout(
                  context,
                  translate,
                  referralDiscount: referralDiscount,
                  referralUpto: referralUpto,
                ),
                buildText(
                  context,
                  text1: translate("referral_des_41"),
                  price: signupDiscount,
                  text2: translate("referral_des_42"),
                ),
                buildText(
                  context,
                  text1: translate("referral_des_51"),
                  price: refreeSignup,
                  text2: translate("referral_des_52"),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Container(
      padding: paddingDefault,
      decoration: const BoxDecoration(
        color: ColorBlock.white,
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(translate('referral_invite'), style: textTheme.headlineSmall),
          child,
          Row(
            mainAxisAlignment: code == '' ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
            children: [
              if (code == '') ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: const Size(120, 48),
                    minimumSize: const Size(120, 48),
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RegisterScreen.routeName,
                    arguments: {
                      'showMessage': ({String? message}) {
                        avoidPrint('Register Success');
                      },
                    },
                  ),
                  child: Text(translate("referral_register")),
                ),
                const SizedBox(width: 10),
              ],
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  maximumSize: const Size(120, 48),
                  minimumSize: const Size(120, 48),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(translate('referral_close')),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildReferralDiscout(
    BuildContext context,
    TranslateType translate, {
    String referralDiscount = "",
    String referralUpto = "",
  }) {
    if (referralDiscount.contains('%') && referralUpto == "") {
      return buildText(
        context,
        text1: translate("=> You will get the fixed discount coupon, "),
        price: referralDiscount,
        text2: translate(" of the referral order"),
      );
    }
    if (referralDiscount.contains('%')) {
      return buildText(
        context,
        text1: translate("referral_des_percent_31"),
        price: referralDiscount,
        text2: translate("referral_des_percent_32"),
        upto: referralUpto,
      );
    }
    return buildText(
      context,
      text1: translate("referral_des_31"),
      price: referralDiscount,
      text2: translate("referral_des_32"),
    );
  }

  Widget buildText(
    BuildContext context, {
    required String text1,
    required String price,
    required String text2,
    String? upto,
  }) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    if (price == "") {
      return const SizedBox();
    }
    return Text.rich(
      TextSpan(
        text: text1,
        style: textTheme.labelLarge,
        children: [
          TextSpan(
            text: price,
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          TextSpan(
            text: text2,
          ),
          if (upto != null)
            TextSpan(
              text: upto,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
