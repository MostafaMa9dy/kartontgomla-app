import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class CouponList extends StatelessWidget {
  final List<CouponDataReferral>? couponData;
  final AuthStore authStore;
  final Widget Function(String code)? btnCopy;
  const CouponList({
    required this.couponData,
    required this.authStore,
    this.btnCopy,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    TranslateType translate = AppLocalizations.of(context)!.translate;

    List<CouponDataReferral> couponDataList = couponData ?? [];

    if (couponData?.isEmpty == true) {
      return Center(
        child: Text(translate("referral_no_coupons")),
      );
    }
    return Column(
      children: List.generate(
        couponDataList.length,
        (index) {
          CouponDataReferral data = couponDataList[index];
          String code = "${data.couponCode}";
          String? amount = convertCurrency(context, currency: '', price: data.couponAmount) ?? '';
          String? couponCreated = data.couponCreated ?? '';
          String? referredUsers = data.referredUsers ?? '';
          String? event = data.event ?? '';
          String? usageCount = '${data.usageCount}';
          return Container(
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: paddingHorizontal.add(paddingVerticalSmall),
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(code.toUpperCase(), style: textTheme.titleMedium),
                    buildItem(
                      context,
                      lable: translate('referral_amount'),
                      content: amount,
                    ),
                    buildItem(
                      context,
                      lable: translate('referral_coupon_created'),
                      content: couponCreated,
                    ),
                    buildItem(
                      context,
                      lable: translate('referral_event'),
                      content: event,
                    ),
                    buildItem(
                      context,
                      lable: translate('referral_referred_users'),
                      content: referredUsers,
                    ),
                    buildItem(
                      context,
                      lable: translate('referral_usage'),
                      content: usageCount,
                    ),
                  ],
                ),
                btnCopy!(code),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, {String? lable, String? content}) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RichText(
        text: TextSpan(
          text: lable,
          style: textTheme.bodySmall,
          children: <TextSpan>[
            TextSpan(
                text: content,
                style: textTheme.bodyMedium?.copyWith(
                  color: textTheme.titleMedium?.color,
                )),
          ],
        ),
      ),
    );
  }
}
