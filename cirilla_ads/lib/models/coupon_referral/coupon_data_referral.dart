import 'package:cirilla/utils/convert_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coupon_data_referral.g.dart';

@JsonSerializable()
class CouponDataReferral {
  @JsonKey(name: "coupon_code")
  final String? couponCode;

  @JsonKey(name: "coupon_amount")
  final String? couponAmount;

  @JsonKey(name: "usage_count",fromJson: ConvertData.stringToInt)
  final int? usageCount;

  @JsonKey(name: "coupon_created")
  final String? couponCreated;

  @JsonKey(name: "referred_users")
  final String? referredUsers;

  final String? event;

  CouponDataReferral({
    this.couponCode,
    this.couponAmount,
    this.usageCount,
    this.event,
    this.couponCreated,
    this.referredUsers,
  });

  factory CouponDataReferral.fromJson(Map<String, dynamic> json) => _$CouponDataReferralFromJson(json);
  Map<String, dynamic> toJson() => _$CouponDataReferralToJson(this);
}
