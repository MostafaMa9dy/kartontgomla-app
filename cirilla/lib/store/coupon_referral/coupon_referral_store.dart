import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'coupon_referral_store.g.dart';

class CouponReferralStore = CouponReferralStoreBase with _$CouponReferralStore;

abstract class CouponReferralStoreBase with Store {
  late RequestHelper _requestHelper;
  final String? key;

  // Constructor: ------------------------------------------------------------------------------------------------------

  CouponReferralStoreBase(
    RequestHelper requestHelper, {
    this.key,
  }) {
    _requestHelper = requestHelper;
    _reaction();
  }

  // store variables:-----------------------------------------------------------

  @observable
  CouponReferralData _couponReferralData = CouponReferralData();

  @observable
  Map<String, dynamic> _enableRefSignup = {"enable_ref_signup": false};

  @observable
  bool _loadingReferral = false;

  @observable
  bool _loadingEnableRefCode = false;

  @computed
  CouponReferralData get couponReferralData => _couponReferralData;

  @computed
  Map<String, dynamic> get enableRefSignup => _enableRefSignup;

  @computed
  bool get loadingReferral => _loadingReferral;

  @computed
  bool get loadingEnableRefCode => _loadingEnableRefCode;

  @action
  Future<void> getCouponReferrals({int? userId}) async {
    Map<String, dynamic> query = {
      "app-builder-decode": true,
    };

    try {
      _loadingReferral = true;
      CouponReferralData couponReferral = await _requestHelper.getCouponReferrals(
        queryParameters: query,
        userId: userId,
      );

      _loadingReferral = false;
      _couponReferralData = couponReferral;
    } on DioException {
      _loadingReferral = false;
    }
  }

  Future<void> referralSignup({
    int? userId,
    required String referralKey,
    required String expirydate,
  }) async {
    Map<String, dynamic> query = {
      "app-builder-decode": true,
      "referral_key": referralKey,
      "expirydate": expirydate,
      "user_id": userId,
    };
    try {
      await _requestHelper.referralignup(queryParameters: query);
    } on DioException {
      rethrow;
    }
  }

  Future<void> enableReferralSignup() async {
    try {
      _loadingEnableRefCode = true;
      Map<String, dynamic> data = await _requestHelper.enableReferralSignup();
      _enableRefSignup = data;
      _loadingEnableRefCode = false;
    } on DioException {
      _loadingEnableRefCode = false;
      rethrow;
    }
  }

  @action
  Future<void> refresh() {
    return getCouponReferrals();
  }

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
