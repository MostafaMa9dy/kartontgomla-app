library paytm_gateway;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payment_base/payment_base.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

import 'utils/helper.dart';

class PaytmGateway implements PaymentBase {
  /// Payment method key
  ///
  static const key = "paytm";

  @override
  String get libraryName => "paytm_gateway";

  @override
  String get logoPath => "assets/images/paytm_logo.png";

  Map<String, dynamic> convertData(List data, String key) {
    return data.where((e) => e['key'] == key).first;
  }

  Future<void> _startTransaction({
    dynamic checkoutData,
    required Map<String, dynamic> settings,
    required String amount,
    required Function(dynamic data) callback,
  }) async {
    List paymentDetails = getData(checkoutData, ['payment_result', 'payment_details'], "");

    Map<String, dynamic> dataTxnToken = convertData(paymentDetails, "txnToken");
    String txnToken = getData(dataTxnToken, ['value'], '');

    Map<String, dynamic> dataOrderId = convertData(paymentDetails, "order_id");
    String orderId = getData(dataOrderId, ['value'], '');

    bool isStaging = getData(settings, ['environment', 'value'], "") == "";

    Map<String, dynamic> dataCallbackUrl = convertData(paymentDetails, "callback_url");
    String callbackUrl = getData(dataCallbackUrl, ['value'], '');

    String mid = getData(settings, ['merchant_id', 'value'], "");

    bool restrictAppInvoke = false;

    if (txnToken.isEmpty) {
      return;
    }

    try {
      var response = AllInOneSdk.startTransaction(
        mid,
        orderId,
        amount,
        txnToken,
        callbackUrl,
        isStaging,
        restrictAppInvoke,
      );
      response.then((value) {
        callback([]);
        return value.toString();
      }).catchError((onError) {
        if (onError is PlatformException) {
          callback(PaymentException(error: "${onError.message}"));
          return "${onError.message} \n ${onError.details}";
        } else {
          callback(PaymentException(error: onError.toString()));
          return onError.toString();
        }
      });
    } catch (err) {
      callback(PaymentException(error: "$err"));
    }
  }

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
    dynamic checkoutData;
    try {
      checkoutData = await checkout([
        {'key': 'app', 'value': 'cirilla'}
      ]);
    } catch (e) {
      callback(e);
      return;
    }
    if (checkoutData != null) {
      await callback('clean-cookies');
      await callback('set-cookies');
      await _startTransaction(
        settings: settings,
        amount: amount,
        checkoutData: checkoutData,
        callback: callback,
      );
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
