// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_referral_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CouponReferralStore on CouponReferralStoreBase, Store {
  Computed<CouponReferralData>? _$couponReferralDataComputed;

  @override
  CouponReferralData get couponReferralData => (_$couponReferralDataComputed ??=
          Computed<CouponReferralData>(() => super.couponReferralData,
              name: 'CouponReferralStoreBase.couponReferralData'))
      .value;
  Computed<Map<String, dynamic>>? _$enableRefSignupComputed;

  @override
  Map<String, dynamic> get enableRefSignup => (_$enableRefSignupComputed ??=
          Computed<Map<String, dynamic>>(() => super.enableRefSignup,
              name: 'CouponReferralStoreBase.enableRefSignup'))
      .value;
  Computed<bool>? _$loadingReferralComputed;

  @override
  bool get loadingReferral =>
      (_$loadingReferralComputed ??= Computed<bool>(() => super.loadingReferral,
              name: 'CouponReferralStoreBase.loadingReferral'))
          .value;
  Computed<bool>? _$loadingEnableRefCodeComputed;

  @override
  bool get loadingEnableRefCode => (_$loadingEnableRefCodeComputed ??=
          Computed<bool>(() => super.loadingEnableRefCode,
              name: 'CouponReferralStoreBase.loadingEnableRefCode'))
      .value;

  late final _$_couponReferralDataAtom = Atom(
      name: 'CouponReferralStoreBase._couponReferralData', context: context);

  @override
  CouponReferralData get _couponReferralData {
    _$_couponReferralDataAtom.reportRead();
    return super._couponReferralData;
  }

  @override
  set _couponReferralData(CouponReferralData value) {
    _$_couponReferralDataAtom.reportWrite(value, super._couponReferralData, () {
      super._couponReferralData = value;
    });
  }

  late final _$_enableRefSignupAtom =
      Atom(name: 'CouponReferralStoreBase._enableRefSignup', context: context);

  @override
  Map<String, dynamic> get _enableRefSignup {
    _$_enableRefSignupAtom.reportRead();
    return super._enableRefSignup;
  }

  @override
  set _enableRefSignup(Map<String, dynamic> value) {
    _$_enableRefSignupAtom.reportWrite(value, super._enableRefSignup, () {
      super._enableRefSignup = value;
    });
  }

  late final _$_loadingReferralAtom =
      Atom(name: 'CouponReferralStoreBase._loadingReferral', context: context);

  @override
  bool get _loadingReferral {
    _$_loadingReferralAtom.reportRead();
    return super._loadingReferral;
  }

  @override
  set _loadingReferral(bool value) {
    _$_loadingReferralAtom.reportWrite(value, super._loadingReferral, () {
      super._loadingReferral = value;
    });
  }

  late final _$_loadingEnableRefCodeAtom = Atom(
      name: 'CouponReferralStoreBase._loadingEnableRefCode', context: context);

  @override
  bool get _loadingEnableRefCode {
    _$_loadingEnableRefCodeAtom.reportRead();
    return super._loadingEnableRefCode;
  }

  @override
  set _loadingEnableRefCode(bool value) {
    _$_loadingEnableRefCodeAtom.reportWrite(value, super._loadingEnableRefCode,
        () {
      super._loadingEnableRefCode = value;
    });
  }

  late final _$getCouponReferralsAsyncAction = AsyncAction(
      'CouponReferralStoreBase.getCouponReferrals',
      context: context);

  @override
  Future<void> getCouponReferrals({int? userId}) {
    return _$getCouponReferralsAsyncAction
        .run(() => super.getCouponReferrals(userId: userId));
  }

  late final _$CouponReferralStoreBaseActionController =
      ActionController(name: 'CouponReferralStoreBase', context: context);

  @override
  Future<void> refresh() {
    final _$actionInfo = _$CouponReferralStoreBaseActionController.startAction(
        name: 'CouponReferralStoreBase.refresh');
    try {
      return super.refresh();
    } finally {
      _$CouponReferralStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
couponReferralData: ${couponReferralData},
enableRefSignup: ${enableRefSignup},
loadingReferral: ${loadingReferral},
loadingEnableRefCode: ${loadingEnableRefCode}
    ''';
  }
}
