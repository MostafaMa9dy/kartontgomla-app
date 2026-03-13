import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/screens/profile/widgets/fields/loading_field_address.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/address.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';

import '../address_billing.dart';

class AddressFormScreen extends StatefulWidget {
  final Map<String, dynamic>? initAddress;
  final String keyName;
  final String keyForm;
  final List<String> addressKeys;

  const AddressFormScreen({
    Key? key,
    required this.keyName,
    this.initAddress,
    this.keyForm = 'billing',
    this.addressKeys = const [],
  }) : super(key: key);

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> with SnackMixin, AppBarMixin {
  late AppStore _appStore;
  late AuthStore _authStore;
  late SettingStore _settingStore;
  late CheckoutAddressStore _checkoutAddressStore;
  late CustomerStore _customerStore;
  bool? _loading;

  late bool edit;

  @override
  void initState() {
    _appStore = Provider.of<AppStore>(context, listen: false);
    _authStore = Provider.of<AuthStore>(context, listen: false);
    _settingStore = Provider.of<SettingStore>(context, listen: false);

    _customerStore = CustomerStore(_settingStore.requestHelper);

    String country = get(widget.initAddress, ['country'], '');

    if (_appStore.getStoreByKey(keyCheckoutAddressStore) == null) {
      CheckoutAddressStore store = CheckoutAddressStore(
        _settingStore.requestHelper,
        key: keyCheckoutAddressStore,
      );

      _appStore.addStore(store);
      _checkoutAddressStore = store;
    } else {
      _checkoutAddressStore = _appStore.getStoreByKey(keyCheckoutAddressStore);
    }

    _checkoutAddressStore.getAddresses([country], _settingStore.locale);
    edit = widget.initAddress != null;
    super.initState();
  }

  postAddress(Map data) async {
    try {
      setState(() {
        _loading = true;
      });
      TranslateType translate = AppLocalizations.of(context)!.translate;
      Map? billing;
      Map? shipping;
      List<Map<String, dynamic>> meta = [];

      switch (widget.keyName) {
        case 'shipping':
          shipping = data;
          for (String key in data.keys) {
            if (key == 'address_nickname' || key.contains('wooccm')) {
              meta.add({
                'key': '${widget.keyName}_$key',
                'value': data[key],
              });
            }
          }
          break;
        case 'billing':
          billing = data;
          for (String key in data.keys) {
            if (key == 'address_nickname' || key.contains('wooccm')) {
              meta.add({
                'key': '${widget.keyName}_$key',
                'value': data[key],
              });
            }
          }
          break;
        default:
          for (String key in data.keys) {
            meta.add({
              'key': '${widget.keyName}_$key',
              'value': data[key],
            });
          }
      }
      if (!edit) {
        String keyBook = widget.keyForm == 'shipping' ? 'wc_address_book_shipping' : 'wc_address_book_billing';
        meta.add({
          'key': keyBook,
          'value': [...widget.addressKeys, widget.keyName],
        });
      }

      Map<String, dynamic> dataCustom = {
        'billing': billing,
        'shipping': shipping,
        'meta_data': meta,
      }..removeWhere((key, value) => value == null);

      await _customerStore.updateCustomer(
        userId: _authStore.user!.id,
        data: dataCustom,
      );
      setState(() {
        _loading = false;
      });
      if (mounted) {
        String textSuccess =
            edit ? translate('address_book_update_success_form') : translate('address_book_add_success_form');
        showSuccess(context, textSuccess);
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        String country = widget.initAddress?["country"] ?? "";
        AddressData? addressData = getAddressByKey(
            _checkoutAddressStore.addresses, country, _settingStore.locale, _checkoutAddressStore.countryDefault);
        Map<String, dynamic>? addressFieldInit =
            widget.keyForm == 'shipping' ? addressData?.shipping : addressData?.billing;

        bool loading = _checkoutAddressStore.loading != false && addressFieldInit?.isNotEmpty != true;

        return Scaffold(
          appBar: baseStyleAppBar(
            context,
            title: edit ? translate('address_book_edit_form_txt') : translate('address_book_add_form_txt'),
          ),
          body: loading
              ? const Padding(
                  padding: EdgeInsets.fromLTRB(layoutPadding, itemPaddingMedium, layoutPadding, itemPaddingLarge),
                  child: LoadingFieldAddress(count: 10),
                )
              : addressFieldInit?.isNotEmpty == true
                  ? AddressChild(
                      address: widget.initAddress,
                      checkoutAddressStore: _checkoutAddressStore,
                      onSave: postAddress,
                      loading: _loading,
                      locale: _settingStore.locale,
                      keyForm: widget.keyForm,
                      isBooking: true,
                    )
                  : _buildaddressEmpty(isShipping: widget.keyForm == 'shipping'),
        );
      },
    );
  }

  Widget _buildaddressEmpty({bool isShipping = false}) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return NotificationScreen(
      title: Text(
        translate(isShipping ? 'address_shipping' : 'address_billing'),
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      content: Text(translate(isShipping ? 'address_empty_shipping' : 'address_empty_billing'),
          style: Theme.of(context).textTheme.bodyMedium),
      iconData: FeatherIcons.frown,
      isButton: false,
    );
  }
}
