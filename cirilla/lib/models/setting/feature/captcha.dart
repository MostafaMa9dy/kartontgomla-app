import 'package:json_annotation/json_annotation.dart';
import 'package:cirilla/utils/data_format.dart' show toBool;

part 'captcha.g.dart';

@JsonSerializable()
class Captcha {
  @JsonKey(fromJson: toBool, defaultValue: true)
  final bool status;

  @JsonKey(name: 'Login', fromJson: toBool, defaultValue: true)
  final bool login;

  @JsonKey(name: 'Register', fromJson: toBool, defaultValue: true)
  final bool register;

  @JsonKey(name: 'CommentPost', fromJson: toBool, defaultValue: true)
  final bool commentPost;

  @JsonKey(name: 'ReviewProduct', fromJson: toBool, defaultValue: true)
  final bool reviewProduct;

  @JsonKey(name: 'ForgotPassword', fromJson: toBool, defaultValue: true)
  final bool forgotPassword;

  const Captcha({
    required this.status,
    required this.login,
    required this.register,
    required this.commentPost,
    required this.reviewProduct,
    required this.forgotPassword,
  });

  static const defaultData = Captcha(
    status: true,
    login: true,
    register: true,
    commentPost: true,
    reviewProduct: true,
    forgotPassword: true,
  );

  factory Captcha.fromJson(Map<String, dynamic> json) => _$CaptchaFromJson(json);

  Map<String, dynamic> toJson() => _$CaptchaToJson(this);
}
