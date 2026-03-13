import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ImgExtension extends HtmlExtension {
  const ImgExtension();
  @override
  Set<String> get supportedTags => {"img"};

  @override
  InlineSpan build(ExtensionContext context) {

    double? width = ConvertData.stringToDoubleCanBeNull(context.attributes['width']);
    double? height = ConvertData.stringToDoubleCanBeNull(context.attributes['height']);
    String? url = context.attributes['src'];

    return WidgetSpan(
      child: CssBoxWidget(
        style: context.styledElement?.style ?? Style(),
        child: url?.isNotEmpty == true ? _Image(
          url: url!,
          width: width,
          height: height,
        ) : Container(),
      ),
    );
  }
}

class _Image extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;

  const _Image({
    required this.url,
    this.width,
    this.height,
  });

  @override
  State<_Image> createState() => _ImageState();
}

class _ImageState extends State<_Image> {
  Size size = Size.zero;
  @override
  void initState() {
    if (widget.width != null && widget.height != null) {
      size = Size(widget.width!, widget.height!);
    } else {
      getSize();
    }
    super.initState();
  }

  void getSize() async{
    try {
      Image image = Image.network(widget.url);
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
              (ImageInfo image, bool synchronousCall) {
            var myImage = image.image;
            setState(() {
              size = Size(myImage.width.toDouble(), myImage.height.toDouble());
            });
          },
        ),
      );
    } catch(_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (size.width != 0 && size.height != 0) {
      return LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            double width = size.width;
            double height = size.height;

            if (constraints.maxWidth != double.infinity && constraints.maxWidth < size.width) {
              width = constraints.maxWidth;
              height = (width * size.height) / size.width;
            }

            return CirillaCacheImage(widget.url, width: width, height: height);
          }
      );
    }

    return Container();
  }
}