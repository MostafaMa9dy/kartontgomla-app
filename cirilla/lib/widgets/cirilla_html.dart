import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_all/flutter_html_all.dart';
import 'package:cirilla/utils/url_launcher.dart';
import 'package:html/dom.dart' as dom;

import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/constants/styles.dart';
import 'html_extensions/html_extensions.dart';

class CirillaHtml extends StatelessWidget {
  final String html;
  final Map<String, Style>? style;
  final bool shrinkWrap;
  final List<HtmlExtension>? extensions;
  final List<String>? tagsList;

  const CirillaHtml({
    Key? key,
    required this.html,
    this.style,
    this.shrinkWrap = false,
    this.extensions,
    this.tagsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      style: {
        'p': Style(
          lineHeight: const LineHeight(1.8),
          fontSize: FontSize(16),
        ),
        'div': Style(
          lineHeight: const LineHeight(1.8),
          fontSize: FontSize(16),
        ),
        'img': Style(
          padding: HtmlPaddings.symmetric(vertical: itemPadding),
        ),
        ...?style,
      },
      extensions: [
        if (extensions?.isNotEmpty == true) ...extensions!,
        ...appCustomExtensions,
      ],
      onLinkTap: (
        String? url,
        Map<String, String> attributes,
        dom.Element? element,
      ) {
        if (url is String && Uri.parse(url).isAbsolute) {
          if (attributes['data-id-selector'] is String) {
            String queryString = Uri(queryParameters: {
              'app-builder-css': 'true',
              'id-selector': attributes['data-id-selector'],
            }).query;

            String urlData = url.contains("?") ? "$url&$queryString" : "$url?$queryString";
            Navigator.of(context).pushNamed(WebViewScreen.routeName, arguments: {
              'url': urlData,
              ...attributes,
              'name': element!.text,
            });
          } else {
            launch(url);
          }
        }
      },
      shrinkWrap: shrinkWrap,
    );
  }
}

const List<HtmlExtension> appCustomExtensions = <HtmlExtension>[
  AudioExtension(),
  ImgExtension(),
  WavesurferAudioExtension(),
  YithMessageVariationHideExtension(),
  TwitterTweetExtension(),
  InstagramMediaExtension(),
  TwitterTweetExtension(),
  TableHtmlExtension(),
  AudioHtmlExtension(),
  SvgHtmlExtension(),
  VideoHtmlExtension(),
  IframeHtmlExtension(),
];
