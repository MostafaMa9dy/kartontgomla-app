import 'package:cirilla/widgets/cirilla_html.dart';
import 'package:flutter/material.dart';

class TermText extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final String? html;

  const TermText({
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.html,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CirillaHtml(html: html ?? '');
  }
}

class ContainerTermText extends StatefulWidget {
  final Widget? child;
  const ContainerTermText({Key? key, this.child}) : super(key: key);

  @override
  State<ContainerTermText> createState() => _ContainerTermTextState();
}

class _ContainerTermTextState extends State<ContainerTermText> {
  final GlobalKey _key = GlobalKey();
  Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_size.height == 0 && _size.width == 0) {
        setState(() {
          _size = getSize(_key.currentContext!);
        });
      }
    });
    return SizedBox(
      height: _size.height,
      child: OverflowBox(
        maxHeight: 300,
        child: Container(key: _key, child: widget.child),
      ),
    );
  }

  Size getSize(BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    return box.size;
  }
}
