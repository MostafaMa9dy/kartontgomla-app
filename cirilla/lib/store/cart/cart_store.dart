import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/persist_helper.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/store/cart/checkout_store.dart';
import 'package:cirilla/store/cart/coupon_smart_store.dart';
import 'package:cirilla/store/cart/payment_store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'cart_store.g.dart';

HtmlUnescape _unescape = HtmlUnescape();
class CartStore = CartStoreBase with _$CartStore;

abstract class CartStoreBase with Store {
  late PaymentStore paymentStore;
  late CheckoutStore checkoutStore;
  late CouponSmartStore couponSmartStore;

  final PersistHelper _persistHelper;
  final RequestHelper _requestHelper;
  final AuthStore _authStore;

  final CancelToken _token = CancelToken();

  @observable
  bool _loading = false;

  @observable
  bool _pending = false;

  @observable
  bool _loadingShipping = false;

  @observable
  bool _loadingAddCart = false;

  @observable
  bool _loadingCoupon = false;

  @observable
  String? _cartKey;

  @observable
  String? _cartNonce;

  @observable
  CartData? _cartData;

  @observable
  bool _canLoadMore = true;

  @observable
  bool _loadingRemoveCart = false;

  @observable
  BaseState _loadingRemovePoint = BaseState.initState;

  @observable
  ShippingSetting? _shippingSetting;

  @observable
  bool _loadingShippingZonesMethod = false;

  @computed
  bool get canLoadMore => _canLoadMore;

  @computed
  bool get loading => _loading;

  @computed
  bool get pending => _pending;

  @computed
  bool get loadingShipping => _loadingShipping;

  @computed
  bool get loadingAddCart => _loadingAddCart;

  @computed
  bool get loadingCoupon => _loadingCoupon;

  @computed
  CartData? get cartData => _cartData;

  @computed
  int? get count => _cartData != null ? _cartData!.itemsCount : 0;

  @computed
  String? get cartKey => _cartKey;

  @computed
  String? get cartNonce => _cartNonce;

  @computed
  bool get loadingRemoveCart => _loadingRemoveCart;

  @computed
  BaseState get loadingRemovePoint => _loadingRemovePoint;

  @computed
  ShippingSetting? get shippingSetting => _shippingSetting;

  @computed
  bool get loadingShippingZonesMethod => _loadingShippingZonesMethod;

  // Action: -----------------------------------------------------------------------------------------------------------
  @action
  Future<void> setCartKey(String? cartKey) async {
    if (cartKey != '' && cartKey != null) {
      _cartKey ??= cartKey;
      if (_cartKey != _persistHelper.getCartKey()) {
        await _persistHelper.saveCartKey(_cartKey!);
      }
    }
  }

  @action
  Future<void> mergeCart({bool? isLogin}) async {
    if (isLogin == true) {
      // Do not delete _cartKey so the backend can merge
      // Only delete nonce to force reload
      _cartNonce = null;

      // Call getCart with both Authorization header and cookies
      await getCart();
    } else {
      _cartKey = null;
      _cartNonce = null;
      _cartData = null;
      
      // Remove cart key from storage
      await _persistHelper.removeCartKey();
      
      // Delete cookies and get a new cart
      await getCart(true, {'clear-cookies': true});
    }
  }

  @action
  Future<void> getCart([loading = true, Map<String, dynamic> defaultParams = const {}]) async {
    if (_pending) return;
    _loading = loading;
    _pending = true;
    try {
      Map<String, dynamic> params = await _preParamsCart(defaultParams);

      dynamic res = await _requestHelper.getCart(
        params: params,
        cancelToken: _token,
      );
      _cartData = CartData.fromJson(res.data);
      _cartNonce = "${res.headers.value('Nonce')}";
      _cartKey = "${res.headers.value('Cart-Token')}";
      await getShippingZones();
      _loading = false;
      _pending = false;
    } on DioException {
      rethrow;
    } finally {
      _loading = false;
      _pending = false;
    }
  }

  @action
  Future<void> refresh() async {
    _canLoadMore = true;
    return getCart();
  }

  @action
  Future<void> updateQuantity({String? key, int? quantity, required int index}) async {
    // String? currency = await _persistHelper.getCurrency();
    try {
      if (key != null) {
        Map<String, dynamic> queryParameters = await _preParamsCart({
          'key': key,
          'quantity': quantity ?? 1,
          'cart_key': _cartKey,
        });

        Map<String, dynamic> header = await _preHeaderCart();

        Map<String, dynamic> json = await _requestHelper.updateQuantity(
          queryParameters: queryParameters,
          header: header,
        );
        _cartData = CartData.fromJson(json);
        await getShippingZones();
      }
    } on DioException {
      rethrow;
    }
  }

