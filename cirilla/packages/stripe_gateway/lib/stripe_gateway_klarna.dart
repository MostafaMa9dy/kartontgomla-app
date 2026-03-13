library stripe_gateway;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_base/payment_base.dart';
import 'widgets/klarna.dart';

class StripeGatewayKlarna implements PaymentBase {
  String publishableKey;
  StripeGatewayKlarna({
    required this.publishableKey,
  });

  /// Payment method key
  ///
  static const key = "stripe_klarna";

  @override
  String get libraryName => "stripe_gateway";

  @override
  String get logoPath => "assets/images/klarna.png";

  @override
  Future<void> initialized({
    required BuildContext context,
    required RouteTransitionsBuilder slideTransition,
    required Future<dynamic> Function(List<dynamic>) checkout,
    required Function(dynamic data) callback,
    required String amount,
    required String currency,
    required Map<String, dynamic> billing,
    required Map<String, dynamic> settings,
    required Future<dynamic> Function({String? cartKey, required Map<String, dynamic> data}) progressServer,
    required String cartId,
    required Widget Function(String url, BuildContext context, {String Function(String url)? customHandle})
        webViewGateway,
  }) async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
    String source = await _handlePayPress(billing: billing);
    if (source != '') {
      List<dynamic> paymentData = [
        {"key": "payment_method", "value": "stripe_klarna"},
        {"key": "wc-stripe-is-deferred-intent", "value": true},
        {"key": "payment_method", "value": "stripe_klarna"},
        {"key": "wc-stripe-is-deferred-intent", "value": true},
        {"key": "wc-stripe-payment-method", "value": source},
        {"key": "save_payment_method", "value": "no"},
        {"key": "billing_email", "value": billing['email']},
        {"key": "billing_first_name", "value": billing['first_name']},
        {"key": "billing_last_name", "value": billing['last_name']},
        {"key": "billing_address_1", "value": billing['address_1']},
        {"key": "billing_address_2", "value": billing['address_2']},
        {"key": "billing_city", "value": billing['city']},
        {"key": "billing_state", "value": billing['state']},
        {"key": "billing_postcode", "value": billing['postcode']},
        {"key": "billing_country", "value": billing['country']},
        {"key": "wc-stripe_klarna-new-payment-method", "value": false},
        {"key": "app", "value": "cirilla"}
      ];
      dynamic res = await checkout(paymentData);
      if (res['message'] != null) {
        callback(PaymentException(error: res['message']));
      } else {
        if (context.mounted) {
          dynamic result = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, _, __) => KlarnaGateway(
                data: res,
                webViewGateway: webViewGateway,
              ),
              transitionsBuilder: slideTransition,
            ),
          );
          if (result != null) {
            callback({
              'redirect': 'order',
              'order_received_url': result['order_received_url'],
            });
          }
        }
      }
    }
  }

  Future<String> _handlePayPress({required Map<String, dynamic> billing}) async {
    try {
      // 1. Gather customer billing information
      BillingDetails billingDetails = BillingDetails(
        email: billing['email'],
        phone: billing['phone'],
        address: Address(
          city: billing['city'],
          country: billing['country'],
          line1: billing['address_1'],
          line2: billing['address_2'],
          state: billing['state'],
          postalCode: billing['postcode'],
        ),
      ); // mocked data for tests

      // 2. Create payment method
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.klarna(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );

      return paymentMethod.id;
    } catch (e) {
      rethrow;
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

    if (error['payment_result'] != null && error['payment_result']['payment_status'] == 'failure') {
      return error['payment_result']['payment_details'][0]['value'];
    }

    return 'Error!';
  }
}
