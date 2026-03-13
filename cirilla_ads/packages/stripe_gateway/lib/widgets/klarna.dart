import 'package:flutter/material.dart';

class KlarnaGateway extends StatefulWidget {
  final dynamic data;
  final Widget Function(String url, BuildContext context, {String Function(String url)? customHandle}) webViewGateway;

  const KlarnaGateway({Key? key, required this.data, required this.webViewGateway}) : super(key: key);

  @override
  State<KlarnaGateway> createState() => _KlarnaGatewayState();
}

class _KlarnaGatewayState extends State<KlarnaGateway> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.data['payment_result']['redirect_url'];
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.chevron_left_rounded, size: 30),
        ),
        title: const Text('Stripe Klarna'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: widget.webViewGateway(url, context),
      ),
    );
  }
}
