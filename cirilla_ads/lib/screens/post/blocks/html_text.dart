import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/widgets/cirilla_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlText extends StatelessWidget {
  final String? text;
  final Color? fontColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? colorLink;
  final TextAlign? textAlign;

  const HtmlText({
    Key? key,
    this.text,
    this.fontColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.colorLink,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Style styleDefault = Style(
      lineHeight: const LineHeight(1.8),
      padding: HtmlPaddings.zero,
      margin: Margins.zero,
      color: fontColor ?? theme.textTheme.titleLarge?.color,
      fontSize: FontSize(fontSize ?? 14),
      fontWeight: fontWeight ?? FontWeight.w400,
      fontStyle: fontStyle,
      textAlign: textAlign ?? TextAlign.start,
    );

    return CirillaHtml(
      html: "<div>$text</div>",
      style: {
        'html': styleDefault,
        'body': Style(
          padding: HtmlPaddings.zero,
          margin: Margins.zero,
        ),
        'p': Style(
          margin: Margins.zero,
        ),
        'blockquote': Style(
          margin: Margins(left: Margin(itemPaddingMedium)),
        ),
        'h1': Style(margin: Margins.zero),
        'h2': Style(margin: Margins.zero),
        'h3': Style(margin: Margins.zero),
        'h4': Style(margin: Margins.zero),
        'h5': Style(margin: Margins.zero),
        'h6': Style(margin: Margins.zero),
        "div": styleDefault,
        "a": Style(color: colorLink ?? theme.primaryColor),
      },
    );
  }
}