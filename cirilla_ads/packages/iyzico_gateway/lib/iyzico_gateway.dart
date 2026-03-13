library iyzico_gateway;

import 'package:flutter/material.dart';
import 'package:payment_base/payment_base.dart';

import 'widgets/iyzico_screen.dart';

class IyzicoCheckoutEmbedGateway implements PaymentBase {
  /// Payment method key
  ///
  static const key = "iyzico";

  @override
  String get libraryName => "iyzico_gateway";

  @override
  String get logoPath => "assets/images/iyzico.png";

  @override
  Future<void> initialized({
    required BuildContext context,
    required RouteTransitionsBuilder slideTransition,
    required Future Function(List p1) checkout,
    required Function(dynamic data) callback,
    required String amount,
    required String currency,
    required Map<String, dynamic> billing,
    required Map<String, dynamic> settings,
    required Future Function({String? cartKey, required Map<String, dynamic> data}) progressServer,
    required String cartId,
    required Widget Function(String url, BuildContext context, {String Function(String url)? customHandle})
        webViewGateway,
  }) async {
    dynamic checkoutData = await checkout([]);
    try {
      if (context.mounted) {
        iyzico(
          context: context,
          cartId: cartId,
          currency: currency,
          callback: callback,
          checkoutData: checkoutData,
          iyzicoKey: key,
          progressServer: progressServer,
          webViewGateway: webViewGateway,
        );
      }
    } catch (e) {
      callback(e);
    }
  }

  @override
  String getErrorMessage(Map<String, dynamic>? error) {
    if (error == null) {
      return 'Something wrong in checkout!';
    }

    if (error['message'] != null) {
      return error['message'];
    }

    return 'Error!';
  }
}

class IyzicoCheckoutRemoteGateway implements PaymentBase {
  /// Payment method key
  ///
  static const key = "iyzico_pwi";

  @override
  String get libraryName => "iyzico_gateway";

  @override
  String get logoPath => "assets/images/iyzico.png";

  @override
  Future<void> initialized({
    required BuildContext context,
    required RouteTransitionsBuilder slideTransition,
    required Future Function(List p1) checkout,
    required Function(dynamic data) callback,
    required String amount,
    required String currency,
    required Map<String, dynamic> billing,
    required Map<String, dynamic> settings,
    required Future Function({String? cartKey, required Map<String, dynamic> data}) progressServer,
    required String cartId,
    required Widget Function(String url, BuildContext context, {String Function(String url)? customHandle})
        webViewGateway,
  }) async {
    dynamic checkoutData = await checkout([]);
    try {
      if (context.mounted) {
        iyzico(
          context: context,
          cartId: cartId,
          currency: currency,
          callback: callback,
          checkoutData: checkoutData,
          iyzicoKey: key,
          progressServer: progressServer,
          webViewGateway: webViewGateway,
        );
      }
    } catch (e) {
      callback(e);
    }
  }

  @override
  String getErrorMessage(Map<String, dynamic>? error) {
    if (error == null) {
      return 'Something wrong in checkout!';
    }

    if (error['message'] != null) {
      return error['message'];
    }

    return 'Error!';
  }
}

Future<void> iyzico({
  required BuildContext context,
  required String cartId,
  required String currency,
  required Function(dynamic data) callback,
  dynamic checkoutData,
  required String iyzicoKey,
  required Future Function({String? cartKey, required Map<String, dynamic> data}) progressServer,
  required Widget Function(String url, BuildContext context, {String Function(String url)? customHandle})
      webViewGateway,
}) async {
  bool supportCurrency() {
    switch (currency.toUpperCase()) {
      case "USD":
        return true;
      case "IRR":
        return true;
      case "EUR":
        return true;
      case "GBP":
        return true;
      case "TRY":
        return true;
      case "NOK":
        return true;
      case "RUB":
        return true;
      case "CHF":
        return true;
      default:
        return false;
    }
  }

  if (supportCurrency()) {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IyzicoScreen(
          checkoutData: checkoutData,
          iyzicoKey: iyzicoKey,
          webViewGateway: webViewGateway,
        ),
      ),
    );
    if (result is Map<String, dynamic> && result['order_received_url'] != null) {
      await progressServer(
        data: {
          'cart_key': cartId,
          'action': 'clean',
        },
        cartKey: cartId,
      );
      callback([]);
    }
  } else {
    callback(
      PaymentException(
          error: 'Currently, we do not support currency with currency code "$currency" Please check the guide again'),
    );
  }
}
