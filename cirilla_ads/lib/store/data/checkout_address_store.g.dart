// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_address_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CheckoutAddressStore on CheckoutAddressStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
      name: 'CheckoutAddressStoreBase.loading'))
      .value;
  Computed<ObservableMap<String, AddressData>>? _$addressesComputed;

  @override
  ObservableMap<String, AddressData> get addresses => (_$addressesComputed ??=
      Computed<ObservableMap<String, AddressData>>(() => super.addresses,
          name: 'CheckoutAddressStoreBase.addresses'))
      .value;
  Computed<String>? _$countryDefaultComputed;

  @override
  String get countryDefault =>
      (_$countryDefaultComputed ??= Computed<String>(() => super.countryDefault,
          name: 'CheckoutAddressStoreBase.countryDefault'))
          .value;

  late final _$_addressesAtom =
  Atom(name: 'CheckoutAddressStoreBase._addresses', context: context);

  @override
  ObservableMap<String, AddressData> get _addresses {
    _$_addressesAtom.reportRead();
    return super._addresses;
  }

  @override
  set _addresses(ObservableMap<String, AddressData> value) {
    _$_addressesAtom.reportWrite(value, super._addresses, () {
      super._addresses = value;
    });
  }

  late final _$_countryDefaultAtom =
  Atom(name: 'CheckoutAddressStoreBase._countryDefault', context: context);

  @override
  String get _countryDefault {
    _$_countryDefaultAtom.reportRead();
    return super._countryDefault;
  }

  @override
  set _countryDefault(String value) {
    _$_countryDefaultAtom.reportWrite(value, super._countryDefault, () {
      super._countryDefault = value;
    });
  }

  late final _$_loadingAtom =
  Atom(name: 'CheckoutAddressStoreBase._loading', context: context);

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$getAddressesAsyncAction =
  AsyncAction('CheckoutAddressStoreBase.getAddresses', context: context);

  @override
  Future<void> getAddresses(List<String> countries, String lang) {
    return _$getAddressesAsyncAction
        .run(() => super.getAddresses(countries, lang));
  }

  @override
  String toString() {
    return '''
loading: ${loading},
addresses: ${addresses},
countryDefault: ${countryDefault}
    ''';
  }
}