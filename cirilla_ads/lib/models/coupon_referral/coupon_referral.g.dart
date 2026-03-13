// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_referral.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponReferral _$CouponReferralFromJson(Map<String, dynamic> json) =>
    CouponReferral(
      status: json['status'] as String?,
      code: (json['code'] as num?)?.toInt(),
      data: CouponReferral._fromCouponReferralData(json['data'] as List?),
    );

Map<String, dynamic> _$CouponReferralToJson(CouponReferral instance) =>
    <String, dynamic>{
      'status': instance.status,
      'code': instance.code,
      'data': CouponReferral._toCouponReferralData(instance.data),
    };

CouponReferralData _$CouponReferralDataFromJson(Map<String, dynamic> json) =>
    CouponReferralData(
      id: json['id'] as String?,
      userName: json['user_name'] as String?,
      userNmail: json['user_email'] as String?,
      referredUsers: CouponReferralData._fromJsonString(json['referred_users']),
      utilize: CouponReferralData._fromJsonString(json['utilize']),
      noOfCoupons: CouponReferralData._fromJsonString(json['no_of_coupons']),
      couponData: CouponReferralData._toCouponDataReferral(json['coupon_data']),
      referralCode: json['referral_code'] as String?,
      referralDiscount:
          CouponReferralData._fromJsonString(json['referral_discount']),
      referralUpto:
          CouponReferralData._fromJsonString(json['referral_upto']),
      refreeSignup: CouponReferralData._fromJsonString(json['refree_signup']),
      signupDiscount:
          CouponReferralData._fromJsonString(json['signup_discount']),
    );

Map<String, dynamic> _$CouponReferralDataToJson(CouponReferralData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'user_email': instance.userNmail,
      'referred_users': instance.referredUsers,
      'utilize': instance.utilize,
      'no_of_coupons': instance.noOfCoupons,
      'coupon_data': instance.couponData,
      'referral_code': instance.referralCode,
      'referral_discount': instance.referralDiscount,
      'signup_discount': instance.signupDiscount,
      'refree_signup': instance.refreeSignup,
      'referral_upto': instance.referralUpto,
    };
