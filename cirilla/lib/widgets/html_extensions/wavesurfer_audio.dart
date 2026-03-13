import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import '../cirilla_audio/cirilla_audio.dart';

class WavesurferAudioExtension extends HtmlExtension {
  const WavesurferAudioExtension();

  @override
  Set<String> get supportedTags => {};

  @override
  bool matches(ExtensionContext context) {
    return context.classes.contains("wavesurfer-block") &&
        context.classes.contains("wavesurfer-audio");
  }

  @override
  InlineSpan build(ExtensionContext context) {

    dom.Document document = html_parser.parse(context.innerHtml);
    dom.Element source = document.getElementsByClassName('wavesurfer-player')[0];
    String uri = source.attributes['data-url'] ?? '';
    if (uri.isNotEmpty) {
      return WidgetSpan(child: CirillaAudio(uri: uri),);
    }
    return WidgetSpan(child: Container());
  }
}