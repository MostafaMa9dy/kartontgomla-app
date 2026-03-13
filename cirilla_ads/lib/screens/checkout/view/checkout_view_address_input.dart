import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class CheckoutViewAddressInput extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const CheckoutViewAddressInput({
    Key? key,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CheckoutViewAddressInput> createState() => _CheckoutViewAddressInputState();
}

class _CheckoutViewAddressInputState extends State<CheckoutViewAddressInput> with Utility {
  final _txtInputText = TextEditingController();

  @override
  void initState() {
    _txtInputText.text = widget.value ?? "";
    _txtInputText.addListener(_onChanged);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CheckoutViewAddressInput oldWidget) {
    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.value != widget.value && widget.value != _txtInputText.text) {
        _txtInputText.text = widget.value ?? "";
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
        if (value?.isNotEmpty != true) {
          return translate('validate_not_null');
        }

        return emailValidator(value: value ?? "", errorEmail: translate('validate_email_value'));
      },
      decoration: InputDecoration(
        labelText: translate(translate("checkout_input_email")),
      ),
    );
  }
}
