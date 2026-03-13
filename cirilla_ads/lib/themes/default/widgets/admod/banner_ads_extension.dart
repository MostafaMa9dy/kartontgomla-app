import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'banner_ads.dart';

class BannerAdsExtension extends HtmlExtension {
  const BannerAdsExtension();
  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("mobile-ads");
  }

  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(
        child: _BannerAs(extensionContext: context));
  }
}

class _BannerAs extends StatefulWidget {
  final ExtensionContext extensionContext;

  const _BannerAs({required this.extensionContext});

  @override
  State<_BannerAs> createState() => _BannerAsState();
}

class _BannerAsState extends State<_BannerAs> {
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        String type = widget.extensionContext.attributes["data-size"] ?? 'banner';
        String? width = widget.extensionContext.attributes["data-width"];
        String? height = widget.extensionContext.attributes["data-height"];

        bool hideAds = _authStore.user?.options?.hideAds ?? false;
        if (hideAds) return const SizedBox();

        return BannerAds(
          adSize: type,
          width: ConvertData.stringToInt(width, 250),
          height: ConvertData.stringToInt(height, 50),
        );
      },
    );
  }
}