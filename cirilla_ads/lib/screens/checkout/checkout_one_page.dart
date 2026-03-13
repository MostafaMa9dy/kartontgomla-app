import 'package:cirilla/models/models.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:payment_base/payment_base.dart';

import 'package:cirilla/payment_methods.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/cart/gateway.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/utils/webview_gateway.dart';
import 'package:cirilla/utils/gateway_error.dart';
import 'package:cirilla/utils/address.dart';
import 'package:cirilla/models/address/address.dart';

import 'package:ui/notification/notification_screen.dart';
import 'package:cirilla/themes/default/checkout/payment_method.dart';
import 'package:cirilla/screens/cart/widgets/cart_total.dart';
import 'package:cirilla/screens/checkout/order_received.dart';
import 'package:cirilla/screens/checkout/view/checkout_view_additional.dart';
import 'package:cirilla/screens/checkout/view/checkout_view_billing_address.dart';
import 'package:cirilla/screens/checkout/view/checkout_view_shipping_address.dart';
import 'package:cirilla/screens/checkout/view/checkout_view_shipping_methods.dart';
import 'package:cirilla/screens/checkout/view/checkout_view_address_input.dart';

class CheckoutOnePage extends StatefulWidget {
  static const routeName = '/checkout-one-page';

  const CheckoutOnePage({super.key});

  @override
  State<CheckoutOnePage> createState() => _CheckoutOnePageState();
}

