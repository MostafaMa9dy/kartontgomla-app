import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ui/notification/notification_screen.dart';

import 'coupon_input_apply.dart';

class CouponSmartScreen extends StatefulWidget {
  final List<Coupon> data;
  final ValueChanged<String> onSelected;

  const CouponSmartScreen({
    this.data = const <Coupon>[],
    required this.onSelected,
    super.key,
  });

  @override
  State<CouponSmartScreen> createState() => CouponSmartScreenState();
}

class CouponSmartScreenState extends State<CouponSmartScreen> with AppBarMixin, LoadingMixin {
  Coupon? selected;
  final TextEditingController _controller = TextEditingController();

  bool enableApply = false;

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSelectCoupon(Coupon value) {
    _controller.text = value.couponCode?.toUpperCase() ?? '';
    setState(() {
      selected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    List<Coupon> coupons = widget.data;

    String couponCode = selected?.couponCode ?? _controller.text;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('cart_coupon_list')),
        leading: leadingPined(),
      ),
      body: Column(
        children: [
          if (coupons.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(layoutPadding, itemPadding, layoutPadding, itemPaddingMedium),
              child: CouponInputApply(
                onChanged: (value) {
                  setState(() {});
                },
                textController: _controller,
                onApply: () => widget.onSelected(_controller.text),
                enable: enableApply,
              ),
            ),
          Expanded(
            child: coupons.isEmpty
                ? NotificationScreen(
              title: Text(
                translate('cart_coupon_list'),
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              content: Text(
                translate('cart_coupon_empty'),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              iconData: FeatherIcons.layers,
              isButton: false,
            )
                : _CouponListPageData(
              data: coupons,
              selected: selected,
              onSelected: onSelectCoupon,
            ),
          ),
        ],
      ),
      bottomNavigationBar: coupons.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(layoutPadding),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: enableApply ? () => widget.onSelected(couponCode) : null,
            child: Text(translate('cart_apply')),
          ),
        ),
      )
          : null,
    );
  }
}

class _CouponListPageData extends StatelessWidget {
  final List<Coupon?> data;
  final Coupon? selected;
  final ValueChanged<Coupon> onSelected;

  const _CouponListPageData({
    required this.data,
    required this.onSelected,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(layoutPadding, itemPadding, layoutPadding, itemPadding),
      itemBuilder: (_, int index) {
        Coupon? item = data[index];
        bool valueSelected = item?.couponCode == selected?.couponCode;
        return CirillaCouponItem(
          coupon: data[index],
          selected: valueSelected,
          onChangeSelected: () {
            if (item != null && !valueSelected) {
              onSelected(item);
            }
          },
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: data.length,
    );
  }
}
