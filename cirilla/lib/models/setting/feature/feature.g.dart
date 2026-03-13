// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Features _$FeaturesFromJson(Map<String, dynamic> json) => Features(
      jwtAuthentication: Features._fromMap(json['jwt_authentication']),
      loginFacebook: Features._fromMap(json['login_facebook']),
      loginFirebasePhoneNumber:
          Features._fromMap(json['login_firebase_phone_number']),
      customIcon: Features._fromMap(json['custom_icon']),
      shoppingVideo: Features._fromMap(json['shopping_video']),
      forgotPassword: Features._fromForgotPassword(json['forgot_password']),
      upgrader: Features._fromUpgrader(json['upgrader']),
      captcha: Features._fromCaptcha(json['captcha']),
    );

Map<String, dynamic> _$FeaturesToJson(Features instance) => <String, dynamic>{
      'jwt_authentication': instance.jwtAuthentication,
      'login_facebook': instance.loginFacebook,
      'login_firebase_phone_number': instance.loginFirebasePhoneNumber,
      'custom_icon': instance.customIcon,
      'shopping_video': instance.shoppingVideo,
      'forgot_password': instance.forgotPassword,
      'upgrader': instance.upgrader,
      'captcha': instance.captcha,
    };
