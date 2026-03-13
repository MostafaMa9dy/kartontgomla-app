import 'package:json_annotation/json_annotation.dart';
import 'captcha.dart';
import 'forgot_password.dart';
import 'upgrader.dart';

part 'feature.g.dart';

@JsonSerializable()
class Features {
  @JsonKey(name: 'jwt_authentication', fromJson: _fromMap)
  final Map<String, dynamic> jwtAuthentication;

  @JsonKey(name: 'login_facebook', fromJson: _fromMap)
  final Map<String, dynamic> loginFacebook;

  @JsonKey(name: 'login_firebase_phone_number', fromJson: _fromMap)
  final Map<String, dynamic> loginFirebasePhoneNumber;

  @JsonKey(name: 'custom_icon', fromJson: _fromMap)
  final Map<String, dynamic> customIcon;

  @JsonKey(name: 'shopping_video', fromJson: _fromMap)
  final Map<String, dynamic> shoppingVideo;

  @JsonKey(name: 'forgot_password', fromJson: _fromForgotPassword)
  final ForgotPassword forgotPassword;

  @JsonKey(name: 'upgrader', fromJson: _fromUpgrader)
  final Upgrader upgrader;

  @JsonKey(name: 'captcha', fromJson: _fromCaptcha)
  final Captcha captcha;

  const Features({
    required this.jwtAuthentication,
    required this.loginFacebook,
    required this.loginFirebasePhoneNumber,
    required this.customIcon,
    required this.shoppingVideo,
    required this.forgotPassword,
    required this.upgrader,
    required this.captcha,
  });

  static const defaultData = Features(
    jwtAuthentication: {},
    loginFacebook: {},
    loginFirebasePhoneNumber: {},
    customIcon: {},
    shoppingVideo: {},
    forgotPassword: ForgotPassword.defaultData,
    upgrader: Upgrader.defaultData,
    captcha: Captcha.defaultData,
  );

  factory Features.fromJson(Map<String, dynamic> json) => _$FeaturesFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturesToJson(this);

  static Map<String, dynamic> _fromMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return {};
  }

  static ForgotPassword _fromForgotPassword(dynamic value) {
    if (value is Map<String, dynamic>) {
      return ForgotPassword.fromJson(value);
    }
    return ForgotPassword.defaultData;
  }

  static Upgrader _fromUpgrader(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Upgrader.fromJson(value);
    }
    return Upgrader.defaultData;
  }

  static Captcha _fromCaptcha(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Captcha.fromJson(value);
    }
    return Captcha.defaultData;
  }
}
