import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/cart/coupon_smart/coupon_input_apply.dart';
import 'package:cirilla/screens/cart/coupon_smart/coupon_smart_screen.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/cart_mixin.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:provider/provider.dart';

class CartCoupon extends StatefulWidget {
  final Function(BuildContext context, int packageId, String rateId)? selectShipping;
  final CartStore? cartStore;
  final bool? enableGuestCheckout;
  final bool? enableShipping;
  final bool? enableCoupon;

  const CartCoupon({
    Key? key,
    this.cartStore,
    this.enableGuestCheckout,
    this.selectShipping,
    this.enableShipping,
    this.enableCoupon,
  }) : super(key: key);

  @override
  State<CartCoupon> createState() => _CartCouponState();
}

class _CartCouponState extends State<CartCoupon>
    with Utility, CartMixin, SnackMixin, GeneralMixin, LoadingMixin, TransitionMixin {
  bool loadingRemove = false;
  bool select = false;
  int? indexSelect;
  TextEditingController myController = TextEditingController();
  late AuthStore _authStore;
  bool enableApply = false;

  @override
  void initState() {
    myController.addListener(() {
      if (myController.text.isNotEmpty) {
        if (!enableApply) {
          setState(() {
            enableApply = true;
          });
        }
      } else {
        if (enableApply) {
          setState(() {
            enableApply = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
  }

  Future<void> _applyCoupon({required String code}) async {
    if (widget.cartStore?.loadingCoupon != true) {
      TranslateType translate = AppLocalizations.of(context)!.translate;
      try {
        await widget.cartStore!.applyCoupon(code: code);
        if (mounted) showSuccess(context, translate('cart_successfully'));
        myController.clear();
      } catch (e) {
        if (mounted) showError(context, e);
      }
    }
  }

  void onCouponList(BuildContext context, List<Coupon> data) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => CouponSmartScreen(
          data: data,
          onSelected: (code) => Navigator.pop(context, code),
        ),
        transitionsBuilder: slideTransition,
      ),
    ).then((value) {
      if (value is String) {
        myController.text = value;
        _applyCoupon(code: value);
      }
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  List<Coupon> getListCoupon(dynamic value) {
    List<Coupon> data = <Coupon>[];
    if (value is List && value.isNotEmpty) {
      for(var coupon in value) {
        if (coupon is Map) {
          data.add(Coupon.fromJson(coupon.cast<String, dynamic>()));
        }
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    CartData cartData = widget.cartStore!.cartData!;

    TranslateType translate = AppLocalizations.of(context)!.translate;

    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    List<Coupon> coupons = getListCoupon(cartData.extensions?["smart-coupon"]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.enableCoupon == true) ...[
          Text(translate('cart_coupon'), style: textTheme.titleSmall),
          CouponInputApply(
            onChanged: (value) {
              setState(() {});
            },
            textController: myController,
            enable: enableApply,
            onApply: () {
              _applyCoupon(code: myController.text);
              setState(() {});
            },
          ),
          if (_authStore.isLogin && coupons.isNotEmpty)...[
            ListTile(
              title: Text(translate('cart_coupon_add')),
              trailing: const Icon(Icons.chevron_right_sharp),
              contentPadding: EdgeInsets.zero,
              dense: true,
              visualDensity: const VisualDensity(vertical: -4),
              onTap: () => onCouponList(context, coupons),
            ),
            const Divider(height: 32, thickness: 1),
          ]
        ],
      ],
    );
  }
}
