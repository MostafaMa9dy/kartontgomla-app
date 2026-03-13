import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

mixin FacebookLoginMixin<T extends StatefulWidget> on State<T> {
  Future loginFacebook(Function? login) async {
    try {
      final nonce = StringGenerate.uuid();

      // by default the login method has the next permissions ['email','public_profile']
      final LoginResult result = await FacebookAuth.instance.login(nonce: nonce);

      bool loginSuccess = result.status == LoginStatus.success;

      AccessToken? accessToken = result.accessToken;

      String token = accessToken?.tokenString ?? '';

      if (loginSuccess && accessToken is LimitedToken) {
        login!({
          'type': Strings.loginFacebook,
          'token': token,
          'facebook_user_id': accessToken.userId,
          'access_token_type': 'LimitedToken',
          'nonce': accessToken.nonce,
        });
      } else if (loginSuccess && accessToken is ClassicToken) {
        login!({
          'type': Strings.loginFacebook,
          'token': token,
          'facebook_user_id': accessToken.userId,
        });
      } else {
        avoidPrint(result.status);
        avoidPrint(result.message);
      }
    } catch (e) {
      avoidPrint(e);
    }
  }
}
