import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/profile/widgets/address_field_form3.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/address.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cirilla/store/store.dart';
import 'package:provider/provider.dart';

import 'checkout_address_book.dart';
import 'checkout_view_address_item.dart';

class CheckoutViewShippingAddress extends StatefulWidget {
  final Map<String, dynamic>? additionFields;
  final CartStore cartStore;
  final CheckoutAddressStore checkoutAddressStore;
  final AddressBookStore? addressBookStore;
  final bool checkUpdateBilling;
  final bool enableItem;

  const CheckoutViewShippingAddress({
    Key? key,
    this.additionFields,
    required this.cartStore,
    required this.checkoutAddressStore,
    this.addressBookStore,
    this.checkUpdateBilling = false,
    this.enableItem = false,
  }) : super(key: key);

  @override
  State<CheckoutViewShippingAddress> createState() => _CheckoutViewShippingAddressState();
}

class _CheckoutViewShippingAddressState extends State<CheckoutViewShippingAddress> with Utility {
  late SettingStore _settingStore;
  String _name = 'shipping';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
  }

  void onChanged(Map<String, dynamic> value, [String? name]) {
    if (name != null) {
      setState(() {
        _name = name;
      });
    }

    Map<String, dynamic>? billing = {
      ...?widget.cartStore.cartData?.billingAddress,
      ...widget.cartStore.checkoutStore.billingAddress,
    };

    if (widget.checkUpdateBilling) {
      billing = widget.cartStore.checkoutStore.shipToDifferentAddress ? null : value;
    }

    widget.cartStore.checkoutStore.changeAddress(
      billing: billing,
      shipping: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) {
        Map<String, dynamic> shipping = {
          ...?widget.cartStore.cartData?.shippingAddress,
          ...widget.cartStore.checkoutStore.shippingAddress,
        };

        String country = shipping["country"] ?? "";

        AddressData? address = getAddressByKey(widget.checkoutAddressStore.addresses, country, _settingStore.locale,
            widget.checkoutAddressStore.countryDefault);

        Map<String, dynamic>? addressFields = address?.shipping;

        bool loading = widget.addressBookStore?.loading == true ||
            (widget.checkoutAddressStore.loading != false && addressFields?.isNotEmpty != true);

        if (loading) {
          return Column(
            children: [
              if (widget.addressBookStore != null && widget.addressBookStore?.addressBook?.shippingEnable == true) ...[
                const LoadingFieldAddressItem(width: double.infinity),
                const SizedBox(height: 15),
              ],
              const LoadingFieldAddress(),
            ],
          );
        }

        return CheckoutViewAddressItem(
          enable: widget.enableItem,
          data: shipping,
          addressData: address ?? AddressData(),
          additionFields: widget.additionFields ?? <String, dynamic>{},
          formType: FieldFormType.checkoutShipping,
          child: Column(
            children: [
              if (widget.addressBookStore != null && widget.addressBookStore?.addressBook?.shippingEnable == true) ...[
                CheckoutAddressBook(
                  valueSelected: _name,
                  data: widget.addressBookStore?.addressBook ?? AddressBook(),
                  onChanged: onChanged,
                  type: 'shipping',
                ),
                const SizedBox(height: 15),
              ],
              addressFields?.isNotEmpty == true
                  ? AddressFieldForm3(
                      keyForm: _name,
                      data: shipping,
                      addressData: address ?? AddressData(),
                      additionFields: widget.additionFields ?? <String, dynamic>{},
                      onChanged: onChanged,
                      onGetAddressData: (String country) {
                        widget.checkoutAddressStore.getAddresses([country], _settingStore.locale);
                      },
                      formType: FieldFormType.checkoutShipping,
                      checkoutAddressStore: widget.checkoutAddressStore,
                    )
                  : Center(
                      child: Text(translate('address_empty_shipping')),
                    ),
            ],
          ),
        );
      },
    );
  }
}
