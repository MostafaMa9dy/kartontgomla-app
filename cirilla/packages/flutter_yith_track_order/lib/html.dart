import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';

class TextHtml extends StatelessWidget {
  final String html;
  final Map<String, Style>? style;
  final bool shrinkWrap;
  final Function onCopy;

  const TextHtml({
    Key? key,
    required this.html,
    this.style,
    this.shrinkWrap = true,
    required this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Style bodyStyle = Style.fromTextStyle(theme.textTheme.bodyMedium ?? TextStyle()).copyWith(
      margin: Margins.zero,
      padding: HtmlPaddings.zero,
    );
    return Html(
      data: html,
      style: {
        'html': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'body': bodyStyle,
        'p': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'img': Style(
          padding: HtmlPaddings.symmetric(vertical: 8),
        ),
        ...?style,
      },
      extensions: [
        TagExtension(tagsToExtend: {"br"}, child: SizedBox(height: 10)),
        TagExtension(
          tagsToExtend: {"button"},
          builder: (extensionContext) {
            if (extensionContext.attributes["id"] == "copyButton") {
              return SizedBox(
                width: double.infinity,
                height: 34,
                child: ElevatedButton(
                  onPressed: () => onCopy(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: extensionContext.inlineSpanChildren,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.copy, size: 18),
                    ],
                  ),
                ),
              );
            }

            return SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    children: extensionContext.inlineSpanChildren,
                  ),
                ),
              ),
            );
          },
        ),
        TagExtension(
          tagsToExtend: {"flutter"},
          child: const FlutterLogo(),
        ),
      ],
      shrinkWrap: shrinkWrap,
    );
  }
}
