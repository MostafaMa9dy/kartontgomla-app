import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderAgain extends StatefulWidget {
  final List<LineItems>? lineItems;
  final Function(bool)? onChange;
  final String? status;
  const OrderAgain({
    super.key,
    this.lineItems,
    this.onChange,
    this.status,
  });

  @override
  State<OrderAgain> createState() => _OrderAgainState();
}

class _OrderAgainState extends State<OrderAgain> with NavigationMixin, LoadingMixin, SnackMixin {
  late CartStore _cartStore;
  late AuthStore _authStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
    _cartStore = _authStore.cartStore..getCart(false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool loadingOrderAgain = false;
  int countItemError = 0;

  void navigateCart(TranslateType translate) {
    widget.onChange!(false);
    if (mounted) {
      if (countItemError != 0) {
        showError(context, "$countItemError ${translate("order_again_error")}");
      }
      navigate(context, {
        "type": "tab",
        "route": "/",
        "args": {"key": "screens_cart"}
      });
    }
  }

  Future<void> onPressed(TranslateType translate) async {
    bool loadingRemoveCart = true;
    try {
      loadingOrderAgain = true;
      widget.onChange!(loadingOrderAgain);
      List<CartItem> itemCart = _cartStore.cartData?.items ?? [];

      if (itemCart.isNotEmpty) {
        loadingRemoveCart = false;
        for (var i = 0; i < itemCart.length; i++) {
          String? key = itemCart[i].key;
          await _cartStore.removeCart(key: key);
          if (i == itemCart.length - 1) {
            loadingRemoveCart = true;
          }
        }
      }

      if (loadingRemoveCart) {
        List<LineItems> dataLineItems = widget.lineItems ?? [];
        List<Map<String, dynamic>> variation = [];
        for (var i = 0; i < dataLineItems.length; i++) {
          LineItems item = dataLineItems[i];
          bool isScreenCart = i == dataLineItems.length - 1;
          if (item.variationId != 0) {
            variation = item.metaData!.map((e) {
              return {
                "attribute": e["key"],
                "value": e["value"],
              };
            }).toList();
          }
          try {
            await _cartStore.addToCart({
              'id': item.productId,
              'quantity': item.quantity,
              'variation': variation,
            });
          } catch (e) {
            countItemError = countItemError + 1;
            if (isScreenCart) {
              navigateCart(translate);
            }
            continue;
          }
          if (isScreenCart) {
            navigateCart(translate);
          }
        }
      }
    } catch (e) {
      widget.onChange!(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    if (widget.status == "completed") {
      return Container(
        padding: const EdgeInsets.only(top: 20),
        alignment: AlignmentDirectional.centerStart,
        child: ElevatedButton(
          onPressed: () => onPressed(translate),
          child: Text(translate("order_again")),
        ),
      );
    }
    return const SizedBox();
  }
}
