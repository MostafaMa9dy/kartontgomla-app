import 'dart:convert';

import 'package:flutter/material.dart';

class GokwikScreen extends StatefulWidget {
  final dynamic data;
  final String merchantId;
  final bool isTestMode;
  final String cartId;

  final Widget Function(
    String url,
    BuildContext context, {
    String Function(String url)? customHandle,
    bool isLoading,
    String runJavaScript,
    String? javaScriptName,
    void Function(dynamic)? onJavaScriptMessageReceived,
  }) webViewGateway;

  const GokwikScreen({
    super.key,
    required this.data,
    required this.webViewGateway,
    required this.merchantId,
    required this.isTestMode,
    required this.cartId,
  });

  @override
  State<GokwikScreen> createState() => _GokwikScreenState();
}

class _GokwikScreenState extends State<GokwikScreen> {
  String sandboxUrl = "https://sandbox.pdp.gokwik.co/";
  String productionUrl = "https://pdp.gokwik.co/";
  String baseUrl = "";
  @override
  void initState() {
    baseUrl = widget.isTestMode ? sandboxUrl : productionUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String url = "${baseUrl}v4/auto.html?m_id=${widget.merchantId}&checkout_id=${widget.cartId}";
    debugPrint("Gokwik Url ======> ${url.toString()}");
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.chevron_left_rounded, size: 30),
        ),
        title: const Text('Gokwik'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: widget.webViewGateway(
          url,
          context,
          isLoading: true,
          javaScriptName: "Toaster",
          runJavaScript: '''
            if (typeof gokwikSdk !== 'undefined') {
              gokwikSdk.on('order-complete', function(orderDetails) {
                Toaster.postMessage("Order Completed: " + JSON.stringify(orderDetails));
              });
            } else {
              console.log("gokwikSdk not found");
            }
          ''',
          onJavaScriptMessageReceived: (message) {
            if (message.isEmpty) {
              return;
            } else {
              Map<String, dynamic> data = jsonDecode(message);
              if (data["eventname"] == "order-complete") {
                String? orderId = data["data"]["merchant_order_id"];
                Navigator.of(context).pop({
                  "order_id": int.tryParse(orderId ?? ''),
                });
              }
            }
          },
        ),
      ),
    );
  }
}