class _CheckoutOnePageState extends State<CheckoutOnePage>
    with AppBarMixin, NavigationMixin, TransitionMixin, LoadingMixin {
  late AppStore _appStore;
  late AuthStore _authStore;
  late SettingStore _settingStore;

  late CartStore _cartStore;
  late CheckoutAddressStore _checkoutAddressStore;
  AddressBookStore? _addressBookStore;
  Map<String, dynamic> additional = const {};

  /// checkout address
  final _formAddressKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appStore = Provider.of<AppStore>(context);
    _authStore = Provider.of<AuthStore>(context);
    _cartStore = _authStore.cartStore;
    _settingStore = Provider.of<SettingStore>(context);

    if (_cartStore.paymentStore.loading == false && _cartStore.paymentStore.gateways.isEmpty) {
      _cartStore.paymentStore.getGateways();
    }

    WidgetConfig? widgetConfig = _settingStore.data?.screens?['profile']?.widgets?['profilePage']!;
    Map<String, dynamic>? fields = widgetConfig?.fields;

    bool enableAddressBook = get(fields, ['enableAddressBook'], false);

    if (enableAddressBook && _authStore.isLogin) {
      _addressBookStore = AddressBookStore(_settingStore.requestHelper)..getAddressBook();
    }

    Map<String, dynamic> billing = {
      ...?_cartStore.cartData?.billingAddress,
      ..._cartStore.checkoutStore.billingAddress,
    };

    Map<String, dynamic> shipping = {
      ...?_cartStore.cartData?.shippingAddress,
      ..._cartStore.checkoutStore.shippingAddress,
    };

    String countryBilling = get(billing, ['country'], '');
    String countryShipping = get(shipping, ['country'], '');

    if (_appStore.getStoreByKey(keyCheckoutAddressStore) == null) {
      CheckoutAddressStore store = CheckoutAddressStore(
        _settingStore.requestHelper,
        key: keyCheckoutAddressStore,
      );
      _appStore.addStore(store);
      _checkoutAddressStore = store;
    } else {
      _checkoutAddressStore = _appStore.getStoreByKey(keyCheckoutAddressStore);
    }

    _checkoutAddressStore.getAddresses([countryBilling, countryShipping, ""], _settingStore.locale);
  }

  List<Gateway> _getGateways() {
    // Check if user is not logged in then hide wallet payment method
    if (!_authStore.isLogin) {
      _cartStore.paymentStore.gateways.removeWhere((e) => e.id == 'wallet');
    }
    return _cartStore.paymentStore.gateways;
  }

  void navigateOrderReceived(BuildContext context, String? url, int? orderId, String? paymentMethod) {
    Navigator.of(context).pop();
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, _, __) => OrderReceived(orderId: orderId, url: url, paymentMethod: paymentMethod),
      transitionsBuilder: slideTransition,
    ));
  }

  Future<void> _handleCallBack(BuildContext context, dynamic data, PaymentBase payment) async {
    if (data == 'clean-cookies') {
      await AppServiceInject.instance.providerCookieService.clearWebviewCookie();
    } else if (data == 'set-cookies') {
      if (_authStore.isLogin) {
        await AppServiceInject.instance.providerCookieService.setUser();
      } else {
        await AppServiceInject.instance.providerCookieService.setWebviewCookies(Uri.parse(_settingStore.checkoutUrl!));
      }
    } else if (data is DioException) {
      if (GatewayError.mapErrorMessage(data.response?.data) != null) {
        showError(context, GatewayError.mapErrorMessage(data.response?.data));
      } else {
        showError(context, payment.getErrorMessage(data.response?.data));
      }
    } else if (data is PaymentException) {
      showError(context, data.error);
    } else if (data is Map<String, dynamic>) {
      if (data['redirect'] == 'order') {
        int? orderId = ConvertData.stringToIntCanBeNull(data['order_id']);
        String? paymentMethod = get(data, ['payment_method'], null);
        navigateOrderReceived(context, data['order_received_url'], orderId, paymentMethod);
      }
    } else {
      navigateOrderReceived(context, null, null, null);
    }
  }

  Future<void> _progressCheckout(BuildContext context) async {
    if (methods[_cartStore.paymentStore.method] == null) {
      avoidPrint('Then payment method ${_cartStore.paymentStore.method} not implement in app yet.');
      return;
    }

    PaymentBase payment = methods[_cartStore.paymentStore.method] as PaymentBase;
    Map<String, dynamic> settings = _cartStore.paymentStore.gateways[_cartStore.paymentStore.active].settings;

    if (mounted) {
      Map<String, dynamic> billing = {
        ...?_cartStore.cartData?.billingAddress,
        ..._cartStore.checkoutStore.billingAddress,
      };
      await payment.initialized(
        context: context,
        slideTransition: slideTransition,
        checkout: (
          List<dynamic> paymentData, {
          Map<String, dynamic>? billingOptions,
          Map<String, dynamic>? options,
          Map<String, dynamic>? shippingOptions,
        }) =>
            _cartStore.checkoutStore.checkout(
          paymentData,
          billingOptions: billingOptions,
          options: options,
          shippingOptions: shippingOptions,
          additional: additional,
        ),
        callback: (dynamic data) => _handleCallBack(context, data, payment),
        amount: convertCurrencyFromUnit(
            price: _cartStore.cartData?.totals?["total_price"] ?? "0",
            unit: _cartStore.cartData?.totals?["currency_minor_unit"]),
        currency: _cartStore.cartData?.totals?["currency_code"] ?? "USD",
        billing: billing,
        settings: settings,
        progressServer: _cartStore.checkoutStore.progressServer,
        cartId: '${_authStore.isLogin ? _authStore.user?.id : _cartStore.cartKey}',
        webViewGateway: buildCirillaWebViewGateway,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        CartData? cartData = _cartStore.cartData;

        if (cartData == null) {
          return Scaffold(
            appBar: baseStyleAppBar(context, title: ""),
            body: NotificationScreen(
              title: Text(translate('cart_checkout'), style: theme.textTheme.titleLarge),
              content: Text(
                translate('cart_is_currently_empty'),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              iconData: FeatherIcons.shoppingCart,
              textButton: Text(translate('cart_return_shop')),
              styleBtn: ElevatedButton.styleFrom(padding: paddingHorizontalLarge),
              onPressed: () => navigate(context, {
                "type": "tab",
                "router": "/",
                "args": {"key": "screens_category"}
              }),
            ),
          );
        }

        Map<String, dynamic> billing = {
          ...?_cartStore.cartData?.billingAddress,
          ..._cartStore.checkoutStore.billingAddress,
        };

        Map<String, dynamic> shipping = {
          ...?_cartStore.cartData?.shippingAddress,
          ..._cartStore.checkoutStore.shippingAddress,
        };

        String countryBilling = get(billing, ['country'], '');
        String countryShipping = get(shipping, ['country'], '');

        AddressData? addressBilling = getAddressByKey(_checkoutAddressStore.addresses, countryBilling,
            _settingStore.locale, _checkoutAddressStore.countryDefault);
        AddressData? addressShipping = getAddressByKey(_checkoutAddressStore.addresses, countryShipping,
            _settingStore.locale, _checkoutAddressStore.countryDefault);

        Map<String, dynamic> additionFieldsShipping = {
          "shipping_company": {
            "label": translate("checkout_input_company"),
            "class": ["form-row-wide"],
            "autocomplete": "organization",
            "priority": 30,
            if (addressShipping?.shipping?["shipping_company"] is Map)
              ...addressShipping?.shipping?["shipping_company"],
            "required": false,
            "disabled": true,
          },
          "shipping_address_2": {
            "label": translate("checkout_input_address_2"),
            "label_class": ["screen-reader-text"],
            "placeholder": translate("checkout_input_address_2"),
            "class": ["form-row-wide", "address-field"],
            "autocomplete": "address-line2",
            "priority": 60,
            if (addressShipping?.shipping?["shipping_address_2"] is Map)
              ...addressShipping?.shipping?["shipping_address_2"],
            "required": false,
            "disabled": false,
          },
          "shipping_phone": {
            "label": translate("checkout_input_phone"),
            "type": "tel",
            "class": ["form-row-wide"],
            "validate": ["phone"],
            "autocomplete": "tel",
            "priority": 100,
            "required": false,
            "disabled": false,
          }
        };

        Map<String, dynamic> additionFieldsBilling = {
          "billing_company": {
            "label": translate("checkout_input_company"),
            "class": ["form-row-wide"],
            "autocomplete": "organization",
            "priority": 30,
            if (addressShipping?.shipping?["shipping_company"] is Map) ...addressBilling?.shipping?["shipping_company"],
            "required": false,
            "disabled": true,
          },
          "billing_address_2": {
            "label": translate("checkout_input_address_2"),
            "label_class": ["screen-reader-text"],
            "placeholder": translate("checkout_input_address_2"),
            "class": ["form-row-wide", "address-field"],
            "autocomplete": "address-line2",
            "priority": 60,
            if (addressShipping?.shipping?["shipping_address_2"] is Map)
              ...addressBilling?.shipping?["shipping_address_2"],
            "required": false,
            "disabled": false,
          },
          "billing_phone": {
            "label": translate("checkout_input_phone"),
            "type": "tel",
            "class": ["form-row-wide"],
            "validate": ["phone"],
            "autocomplete": "tel",
            "priority": 100,
            "required": false,
            "disabled": false,
          },
          "billing_email": {
            "label": translate("checkout_input_email"),
            "required": false,
            "disabled": true,
            "type": "email",
            "class": ["form-row-wide"],
            "validate": ["email"],
            "autocomplete": "email username",
            "priority": 110
          }
        };

        bool shipToDifferentAddress = _cartStore.checkoutStore.shipToDifferentAddress;

        return Scaffold(
          appBar: baseStyleAppBar(context, title: translate("cart_checkout")),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(layoutPadding, itemPadding, layoutPadding, itemPaddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Form(
                            key: _formAddressKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(translate("checkout_contact"), style: theme.textTheme.titleMedium),
                                const SizedBox(height: 4),
                                Text(
                                  translate("checkout_contact_description"),
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: itemPaddingSmall),
                                CheckoutViewAddressInput(
                                  value: billing["email"],
                                  onChanged: (String value) async {
                                    await _cartStore.checkoutStore.changeAddress(
                                      billing: {
                                        ...billing,
                                        "email": value,
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: itemPaddingLarge),
                                if (_cartStore.cartData?.needsShipping == true) ...[
                                  Text(translate('checkout_shipping'), style: theme.textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text(
                                    translate("checkout_shipping_description"),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: itemPaddingSmall),
                                  CheckoutViewShippingAddress(
                                    additionFields: additionFieldsShipping,
                                    cartStore: _cartStore,
                                    checkoutAddressStore: _checkoutAddressStore,
                                    addressBookStore: _addressBookStore,
                                    checkUpdateBilling: true,
                                    enableItem: true,
                                  ),
                                  Padding(
                                    padding: paddingVerticalLarge,
                                    child: GestureDetector(
                                      onTap: _cartStore.checkoutStore.onShipToDifferentAddress,
                                      child: Row(
                                        children: [
                                          CirillaRadio.iconCheck(isSelect: !shipToDifferentAddress),
                                          const SizedBox(width: itemPaddingSmall),
                                          Expanded(
                                            child: Text(
                                              translate("checkout_same_billing"),
                                              style: theme.textTheme.titleSmall,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                if (_cartStore.cartData?.needsShipping != true ||
                                    _cartStore.checkoutStore.shipToDifferentAddress) ...[
                                  Text(translate("checkout_billing"), style: theme.textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text(
                                    translate("checkout_billing_description"),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: itemPaddingSmall),
                                  CheckoutViewBillingAddress(
                                    additionFields: additionFieldsBilling,
                                    cartStore: _cartStore,
                                    checkoutAddressStore: _checkoutAddressStore,
                                    addressBookStore: _addressBookStore,
                                    checkUpdateShipping: false,
                                    enableItem: true,
                                  ),
                                  const SizedBox(height: itemPaddingLarge),
                                ],
                                CheckoutViewAdditional(
                                  data: additional,
                                  onChange: (value) => setState(() {
                                    additional = value;
                                  }),
                                  checkoutAddressStore: _checkoutAddressStore,
                                ),
                              ],
                            ),
                          ),
                          if (cartData.needsShipping == true) ...[
                            CheckoutViewShippingMethods(cartStore: _cartStore, isDivider: false),
                            const SizedBox(height: itemPaddingLarge),
                          ],
                          Text(translate("checkout_payment_method"), style: theme.textTheme.titleMedium),
                          const SizedBox(height: itemPadding),
                          PaymentMethod(
                            padHorizontal: 0,
                            gateways: _getGateways(),
                            active: _cartStore.paymentStore.active,
                            select: _cartStore.paymentStore.select,
                          ),
                          const SizedBox(height: itemPaddingSmall),
                          CartTotal(cartData: cartData)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: paddingVerticalMedium.add(paddingHorizontal),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      boxShadow: initBoxShadow,
                    ),
                    child: SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final isValid = _formAddressKey.currentState!.validate();
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (!isValid) {
                            return;
                          }

                          _progressCheckout(context);
                        },
                        child: Text(translate("checkout_payment")),
                      ),
                    ),
                  ),
                ],
              ),
              if (_cartStore.checkoutStore.loading || _cartStore.checkoutStore.loadingPayment)
                Stack(
                  children: [
                    const Opacity(
                      opacity: 0.8,
                      child: ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    Align(
                      alignment: FractionalOffset.center,
                      child: buildLoadingOverlay(context),
                    )
                  ],
                )
              else
                const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
