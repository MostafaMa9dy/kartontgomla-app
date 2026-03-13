import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/profile/widgets/address_field_form3.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/address.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cirilla/store/store.dart';
import 'package:provider/provider.dart';

import 'checkout_address_book.dart';
import 'checkout_view_address_item.dart';

class CheckoutViewBillingAddress extends StatefulWidget {
  final Map<String, dynamic>? additionFields;
  final CartStore cartStore;
  final CheckoutAddressStore checkoutAddressStore;
  final AddressBookStore? addressBookStore;
  final bool checkUpdateShipping;
  final bool enableItem;

  const CheckoutViewBillingAddress({
    Key? key,
    this.additionFields,
    required this.cartStore,
    required this.checkoutAddressStore,
    this.addressBookStore,
    this.checkUpdateShipping = true,
    this.enableItem = false,
  }) : super(key: key);

  @override
  State<CheckoutViewBillingAddress> createState() => _CheckoutViewBillingAddressState();
}

class _CheckoutViewBillingAddressState extends State<CheckoutViewBillingAddress> with Utility {
  late SettingStore _settingStore;
  String _name = 'billing';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
  }

  void onChanged(Map<String, dynamic> value, [String? name]) async {
    if (name != null) {
      setState(() {
        _name = name;
      });
    }

    Map<String, dynamic>? shipping;

    if (widget.checkUpdateShipping) {
      shipping = widget.cartStore.checkoutStore.shipToDifferentAddress ? null : value;
    }

    await widget.cartStore.checkoutStore.changeAddress(
      billing: value,
      shipping: shipping,
    );
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Observer(
      builder: (_) {
        Map<String, dynamic> billing = {
          ...?widget.cartStore.cartData?.billingAddress,
          ...widget.cartStore.checkoutStore.billingAddress,
        };

        String country = billing["country"] ?? "";

        AddressData? address = getAddressByKey(widget.checkoutAddressStore.addresses, country, _settingStore.locale,
            widget.checkoutAddressStore.countryDefault);
        Map<String, dynamic>? addressFields = address?.billing;

        bool loading = widget.addressBookStore?.loading == true ||
            (widget.checkoutAddressStore.loading != false && addressFields?.isNotEmpty != true);

        if (loading) {
          return Column(
            children: [
              if (widget.addressBookStore != null && widget.addressBookStore?.addressBook?.billingEnable == true) ...[
                const LoadingFieldAddressItem(width: double.infinity),
                const SizedBox(height: 15),
              ],
              const LoadingFieldAddress(count: 10)
            ],
          );
        }

        return CheckoutViewAddressItem(
          enable: widget.enableItem,
          data: billing,
          addressData: address ?? AddressData(),
          additionFields: widget.additionFields ?? <String, dynamic>{},
          formType: FieldFormType.checkoutBilling,
          child: Column(
            children: [
              if (widget.addressBookStore != null && widget.addressBookStore?.addressBook?.billingEnable == true) ...[
                CheckoutAddressBook(
                  valueSelected: _name,
                  data: widget.addressBookStore?.addressBook ?? AddressBook(),
                  onChanged: onChanged,
                ),
                const SizedBox(height: 15),
              ],
              addressFields?.isNotEmpty == true
                  ? AddressFieldForm3(
                      key: Key(_name),
                      keyForm: _name,
                      data: billing,
                      addressData: address ?? AddressData(),
                      additionFields: widget.additionFields ?? <String, dynamic>{},
                      onChanged: onChanged,
                      onGetAddressData: (String country) {
                        widget.checkoutAddressStore.getAddresses([country], _settingStore.locale);
                      },
                      formType: FieldFormType.checkoutBilling,
                      checkoutAddressStore: widget.checkoutAddressStore,
                    )
                  : Center(child: Text(translate('address_empty_shipping'))),
            ],
          ),
        );
      },
    );
  }
}
