import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageLoading extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;

  final BoxFit fit;

  final Color color;

  const ImageLoading(
    this.url, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget errorWidget = Image.network(
      "https://cdn.rnlab.io/placeholder-416x416.png",
      width: width,
      height: height,
      fit: fit,
    );
    return Container(
      width: width,
      height: height,
      color: color,
      child: FadeInImage.memoryNetwork(
        width: width,
        height: height,
        placeholder: Uint8List.fromList([]),
        placeholderErrorBuilder: (context, url, error) => const Center(child: CupertinoActivityIndicator()),
        imageErrorBuilder: (context, url, error) => errorWidget,
        image: url ?? "",
        fit: fit,
      ),
    );
  }
}
