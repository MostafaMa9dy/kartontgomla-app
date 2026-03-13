import 'package:flutter/material.dart';
import 'package:cirilla/types/types.dart';
import 'models/product/product.dart';

/// Import other product custom widget here
/// Register product custom widget
///
/// [context] is [BuildContext] of the custom widget
/// [product] is the product of the custom widget
/// [key] is the key of the custom widget
/// [dataJson] is the data of the custom widget
/// [translate] is translate of the custom widget
/// [baseUrl] is url of the custom widget
/// [consumerKey] is url of the custom widget
/// [consumerSecret] is url of the custom widget
///
/// Return a widget
Widget registerProductCustomWidget(BuildContext context, Product? product, String key, String dataJson, TranslateType translate, String baseUrl, String consumerKey, String consumerSecret) {
  /// Return a widget here
  if (key == 'placeholder') {
    return const Placeholder();
  }

  return Container();
}