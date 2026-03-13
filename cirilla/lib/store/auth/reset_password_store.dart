import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'reset_password_store.g.dart';

class ResetPasswordStore = ResetPasswordStoreBase with _$ResetPasswordStore;

abstract class ResetPasswordStoreBase with Store {
  // Request helper instance
  late RequestHelper _requestHelper;

  // constructor:-------------------------------------------------------------------------------------------------------
  ResetPasswordStoreBase(RequestHelper requestHelper) {
    _requestHelper = requestHelper;
  }

  // store variables:-----------------------------------------------------------
  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;
  
  @observable
  String _loadingVerify = '';

  @computed
  String get loadingVerify => _loadingVerify;

  @observable
  bool _loadingUpdate = false;

  @computed
  bool get loadingUpdate => _loadingUpdate;

  @action
  Future<Map<String, dynamic>> resetPassword(String? userLogin) async {
    _loading = true;
    _loadingVerify = '';
    try {
      Map<String, dynamic> data = await _requestHelper.resetPassword(userLogin: userLogin);
      _loading = false;
      return data;
    } on DioException {
      _loading = false;
      rethrow;
    }
  }

  @action
  Future<Map<String, dynamic>> verifyOtpResetPassword({
    required String userLogin,
    required int otp,
    required Map<String,dynamic> captcha,
  }) async {
    _loadingVerify = 'loading';
    try {
      Map<String, dynamic> data = await _requestHelper.verifyOtpResetPassword(
        userLogin: userLogin,
        otp: otp,
        captcha: captcha
      );
      _loadingVerify = 'loaded';
      return data;
    } on DioException {
      _loadingVerify = 'failed';
      rethrow;
    }
  }

  @action
  Future<Map<String, dynamic>> updatePassword({required String token, required String newPassWord}) async {
    _loadingUpdate = true;
    try {
      Map<String, dynamic> data = await _requestHelper.updatePassword(token: token, newPassWord: newPassWord);
      _loadingUpdate = false;
      return data;
    } on DioException {
      _loadingUpdate = false;
      rethrow;
    }
  }
}
