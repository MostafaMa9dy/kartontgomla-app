import 'package:flutter/material.dart';
import 'package:gokwik_gateway/gokwik_screen.dart';
import 'package:payment_base/payment_base.dart';

class GokwikGateway implements PaymentBase {
  /// Payment method key
  ///
  static const key = "gokwik_prepaid";

  @override
  String get libraryName => "gokwik_gateway";

  @override
  String get logoPath => "assets/images/gokwik.png";

  final String merchantId;

  final bool isTestMode;

  GokwikGateway({
    required this.merchantId,
    this.isTestMode = false,
  });

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
    required Widget Function(
      String url,
      BuildContext context, {
      String Function(String url)? customHandle,
      bool isLoading,
      String runJavaScript,
      String? javaScriptName,
      void Function(dynamic)? onJavaScriptMessageReceived,
    }) webViewGateway,
  }) async {
    dynamic checkoutData;

    if (context.mounted) {

      dynamic result = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => GokwikScreen(
            data: checkoutData,
            webViewGateway: webViewGateway,
            merchantId: merchantId,
            isTestMode: isTestMode,
            cartId: cartId,
          ),
          transitionsBuilder: slideTransition,
        ),
      );
      if (result != null) {
        callback({
          'redirect': 'order',
          'order_received_url': result['order_received_url'],
          'order_id': result['order_id'],
          'payment_method': key,
        });
      }
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
