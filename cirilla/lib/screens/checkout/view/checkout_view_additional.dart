import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/screens/profile/widgets/address_field_form3.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:cirilla/utils/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cirilla/store/store.dart';
import 'package:provider/provider.dart';

class CheckoutViewAdditional extends StatefulWidget {
  final Map<String, dynamic> data;
  final ValueChanged<Map<String, dynamic>> onChange;
  final CheckoutAddressStore checkoutAddressStore;

  const CheckoutViewAdditional({
    Key? key,
    required this.data,
    required this.onChange,
    required this.checkoutAddressStore,
  }) : super(key: key);

  @override
  State<CheckoutViewAdditional> createState() => _CheckoutViewAdditionalState();
}

class _CheckoutViewAdditionalState extends State<CheckoutViewAdditional> with Utility {
  late SettingStore _settingStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        AddressData? address = getAddressByKey(widget.checkoutAddressStore.addresses, "", _settingStore.locale,
            widget.checkoutAddressStore.countryDefault);
        Map<String, dynamic>? addressFields = address?.additional;
        bool loading = widget.checkoutAddressStore.loading;

        if (!loading && addressFields?.isNotEmpty != true) {
          return Container();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: itemPaddingMedium),
          child: loading
              ? const LoadingFieldAddress(count: 5)
              : AddressFieldForm3(
                  keyForm: "additional",
                  data: widget.data,
                  addressData: address ?? AddressData(),
                  onChanged: widget.onChange,
                  onGetAddressData: (_) {},
                  formType: FieldFormType.additional,
                  checkoutAddressStore: widget.checkoutAddressStore,
                ),
        );
      },
    );
  }
}
