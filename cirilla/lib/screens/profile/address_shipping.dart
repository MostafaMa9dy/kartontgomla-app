import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/address.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/notification/notification_screen.dart';
import 'package:cirilla/screens/profile/widgets/address_field_form3.dart';
import 'package:cirilla/screens/location/select_location.dart';
import 'package:cirilla/models/location/user_location.dart';
import 'package:cirilla/models/location/place.dart';

import 'widgets/fields/loading_field_address.dart';

const String keyShippingCustomerStore = "key_shipping_customer_store";

class AddressShippingScreen extends StatefulWidget {
  static const String routeName = '/profile/address_shipping';

  const AddressShippingScreen({Key? key}) : super(key: key);

  @override
  State<AddressShippingScreen> createState() => _AddressShippingScreenState();
}

class _AddressShippingScreenState extends State<AddressShippingScreen> with SnackMixin, AppBarMixin {
  late AppStore _appStore;
  late AuthStore _authStore;
  late SettingStore _settingStore;
  late CheckoutAddressStore _checkoutAddressStore;
  late CustomerStore _customerStore;
  bool _loadingSave = false;
  Map<String, dynamic> _formData = {};

  @override
  void initState() {
    _appStore = Provider.of<AppStore>(context, listen: false);
    _authStore = Provider.of<AuthStore>(context, listen: false);
    _settingStore = Provider.of<SettingStore>(context, listen: false);

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

    if (_appStore.getStoreByKey(keyShippingCustomerStore) == null) {
      CustomerStore store = CustomerStore(
        _settingStore.requestHelper,
        key: keyShippingCustomerStore,
      );
      _appStore.addStore(store);
      _customerStore = store;
      getAddresses(userId: _authStore.user!.id);
    } else {
      _customerStore = _appStore.getStoreByKey(keyShippingCustomerStore);
      _formData = getAddress(_customerStore.customer);
    }
    super.initState();
  }

  void getAddresses({required String userId}) {
    _customerStore.getCustomer(userId: userId).then((value) {
      setState(() {
        _formData = getAddress(_customerStore.customer);
      });
      String country = get(_formData, ['country'], '');
      _checkoutAddressStore.getAddresses([country], _settingStore.locale);
    });
  }

  Future<void> postAddress() async {
    try {
      setState(() {
        _loadingSave = true;
      });
      TranslateType translate = AppLocalizations.of(context)!.translate;

      List<Map<String, dynamic>> meta = [];

      // تجهيز بيانات الـ Meta Data لحقول wooccm المخصصة
      for (String key in _formData.keys) {
        if (key.contains('wooccm')) {
          meta.add({
            'key': 'shipping_$key',
            'value': _formData[key],
          });
        }
      }

      // 1. تحديث بيانات العميل في السيرفر (بروفايل وردبريس)
      await _customerStore.updateCustomer(
        userId: _authStore.user!.id,
        data: {
          'shipping': _formData,
          'meta_data': meta,
        },
      );

      // 2. تحديث بيانات الشحن في الـ CheckoutStore فوراً عشان لو المستخدم راح يشتري
      await _authStore.cartStore.checkoutStore.changeAddress(
        shipping: _formData,
      );

      if (mounted) {
        showSuccess(context, translate('address_shipping_success'));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) {
        setState(() {
          _loadingSave = false;
        });
      }
    }
  }

