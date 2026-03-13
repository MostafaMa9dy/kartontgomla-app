// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPassword _$ForgotPasswordFromJson(Map<String, dynamic> json) =>
    ForgotPassword(
      status: json['status'] == null ? true : toBool(json['status']),
      otpExpirationTime: json['otp_expiration_time'] == null
          ? 1
          : toInt(json['otp_expiration_time']),
      otpAttemptLimit: json['otp_attempt_limit'] == null
          ? 3
          : toInt(json['otp_attempt_limit']),
      otpVerificationBlockDuration:
          json['otp_verification_block_duration'] == null
              ? 15
              : toInt(json['otp_verification_block_duration']),
    );

Map<String, dynamic> _$ForgotPasswordToJson(ForgotPassword instance) =>
    <String, dynamic>{
      'status': instance.status,
      'otp_expiration_time': instance.otpExpirationTime,
      'otp_attempt_limit': instance.otpAttemptLimit,
      'otp_verification_block_duration': instance.otpVerificationBlockDuration,
    };
