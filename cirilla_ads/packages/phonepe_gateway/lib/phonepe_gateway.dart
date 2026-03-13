import 'package:phonepe_gateway/phonepe_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:payment_base/payment_base.dart';

class PhonepeGateway implements PaymentBase {
  /// Payment method key
  ///
  static const key = "phonepe";

  @override
  String get libraryName => "phonepe_gateway";

  @override
  String get logoPath => "assets/images/phonepe.png";

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
      bool? isLoading,
    }) webViewGateway,
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
    if (context.mounted) {
      dynamic result = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => PhonepeScreen(
            data: checkoutData,
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
