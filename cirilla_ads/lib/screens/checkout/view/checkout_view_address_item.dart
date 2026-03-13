import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/address.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class CheckoutViewAddressItem extends StatefulWidget {
  final bool enable;
  final Map<String, dynamic> data;
  final FieldFormType formType;
  final AddressData addressData;
  final List<String> includeKeys;
  final Map<String, dynamic> additionFields;
  final bool isBooking;
  final Widget child;

  const CheckoutViewAddressItem({
    super.key,
    this.enable = false,
    this.data = const <String, dynamic>{},
    this.formType = FieldFormType.billing,
    this.includeKeys = const [],
    this.additionFields = const {},
    this.isBooking = false,
    required this.addressData,
    required this.child,
  });

  @override
  State<CheckoutViewAddressItem> createState() => _CheckoutViewAddressItemState();
}

class _CheckoutViewAddressItemState extends State<CheckoutViewAddressItem> {
  late bool _showForm;

  @override
  void didChangeDependencies() {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    Map<String, dynamic> fields = getConvertFieldsAddress(getFieldNicknameToAddress(widget.formType, widget.addressData, widget.isBooking, translate), widget.additionFields, widget.includeKeys, widget.formType);
    bool checkValidate = checkValidateAddress(widget.data, fields, widget.formType, translate);

    _showForm = widget.enable ? !checkValidate : true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (!_showForm) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: itemPaddingLarge, vertical: itemPaddingMedium),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(getFormatAddress(widget.data, widget.addressData, widget.formType)),
            ),
            TextButton(
              onPressed: () => setState(() {
                _showForm = true;
              }),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(translate("checkout_edit")),
            ),
          ],
        ),
      );
    }

    return widget.child;
  }
}
