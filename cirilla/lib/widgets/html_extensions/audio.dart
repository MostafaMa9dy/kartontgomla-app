import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import '../cirilla_audio/cirilla_audio.dart';

class AudioExtension extends HtmlExtension {
  const AudioExtension();
  @override
  Set<String> get supportedTags => {"audio"};

  @override
  InlineSpan build(ExtensionContext context) {
    dom.Document document = html_parser.parse(context.innerHtml);
    dom.Element source = document.getElementsByTagName('source')[0];
    String uri = source.attributes['src'] ?? '';

    if (uri.isNotEmpty) {
      return WidgetSpan(
        child: CirillaAudio(uri: uri),
      );
    }

    return WidgetSpan(child: Container());
  }
}