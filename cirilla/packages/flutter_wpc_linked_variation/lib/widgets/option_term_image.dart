import 'package:flutter/material.dart';

class OptionTermImageWidget extends StatelessWidget {
  final String? url;
  final bool isSelected;
  final VoidCallback? onClick;

  const OptionTermImageWidget({
    Key? key,
    this.url,
    this.isSelected = false,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: !isSelected ? onClick : null,
      child: _ImageWidget(
        url,
        width: 38,
        height: 38,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(width: 2, color: theme.primaryColor) : null,
      ),
    );
  }
}

class _ImageWidget extends StatefulWidget {
  final String? url;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  const _ImageWidget(
    this.url, {
    this.width = 38,
    this.height = 38,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.border,
  });

  @override
  State<_ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<_ImageWidget> {
  bool networkError = false;

  NetworkImage? backgroundImage;
  AssetImage backgroundImageFallback =
      const AssetImage('assets/images/no_image.png', package: "flutter_wpc_linked_variation");

  @override
  void initState() {
    if (widget.url != null && widget.url != "") {
      backgroundImage = NetworkImage(widget.url!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: !networkError && backgroundImage != null
            ? DecorationImage(
                image: backgroundImage!,
                fit: widget.fit,
                onError: (_, __) {
                  setState(() {
                    networkError = true;
                  });
                })
            : DecorationImage(image: backgroundImageFallback, fit: widget.fit),
        border: widget.border,
        borderRadius: widget.borderRadius,
      ),
      width: widget.width,
      height: widget.height,
    );
  }
}
