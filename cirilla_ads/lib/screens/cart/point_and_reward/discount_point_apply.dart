// Flutter libraries
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:collection/collection.dart';

class DiscountPointApply extends StatefulWidget {
  final bool enablePointAndReward;
  final AuthStore authStore;
  final CartStore cartStore;
  const DiscountPointApply({
    super.key,
    this.enablePointAndReward = false,
    required this.authStore,
    required this.cartStore,
  });

  @override
  State<DiscountPointApply> createState() => _DiscountPointApplyState();
}

class _DiscountPointApplyState extends State<DiscountPointApply> with LoadingMixin, SnackMixin {
  TextEditingController controller = TextEditingController();
  bool _loading = false;
  bool _showAddPoint = true;
  String _maxPoint = '';

  @override
  void initState() {
    _maxPoint = get(widget.cartStore.cartData?.extensions, ['points-and-rewards', 'cart_max_points'], '0').toString();
    if (_maxPoint.isNotEmpty) {
      controller.text = _maxPoint;
    }
    super.initState();
  }

  Future<void> _applyPoint(BuildContext context) async {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    bool loading = widget.cartStore.loading && _loading;
    if (!loading && controller.text.trim().isNotEmpty) {
      String? value = controller.text;
      try {
        setState(() {
          _loading = true;
        });
        await widget.cartStore.applyPointDiscount(value: value, cartKey: widget.cartStore.cartKey ?? '');
        setState(() {
          _loading = false;
        });
        if (context.mounted) showSuccess(context, translate('cart_successfully'));
        controller.clear();
      } catch (e) {
        controller.clear();
        setState(() {
          _loading = false;
        });
        if (context.mounted) showError(context, e);
      }
    }
  }

  _checkShowAddPoint(CartStore cartStore) {
    Map<String, dynamic>? pointCoupon =
        cartStore.cartData?.coupons?.firstWhereOrNull((element) => element['code'].contains('wc_points_redemption'));
    if (!widget.authStore.isLogin) {
      _showAddPoint = false;
      return;
    }
    if (pointCoupon != null) {
      _showAddPoint = false;
      return;
    } else {
      _showAddPoint = true;
      if (_maxPoint.isNotEmpty) {
        int? maxValue = int.tryParse(_maxPoint);
        if (maxValue != null && maxValue == 0) {
          _showAddPoint = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (context) {
        bool loading = widget.cartStore.loading && _loading;
        if (widget.cartStore.loadingRemovePoint == BaseState.loadedState) {
          if (_maxPoint.isNotEmpty) {
            controller.text = _maxPoint;
            widget.cartStore.changeRemovePointState(BaseState.initState);
          }
        }
        String? message =
            get(widget.cartStore.cartData?.extensions, ['points-and-rewards', 'redeem_points_message'], null);

        _checkShowAddPoint(widget.cartStore);

        if (!_showAddPoint) {
          return const SizedBox.shrink();
        }
        if (widget.enablePointAndReward) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translate('point'), style: textTheme.titleSmall),
              if (message != null && message.isNotEmpty) CirillaHtml(html: message),
              CirillaTile(
                title: TextField(
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    hintText: translate('point_discount'),
                    hintStyle: theme.textTheme.bodyMedium,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  readOnly: true,
                  controller: controller,
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(89, 48),
                    maximumSize: const Size(89, 48),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    _applyPoint(context);
                  },
                  child: loading
                      ? entryLoading(context, color: theme.colorScheme.onPrimary)
                      : Text(translate('cart_apply')),
                ),
                pad: 8,
                isChevron: false,
                isDivider: false,
              ),
              const SizedBox(height: itemPaddingExtraLarge),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
