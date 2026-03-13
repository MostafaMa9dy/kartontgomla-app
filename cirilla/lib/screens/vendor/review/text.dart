import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final String? name;

  const TextInput({
    Key? key,
    this.value,
    required this.onChanged,
    this.name,
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final _txtInputText = TextEditingController();

  @override
  void initState() {
    _txtInputText.addListener(_onChanged);
    _txtInputText.text = widget.value ?? "";
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TextInput oldWidget) {
    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.value != widget.value && widget.value != _txtInputText.text) {
        _txtInputText.text = widget.value ?? '';
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _txtInputText.dispose();
    super.dispose();
  }

  /// Save data in current state
  ///
  _onChanged() {
    if (_txtInputText.text != widget.value) {
      widget.onChanged(_txtInputText.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return TextFormField(
      controller: _txtInputText,
      validator: (String? value) {
        if (value == null || value.trim().isNotEmpty != true) {
          translate('validate_not_null');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: widget.name,
        alignLabelWithHint: true,
      ),
    );
  }
}