  @action
  Future<void> selectShipping({int? packageId, String? rateId}) async {
    try {
      String? currency = await _persistHelper.getCurrency();
      if (packageId != null && rateId != null) {
        _loadingShipping = true;
        Map<String, dynamic> header = await _preHeaderCart();
        Map<String, dynamic> json = await _requestHelper.selectShipping(
          cartKey: _cartKey,
          queryParameters: {
            'package_id': packageId,
            'rate_id': rateId,
            if (currency != null && currency != '') 'currency': currency,
          },
          header: header,
        );
        _cartData = CartData.fromJson(json);
        _loadingShipping = false;
      }
    } on DioException {
      _loadingShipping = false;
      rethrow;
    }
  }

  @action
  Future<void> updateCustomerCart({Map<String, dynamic>? data}) async {
    try {
      Map<String, dynamic> params = await _preParamsCart();
      Map<String, dynamic> header = await _preHeaderCart();
      Map<String, dynamic> json = await _requestHelper.updateCustomerCart(
        params: params,
        data: data,
        header: header,
      );
      _cartData = CartData.fromJson(json);
    } on DioException {
      rethrow;
    }
  }

  @action
  Future<void> applyCoupon({required String code}) async {
    _loadingCoupon = true;
    try {
      Map<String, dynamic> params = await _preParamsCart({
        'code': code,
      });
      Map<String, dynamic> header = await _preHeaderCart();
      Map<String, dynamic> json = await _requestHelper.applyCoupon(
        params: params,
        header: header,
      );
      _cartData = CartData.fromJson(json);
      _loadingCoupon = false;
    } on DioException {
      _loadingCoupon = false;
      rethrow;
    }
  }

  @action
  Future<void> removeCoupon({required String code}) async {
    _loading = true;
    try {
      Map<String, dynamic> params = await _preParamsCart({
        'code': code,
      });
      Map<String, dynamic> header = await _preHeaderCart();
      Map<String, dynamic> json = await _requestHelper.removeCoupon(
        params: params,
        header: header,
      );
      _cartData = CartData.fromJson(json);
      if (code.contains('wc_points_redemption')) {
        _loadingRemovePoint = BaseState.loadedState;
      }
      await getCart();
      _loading = false;
    } on DioException {
      _loading = false;
      rethrow;
    }
  }

  @action
  Future<void> removeCart({String? key}) async {
    try {
      if (key != null) {
        _loadingRemoveCart = true;
        Map<String, dynamic> params = await _preParamsCart({
          'cart_key': _cartKey,
        });
        Map<String, dynamic> header = await _preHeaderCart();

        Map<String, dynamic> json = await _requestHelper.removeCart(
          params: params,
          data: {
            'key': key,
          },
          header: header,
        );
        _cartData = CartData.fromJson(json);
        _loadingRemoveCart = false;
        await getShippingZones();
      }
    } on DioException {
      _loadingRemoveCart = false;
      rethrow;
    }
  }

  @action
  Future<Map<String, dynamic>> addToCart(Map<String, dynamic> data) async {
    try {
      _loadingAddCart = true;
      // String? currency = await _persistHelper.getCurrency();

      Map<String, dynamic> cartData = Map<String, dynamic>.of(data);

      Map<String, dynamic> params = await _preParamsCart();
      Map<String, dynamic>? header = await _preHeaderCart();

      Map<String, dynamic> json = await _requestHelper.addToCart(
        params: params,
        data: cartData,
        header: header,
      );
      _cartData = CartData.fromJson(json);

      _loadingAddCart = false;
      await getShippingZones();
      return json;
    } on DioException {
      _loadingAddCart = false;
      rethrow;
    }
  }

  @action
  void changeRemovePointState(BaseState value) {
    _loadingRemovePoint = value;
  }

  /// Apply point discount
  @action
  Future<void> applyPointDiscount({
    required String value,
    required String cartKey,
  }) async {
    _loading = true;
    try {
      Map<String, dynamic> header = await _preHeaderCart();
      Map<String, dynamic> json = await _requestHelper.applyPointDiscount(
        cartKey: cartKey,
        header: header,
        data: {
          "namespace": "points-and-rewards",
          "data": {"discount_amount": value}
        },
      );
      _cartData = CartData.fromJson(json);
      _loading = false;
    } on DioException {
      _loading = false;
      rethrow;
    }
  }

  @action
  Future<List<ShippingZones>> getShippingZones() async {
    try {
      List<ShippingZones> data = await _requestHelper.getShippingZones();
      if (data.isNotEmpty) {
        if (data.length == 1) {
          await getShippingZonesMethods(idZone: data[0].id ?? 0);
        } else if (data.length > 1) {
          await getShippingZonesMethods(idZone: data[1].id ?? 0);
        }
      }
      return data;
    } on DioException {
      rethrow;
    }
  }

