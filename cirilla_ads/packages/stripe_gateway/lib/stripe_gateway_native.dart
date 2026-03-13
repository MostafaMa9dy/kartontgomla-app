library stripe_gateway;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_base/payment_base.dart';
import 'package:stripe_gateway/widgets/form_credit_card.dart';

class StripeGatewayNative implements PaymentBase {
  /// Payment method key
  ///
  static const key = "stripe";

  @override
  String get libraryName => "stripe_gateway";

  @override
  String get logoPath => "assets/images/stripe.png";

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
    try {
      String pk = settings['testmode']['value'] == "yes"
          ? settings['test_publishable_key']['value']
          : settings['publishable_key']['value'];
      String? source = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => FormCreditCard(
            checkout: checkout,
            billing: billing,
            currency: currency,
            amount: amount,
            pk: pk,
          ),
          transitionsBuilder: slideTransition,
        ),
      );
      if (source == null) {
        callback(PaymentException(error: "Cancel payment"));
        return;
      }
      List<dynamic> paymentData = [
        {"key": "payment_method", "value": "stripe"},
        {"key": "wc-stripe-is-deferred-intent", "value": true},
        {"key": "payment_method", "value": "stripe"},
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
        {"key": "wc-stripe-new-payment-method", "value": false},
        {'key': 'app', 'value': 'cirilla'}
      ];
      dynamic res = await checkout(paymentData);
      if (res['message'] != null) {
        callback(PaymentException(error: res['message']));
      } else {
        if (res != null) {
          String redirectUrl = res['payment_result']['redirect_url'];
          callback({
            'redirect': 'order',
            'order_received_url': redirectUrl,
          });
        }
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

    if (error['payment_result'] != null && error['payment_result']['payment_status'] == 'failure') {
      return error['payment_result']['payment_details'][0]['value'];
    }

    return 'Error!';
  }
}
