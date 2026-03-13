// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captcha.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Captcha _$CaptchaFromJson(Map<String, dynamic> json) => Captcha(
      status: json['status'] == null ? true : toBool(json['status']),
      login: json['Login'] == null ? true : toBool(json['Login']),
      register: json['Register'] == null ? true : toBool(json['Register']),
      commentPost:
          json['CommentPost'] == null ? true : toBool(json['CommentPost']),
      reviewProduct:
          json['ReviewProduct'] == null ? true : toBool(json['ReviewProduct']),
      forgotPassword: json['ForgotPassword'] == null
          ? true
          : toBool(json['ForgotPassword']),
    );

Map<String, dynamic> _$CaptchaToJson(Captcha instance) => <String, dynamic>{
      'status': instance.status,
      'Login': instance.login,
      'Register': instance.register,
      'CommentPost': instance.commentPost,
      'ReviewProduct': instance.reviewProduct,
      'ForgotPassword': instance.forgotPassword,
    };
