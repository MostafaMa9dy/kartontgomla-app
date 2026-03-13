// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_data_referral.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponDataReferral _$CouponDataReferralFromJson(Map<String, dynamic> json) =>
    CouponDataReferral(
      couponCode: json['coupon_code'] as String?,
      couponAmount: json['coupon_amount'] as String?,
      usageCount: ConvertData.stringToInt(json['usage_count']),
      event: json['event'] as String?,
      couponCreated: json['coupon_created'] as String?,
      referredUsers: json['referred_users'] as String?,
    );

Map<String, dynamic> _$CouponDataReferralToJson(CouponDataReferral instance) =>
    <String, dynamic>{
      'coupon_code': instance.couponCode,
      'coupon_amount': instance.couponAmount,
      'usage_count': instance.usageCount,
      'coupon_created': instance.couponCreated,
      'referred_users': instance.referredUsers,
      'event': instance.event,
    };
