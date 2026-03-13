import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_total.dart';

class CartCouponList extends StatefulWidget {
  final CartData cartData;
  const CartCouponList({
    Key? key,
    required this.cartData,
  }) : super(key: key);

  @override
  State<CartCouponList> createState() => CartCouponListState();
}

class CartCouponListState extends State<CartCouponList> with LoadingMixin, SnackMixin {
  bool loadingRemove = false;
  late CartStore _cartStore;

  String _total(String? value, String? value2) {
    double total = ConvertData.stringToDouble(value, 0) + ConvertData.stringToDouble(value2, 0);
    return total.toString();
  }

  Future<void> _removeCoupon(BuildContext context, String code) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    try {
      setState(() {
        loadingRemove = true;
      });
      await _cartStore.removeCoupon(code: code);
      setState(() {
        loadingRemove = false;
      });
      if (context.mounted) showSuccess(context, translate('cart_coupon_remove'));
    } catch (e) {
      setState(() {
        loadingRemove = false;
      });
      if (context.mounted) showError(context, e);
    }
  }

  List<CartCoupons> getListCoupon(dynamic value) {
    List<CartCoupons> data = <CartCoupons>[];
    if (value is List && value.isNotEmpty) {
      for (var coupon in value) {
        if (coupon is Map) {
          data.add(CartCoupons.fromJson(coupon.cast<String, dynamic>()));
        }
      }
    }
    return data;
  }

  @override
  void didChangeDependencies() {
    _cartStore = Provider.of<AuthStore>(context).cartStore;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    int? unit = get(widget.cartData.totals, ['currency_minor_unit'], 0);
    String? currencyCode = get(widget.cartData.totals, ['currency_code'], null);

    List<CartCoupons> coupons = getListCoupon(widget.cartData.coupons);

    return Stack(
      children: [
        Column(
          children: List.generate(
            coupons.length,
            (index) {
              String coupon = coupons[index].totals?.totalDiscount ?? '0';
              String? tax = coupons[index].totals?.totalDiscountTax ?? '0';
              bool isPointRedemption = false;
              String couponTitle = coupons[index].code;
              if (couponTitle.contains('wc_points_redemption')) {
                isPointRedemption = true;
              }
              return Column(
                children: [
                  const SizedBox(height: 4),
                  buildCartTotal(
                    title: (isPointRedemption)
                        ? 'Points redemption'
                        : translate('cart_code_coupon', {'code': couponTitle}),
                    price:
                        '- ${convertCurrency(context, unit: unit, currency: currencyCode, price: _total(coupon, tax))}',
                    icon: (!loadingRemove)
                        ? InkWell(
                            onTap: () async {
                              setState(() {
                                loadingRemove = true;
                              });
                              if (!_cartStore.loading) _removeCoupon(context, couponTitle);
                            },
                            child: Icon(Icons.close, size: 16, color: theme.primaryColor),
                          )
                        : null,
                    style: textTheme.bodyMedium,
                  ),
                ],
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: _cartStore.loading && loadingRemove
              ? Align(
                  alignment: Alignment.center,
                  child: entryLoading(context, color: theme.colorScheme.primary),
                )
              : Container(),
        )
      ],
    );
  }
}
