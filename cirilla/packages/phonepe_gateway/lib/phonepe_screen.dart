import 'package:flutter/material.dart';

class PhonepeScreen extends StatefulWidget {
  final dynamic data;
  final Widget Function(
    String url,
    BuildContext context, {
    String Function(String url)? customHandle,
    bool? isLoading,
  }) webViewGateway;

  const PhonepeScreen({super.key, required this.data, required this.webViewGateway});

  @override
  State<PhonepeScreen> createState() => _PhonepeScreenState();
}

class _PhonepeScreenState extends State<PhonepeScreen> {
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
        title: const Text('Phonepe'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: widget.webViewGateway(
          "$url&app-builder-checkout-body-class=app-builder-checkout",
          context,
          isLoading: true,
        ),
      ),
    );
  }
}
