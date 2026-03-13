import 'package:json_annotation/json_annotation.dart';
import 'package:cirilla/utils/data_format.dart' show toBool, toInt;

part 'forgot_password.g.dart';

@JsonSerializable()
class ForgotPassword {
  @JsonKey(fromJson: toBool, defaultValue: true)
  final bool status;

  @JsonKey(name: 'otp_expiration_time', fromJson: toInt, defaultValue: 1)
  final int otpExpirationTime;

  @JsonKey(name: 'otp_attempt_limit', fromJson: toInt, defaultValue: 3)
  final int otpAttemptLimit;

  @JsonKey(name: 'otp_verification_block_duration', fromJson: toInt, defaultValue: 15)
  final int otpVerificationBlockDuration;

  const ForgotPassword({
    required this.status,
    required this.otpExpirationTime,
    required this.otpAttemptLimit,
    required this.otpVerificationBlockDuration,
  });

  static const defaultData = ForgotPassword(
    status: true,
    otpExpirationTime: 1,
    otpAttemptLimit: 3,
    otpVerificationBlockDuration: 15,
  );

  factory ForgotPassword.fromJson(Map<String, dynamic> json) => _$ForgotPasswordFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordToJson(this);
}
