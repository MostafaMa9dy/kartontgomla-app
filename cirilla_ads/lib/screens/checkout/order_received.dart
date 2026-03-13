import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/store/order/order_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/cirilla_webview.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

class OrderReceived extends StatefulWidget {
  final String? url;
  final String? paymentMethod;
  final int? orderId;

  const OrderReceived({
    Key? key,
    this.url,
    this.paymentMethod,
    this.orderId,
  }) : super(key: key);

  @override
  State<OrderReceived> createState() => _OrderReceivedState();
}

class _OrderReceivedState extends State<OrderReceived> with NavigationMixin, AppBarMixin {
  late CartStore _cartStore;
  late AuthStore _authStore;
  late OrderStore _orderStore;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
    _cartStore = _authStore.cartStore;
    await _updateOrderUtm();
    await _cartStore.getCart();
  }

  Future<void> _updateOrderUtm() async {
    if (widget.orderId != null) {
      try {
        if (widget.paymentMethod == "gokwik_prepaid") {
          RequestHelper requestHelper = Provider.of<RequestHelper>(context);
          _orderStore = OrderStore(requestHelper);
          await _orderStore.updateOrderUtm(orderId: widget.orderId);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('order_info')),
      body: buildNotification(context),
    );
  }

  void goShop() {
    // Pop until named route "/"
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    // Go to tab category
    navigate(context, {
      "type": "tab",
      "router": "/",
      "args": {"key": "screens_category"}
    });
  }

  Widget buildNotification(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (widget.url?.isNotEmpty == true) {
      String qr = widget.url!.contains('?') ? '&' : '?';
      String orderDetailUrl =
          '${widget.url}${qr}app-builder-checkout-body-class=app-builder-checkout';

      Map<String, String> headers = {};

      return Column(
        children: [
          Expanded(
            child: CirillaWebView(
              uri: Uri.parse(orderDetailUrl),
              isLoading: false,
              headers: headers,
              syncLoggedUser: true,
            ),
          ),
          Padding(
            padding: paddingDefault,
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => goShop(),
                child: Text(translate('order_return_shop')),
              ),
            ),
          )
        ],
      );
    }

    return NotificationScreen(
      title: Text(translate('order_congrats'), style: Theme.of(context).textTheme.titleLarge),
      content: Text(
        translate('order_thank_you_purchase'),
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      iconData: FeatherIcons.check,
      textButton: Text(translate('order_return_shop')),
      onPressed: () => goShop(),
    );
  }
}
