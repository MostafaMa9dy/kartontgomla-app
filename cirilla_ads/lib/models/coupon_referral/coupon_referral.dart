import 'package:cirilla/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coupon_referral.g.dart';

@JsonSerializable()
class CouponReferral {
  String? status;
  int? code;

  @JsonKey(fromJson: _fromCouponReferralData, toJson: _toCouponReferralData)
  List<CouponReferralData>? data;

  CouponReferral({
    this.status,
    this.code,
    this.data,
  });

  factory CouponReferral.fromJson(Map<String, dynamic> json) => _$CouponReferralFromJson(json);
  Map<String, dynamic> toJson() => _$CouponReferralToJson(this);

  static List<CouponReferralData>? _fromCouponReferralData(List<dynamic>? data) {
    List<CouponReferralData> newCouponReferral = <CouponReferralData>[];

    if (data == null) return newCouponReferral;

    newCouponReferral = data.map((d) => CouponReferralData.fromJson(d)).toList().cast<CouponReferralData>();

    return newCouponReferral;
  }

  static dynamic _toCouponReferralData(List<CouponReferralData>? data) {
    List newCouponReferral = [];

    if (data == null || data.isNotEmpty != true) return newCouponReferral;

    newCouponReferral = data.map((d) => d.toJson()).toList();

    return newCouponReferral;
  }
}

@JsonSerializable()
class CouponReferralData {
  String? id;

  @JsonKey(name: 'user_name')
  String? userName;

  @JsonKey(name: 'user_email')
  String? userNmail;

  @JsonKey(name: 'referred_users', fromJson: _fromJsonString)
  String? referredUsers;

  @JsonKey(fromJson: _fromJsonString)
  String? utilize;

  @JsonKey(name: 'no_of_coupons', fromJson: _fromJsonString)
  String? noOfCoupons;

  @JsonKey(name: 'coupon_data', fromJson: _toCouponDataReferral)
  List<CouponDataReferral>? couponData;

  @JsonKey(name: 'referral_code')
  String? referralCode;

  @JsonKey(name: 'referral_discount', fromJson: _fromJsonString)
  String? referralDiscount;

  @JsonKey(name: 'referral_upto', fromJson: _fromJsonString)
  String? referralUpto;

  @JsonKey(name: 'signup_discount', fromJson: _fromJsonString)
  String? signupDiscount;

  @JsonKey(name: 'refree_signup', fromJson: _fromJsonString)
  String? refreeSignup;

  CouponReferralData({
    this.id,
    this.userName,
    this.userNmail,
    this.referredUsers,
    this.utilize,
    this.noOfCoupons,
    this.couponData,
    this.referralCode,
    this.referralDiscount,
    this.refreeSignup,
    this.signupDiscount,
    this.referralUpto,
  });

  factory CouponReferralData.fromJson(Map<String, dynamic> json) => _$CouponReferralDataFromJson(json);
  Map<String, dynamic> toJson() => _$CouponReferralDataToJson(this);

  static String _fromJsonString(dynamic data) {
    if (data is int) {
      return '$data';
    } else if (data is String) {
      return data;
    }
    return '';
  }

  static List<CouponDataReferral> _toCouponDataReferral(dynamic value) {
    List<CouponDataReferral> data = [];
    data = value.map((value) => CouponDataReferral.fromJson(value)).toList().cast<CouponDataReferral>();
    return data;
  }
}
