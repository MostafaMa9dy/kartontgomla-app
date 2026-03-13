import 'package:cirilla/models/address/address.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/utils/address.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:mobx/mobx.dart';

part 'checkout_address_store.g.dart';

const String keyCheckoutAddressStore = "checkout-address-store";

class CheckoutAddressStore = CheckoutAddressStoreBase with _$CheckoutAddressStore;

abstract class CheckoutAddressStoreBase with Store {
  final String? key;
  final RequestHelper _requestHelper;

  CheckoutAddressStoreBase(this._requestHelper, {this.key}) {
    _reaction();
  }

  @observable
  ObservableMap<String, AddressData> _addresses = ObservableMap<String, AddressData>.of({});

  @observable
  String _countryDefault = "";

  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  @computed
  ObservableMap<String, AddressData> get addresses => _addresses;

  @computed
  String get countryDefault => _countryDefault;

  @action
  Future<void> getAddresses(List<String> countries, String lang) async {

    _loading = true;
    String countryDefault = _countryDefault;

    ObservableMap<String, AddressData> addresses = ObservableMap<String, AddressData>.of({});

    for(String country in countries) {
      String key = getKeyAddress(country, lang, countryDefault);
      if (!_addresses.containsKey(key) && !addresses.containsKey(key)) {
        try {
          AddressData data = await _requestHelper.getAddress(
            queryParameters: preQueryParameters({
              "country": country,
              "lang": lang,
            }),
          );
          addresses.addAll(ObservableMap<String, AddressData>.of({ key: data }));
          if (key.startsWith("default_") && data.country != null && data.country != '') {
            countryDefault = data.country!;
          }
        } catch(_) {
          continue;
        }
      }
    }
    if (addresses.isNotEmpty) {
      _addresses.addAll(addresses);
    }
    if (countryDefault != _countryDefault) {
      _countryDefault = countryDefault;
    }
    _loading = false;
  }

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;
  void _reaction() {
    _disposers = [];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}