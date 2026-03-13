import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/store/product/variation_store.dart';

class TermVariable extends StatelessWidget {
  final String? option;
  final String? label;
  final bool? isSelected;
  final bool canSelect;
  final Function? onSelectTerm;
  final Map? value;
  final VariationStore? store;
  final bool productShowOutOfStock;
  final Size imageAttriSize;

  const TermVariable({
    Key? key,
    this.option,
    this.label,
    this.isSelected,
    this.onSelectTerm,
    required this.canSelect,
    this.value,
    this.store,
    this.productShowOutOfStock = false,
    this.imageAttriSize = const Size(38, 38),
  }) : super(key: key);

  Container boxCircle({
    double? size,
    Color? color,
    Border? border,
  }) {
    return Container(
      width: size ?? 39,
      height: size ?? 39,
      decoration: BoxDecoration(
        color: color,
        border: border,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget buildColor({ThemeData? theme}) {
    Color? color = ConvertData.fromHex(value!['value'], Colors.transparent);

    Widget child = Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: boxCircle(color: color, size: 27),
        ),
        isSelected!
            ? boxCircle(
                border: Border.all(width: 2, color: theme!.primaryColor),
              )
            : boxCircle(
                border: Border.all(color: theme!.dividerColor),
              )
      ],
    );
    if (!canSelect) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: !canSelect ? null : onSelectTerm as void Function()?,
      child: Opacity(
        opacity: canSelect ? 1 : 0.6,
        child: child,
      ),
    );
  }

  Widget buildImage({ThemeData? theme}) {
    String url = value?['value'] != '' && value?['value'] != null ? value!['value'] : Assets.noImageUrl;
    if (!canSelect && !productShowOutOfStock) {
      return const SizedBox();
    } else {
      return showX(
        isHide: !canSelect,
        theme: theme,
        child: InkWell(
          onTap: !canSelect
              ? null
              : () {
                  store?.selectImage(value: url);
                  onSelectTerm!();
                },
          child: Opacity(
            opacity: canSelect ? 1 : 0.6,
            child: Container(
              width: imageAttriSize.width,
              height: imageAttriSize.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
                border: isSelected!
                    ? Border.all(width: 2, color: theme!.primaryColor)
                    : Border.all(width: 1, color: theme!.dividerColor),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget showX({required Widget child, bool isHide = false, ThemeData? theme}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        if (isHide)
          const Positioned(
            child: Icon(Icons.close, size: 40, color: Colors.red),
          ),
      ],
    );
  }

  Widget showXchild() {
    return Uri.parse(label!).isAbsolute
        ? CirillaCacheImage(
            label!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          )
        : Text(label!);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle? titleButton = theme.textTheme.bodyMedium;

    if (value != null && value!['type'] == 'color') return buildColor(theme: theme);
    if (value != null && value!['type'] == 'image') return buildImage(theme: theme);

    bool hide = !canSelect;
    if (!canSelect && !productShowOutOfStock) {
      return const SizedBox();
    } else {
      if (isSelected!) {
        return showX(
          isHide: hide,
          theme: theme,
          child: OutlinedButton(
            onPressed: onSelectTerm as void Function()?,
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.primaryColor,
              side: BorderSide(width: 2, color: theme.primaryColor),
              textStyle: titleButton,
              minimumSize: const Size(40, 48),
              padding: paddingHorizontal,
            ),
            child: showXchild(),
          ),
        );
      }
      return showX(
        isHide: hide,
        theme: theme,
        child: OutlinedButton(
          onPressed: !canSelect || hide ? null : onSelectTerm as void Function()?,
          style: OutlinedButton.styleFrom(
            foregroundColor: titleButton!.color,
            side: BorderSide(width: 1, color: theme.dividerColor),
            textStyle: titleButton,
            minimumSize: const Size(40, 48),
            padding: paddingHorizontal,
          ),
          child: showXchild(),
        ),
      );
    }
  }
}
