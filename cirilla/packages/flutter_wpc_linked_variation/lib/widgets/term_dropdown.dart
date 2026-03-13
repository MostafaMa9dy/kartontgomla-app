import 'package:collection/collection.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import '../model.dart';
import 'tile.dart';

class TermDropdownWidget extends StatefulWidget {
  final String? value;
  final List<TermModel> terms;
  final ValueChanged<String>? onChange;

  const TermDropdownWidget({
    Key? key,
    this.value,
    this.terms = const <TermModel>[],
    this.onChange,
  }) : super(key: key);

  @override
  State<TermDropdownWidget> createState() => _TermDropdownWidgetState();
}

class _TermDropdownWidgetState extends State<TermDropdownWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    TermModel? term = widget.terms.firstWhereOrNull((t) => t.slug == widget.value);
    _controller = TextEditingController(text: term?.name ?? "");
    _controller.addListener(_onChanged);
    super.initState();
  }

  /// Save data in current state
  ///
  _onChanged() {
    TermModel? term = widget.terms.firstWhereOrNull((t) => t.name == _controller.text);
    if (term?.slug != null && widget.value != term?.slug) {
      widget.onChange?.call(term!.slug);
    }
  }

  @override
  void didUpdateWidget(covariant TermDropdownWidget oldWidget) {
    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.value != widget.value) {
        TermModel? term = widget.terms.firstWhereOrNull((t) => t.slug == widget.value);
        if (term?.name != _controller.text) {
          _controller.text = term?.name ?? "";
        }
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void showOption() async {
    if (!_focusNode.hasPrimaryFocus) {
      _focusNode.unfocus();
    }
    ThemeData theme = Theme.of(context);

    TextStyle? titleStyle = theme.textTheme.titleSmall;
    TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);

    String? value = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        MediaQueryData mediaQuery = MediaQuery.of(context);

        return Container(
          constraints: BoxConstraints(maxHeight: mediaQuery.size.height / 2),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: List.generate(widget.terms.length, (index) {
                TermModel term = widget.terms.elementAt(index);
                bool selected = term.slug == widget.value;

                return TileWidget(
                  title: Text(term.name, style: selected ? activeTitleStyle :titleStyle),
                  trailing: selected ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
                  onTap: () => Navigator.of(context).pop(selected ? null : term.name),
                );
              }),
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    );
    if (value != null) {
      _controller.text = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      readOnly: true,
      onTap: showOption,
    );
  }
}
