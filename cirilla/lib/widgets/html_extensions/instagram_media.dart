import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../cirilla_instagram.dart';

class InstagramMediaExtension extends HtmlExtension {
  const InstagramMediaExtension();

  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("instagram-media");
  }

  @override
  InlineSpan build(ExtensionContext context) {
    String? url = context.attributes['data-instgrm-permalink'];
    if (url != null) {
      Uri uri = Uri.parse(url);
      return WidgetSpan(child: CirillaInstagram(id: uri.pathSegments[1]));
    }
    return WidgetSpan(child: Container());
  }
}