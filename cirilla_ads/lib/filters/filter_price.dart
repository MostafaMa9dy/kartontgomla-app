import 'package:cirilla/models/auth/user.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../models/product/product.dart';

String? b2bkingFilterPrice(BuildContext context, String? price, Product product, String type) {
  AuthStore authStore = Provider.of<AuthStore>(context);
  List<Map<String, dynamic>>? data = product.metaData;

  UserOptions? userOptions = authStore.user?.options;

  if (userOptions == null || userOptions.b2bkingCustomerGroupId == '' || data == null) {
    return price;
  }

  Map<String, dynamic> metaData = data.firstWhere(
    (e) => e['key'] == 'b2bking_${type}_product_price_group_${userOptions.b2bkingCustomerGroupId}',
    orElse: () => {'value': ''},
  );

  if (metaData['value'] == '' || metaData['value'] == null) {
    return price;
  }

  return metaData['value'].replaceAll(',', '');
}


class HideClassPrice extends HtmlExtension {
  final String? className;
  const HideClassPrice({
    this.className,
  });

  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("$className");
  }

  @override
  InlineSpan build(ExtensionContext context) {
    return const WidgetSpan(child: SizedBox());
  }
}