  @action
  Future<List<ShippingZonesMethod>> getShippingZonesMethods({required int idZone}) async {
    _loadingShippingZonesMethod = true;
    try {
      List<ShippingZonesMethod> data = await _requestHelper.getShippingZonesMethods(idZone: idZone);
      _loadingShippingZonesMethod = false;
      if (data.isNotEmpty) {
        for (var element in data) {
          if (element.methodId == 'free_shipping') {
            _shippingSetting = element.settings?["min_amount"];
          }
        }
      }
      return data;
    } on DioException {
      _loadingShippingZonesMethod = false;
      rethrow;
    }
  }

  // Constructor: ------------------------------------------------------------------------------------------------------
  CartStoreBase(this._persistHelper, this._requestHelper, this._authStore) {
    _init();
    _reaction();
    paymentStore = PaymentStore(_requestHelper);
    checkoutStore = CheckoutStore(_persistHelper, _requestHelper, this as CartStore);
    couponSmartStore = CouponSmartStore(_requestHelper);
  }

  Future _init() async {
    await _restore();
    try {
      await getCart();
    } catch (e) {
      avoidPrint('GetCart - cancel.');
    }
  }

  Future<void> _restore() async {}

  // disposers:---------------------------------------------------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _reaction() {
    _disposers = [
      reaction((_) => _authStore.isLogin, (dynamic isLogin) => mergeCart(isLogin: isLogin)),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
    _token.cancel('Cancel get cart.');
  }

  /// Pre cart header
  Future<Map<String, dynamic>> _preHeaderCart([Map<String, dynamic> defaultParams = const {}]) async {
    if (_cartNonce == null) {
      await getCart();
    }
    Map<String, dynamic> header = {
      'Nonce': _cartNonce,
      ...defaultParams,
    };
    return header;
  }

  /// Pre cart params
  Future<Map<String, dynamic>> _preParamsCart([Map<String, dynamic> defaultParams = const {}]) async {
    String? currency = await _persistHelper.getCurrency();
    String lang = _persistHelper.getLanguage();
    String? savedCartKey = _persistHelper.getCartKey();
    Map<String, dynamic> params = {
      'set-cookies': 'true',
      "time": DateTime.now().millisecondsSinceEpoch,
      if (_authStore.isLogin) 'app-builder-decode': 'true',
      if (currency != null && currency != '') 'currency': currency,
      if (lang != '') 'lang': lang,
      // Send cart_key so the backend knows and can merge
      if (savedCartKey != null && savedCartKey.isNotEmpty) 'cart_key': savedCartKey,
      ...defaultParams,
    };
    return preQueryParameters(params);
  }

  /// Convert cart data to String Type to use for Additional Button
  String _total(String? value, String? value2) {
    double total = ConvertData.stringToDouble(value, 0) + ConvertData.stringToDouble(value2, 0);
    return total.toString();
  }

  Map<String, dynamic>? get totals => _cartData?.totals;

  String? get totalItemsTax => get(totals, ['total_items_tax'], '');

  String? get subTotal => get(totals, ['total_items'], '');

  int? get unit => get(totals, ['currency_minor_unit'], 0);

  String? get currencyCode => get(totals, ['currency_code'], null);

  String? get currencySymbol => get(totals, ['currency_symbol'], null);

  String? get totalPrice => convertCurrencyFromData(
        unit: unit,
        currencySymbol: currencySymbol,
        price: get(totals, ['total_price'], ''),
      );

  String? get subTotalPrice => convertCurrencyFromData(
        unit: unit,
        currencySymbol: currencySymbol,
        price: _total(subTotal, totalItemsTax),
      );

  String? get itemData => _cartData?.items
      ?.map((e) {
        String name = "${_unescape.convert('${e.name}')}\n";
        String attr = e.itemData!
            .map((e) {
              String name = get(e, ['name'], '');
              String value = get(e, ['value'], '');
              String nameValue = "${_unescape.convert(name)}: $value\n";
              return nameValue;
            })
            .toList()
            .join();
        String line = "=============\n";
        String itemCart = "$name$attr$line";
        return itemCart;
      })
      .toList()
      .join();

  String? get itemFee => _cartData?.fees
      ?.map((e) {
        String total = convertCurrencyFromData(
          unit: unit,
          currencySymbol: currencySymbol,
          price: get(e.totals, ['total'], ''),
        );
        String totalFees = "${_unescape.convert('${e.name}')}: $total\n";
        return totalFees;
      })
      .toList()
      .join();

  String? get coupons => _cartData?.coupons
      ?.map((e) {
        String name = _unescape.convert('${e['code']}');
        String total = convertCurrencyFromData(
          unit: unit,
          currencySymbol: currencySymbol,
          price: get(e, ['totals', 'total_discount'], ''),
        );
        String coupon = "Coupon: $name -$total\n";
        return coupon;
      })
      .toList()
      .join();

  Map<String, String> get dataToString => {
        "item_data": itemData ?? '',
        "item_fee": itemFee ?? '',
        "coupons": coupons ?? '',
      };
}