  Map<String, dynamic> getAddress(Customer? customer) {
    if (customer == null) {
      return {};
    }
    Map<String, dynamic> data = {...?customer.shipping};
    if (customer.metaData?.isNotEmpty == true) {
      for (var meta in customer.metaData!) {
        String keyElement = get(meta, ['key'], '');
        if (keyElement.contains('shipping_wooccm')) {
          dynamic valueElement = meta['value'];
          String nameData = keyElement.replaceFirst('shipping_', '');
          data[nameData] = valueElement;
        }
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate('address_shipping')),
      body: Observer(
        builder: (_) {
          bool loadingCustomer = _customerStore.loading;
          String country = _formData["country"] ?? "";
          AddressData? address = getAddressByKey(
              _checkoutAddressStore.addresses, country, _settingStore.locale, _checkoutAddressStore.countryDefault);

          bool loading = loadingCustomer || (_checkoutAddressStore.loading != false && address?.shipping?.isNotEmpty != true);

          if (loading) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(layoutPadding, itemPaddingMedium, layoutPadding, itemPaddingLarge),
              child: LoadingFieldAddress(count: 10),
            );
          }

          // الـ Map المخصصة للحقول الإضافية
          Map<String, dynamic> additionFieldsShipping = {
            "shipping_company": {
              "label": translate("checkout_input_company"),
              "class": ["form-row-wide"],
              "autocomplete": "organization",
              "priority": 30,
              if (address?.shipping?["shipping_company"] is Map)
                ...address?.shipping?["shipping_company"],
              "required": true,
              "disabled": false,
            },
            "shipping_address_2": {
              "type": "hidden", // مخفي في الفورم لأنه بيتعرض تحت الخريطة
            },
            "shipping_phone": {
              "label": translate("checkout_input_phone"),
              "type": "tel",
              "class": ["form-row-wide"],
              "validate": ["phone"],
              "autocomplete": "tel",
              "priority": 100,
              "required": true,
              "disabled": false,
            },
            "wooccm10": {
              "type": "hidden",
            }
          };

          final bool hasLocation = _formData['address_2'] != null && _formData['address_2'].toString().isNotEmpty;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(layoutPadding, itemPaddingMedium, layoutPadding, itemPaddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ١. الفورم الأساسي (الاسم، الشركة، التليفون) يظهر في الأول
                AddressFieldForm3(
                  keyForm: 'shipping',
                  data: _formData,
                  addressData: address ?? AddressData(),
                  additionFields: additionFieldsShipping,
                  onChanged: (Map<String, dynamic> value) {
                    setState(() {
                      _formData = value;
                    });
                  },
                  onGetAddressData: (String country) {
                    _checkoutAddressStore.getAddresses([country], _settingStore.locale);
                  },
                  formType: FieldFormType.shipping,
                  checkoutAddressStore: _checkoutAddressStore,
                ),

                const SizedBox(height: itemPaddingLarge),

                // ٢. اللوكيشن (عرض الرابط) يظهر بعد بيانات العنوان
                if (hasLocation) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(itemPadding),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text("رابط موقع التوصيل المسجل:", style: theme.textTheme.labelMedium?.copyWith(color: Colors.green)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formData['address_2'],
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: itemPadding),
                ],

                // ٣. زرار الخريطة لتحديث الموقع
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasLocation ? Colors.green : Colors.grey.shade600,
                    ),
                    icon: Icon(
                      hasLocation ? Icons.check_circle : FeatherIcons.mapPin,
                      color: Colors.white,
                    ),
                    label: Text(
                      hasLocation
                          ? "تحديث موقعك على الخريطة"
                          : "تسجيل الموقع على الخريطة",
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectLocationScreen(),
                        ),
                      );

                      if (result != null) {
                        Place? place = result['place'];
                        UserLocation? location = result['user_location'];

                        if (place != null && location != null) {
                          String mapsUrl = "https://www.google.com/maps?q=${location.lat},${location.lng}";

                          setState(() {
                            _formData['address_2'] = mapsUrl;
                            _formData['wooccm10'] = mapsUrl;
                          });
                          showSuccess(context, "تم تحديد موقعك بنجاح ✅");
                        }
                      }
                    },
                  ),
                ),

                const SizedBox(height: itemPaddingLarge),

                // ٤. زرار الحفظ في الآخر خالص
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loadingSave ? null : postAddress,
                    child: _loadingSave
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : Text(translate('address_save')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
