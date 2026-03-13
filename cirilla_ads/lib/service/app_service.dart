import 'package:cirilla/app.dart';
import 'package:dio/dio.dart';

import 'helpers/persist_helper.dart';
import 'helpers/request_helper.dart';
import 'modules/network_module.dart';
import 'modules/preference_module.dart';

import 'cookie_service.dart';

abstract class AppService implements PersisLocator, NetworkLocator {
  static Future<AppService> create(
    PreferenceModule preferenceModule,
    NetworkModule networkModule,
  ) async {
    AppService service = await AppServiceInject.create(
      preferenceModule,
      networkModule,
    );
    return service;
  }

  CookieService get providerCookieService;

  MyApp get getApp;
}

class AppServiceInject implements AppService {
  final PreferenceModule _preferenceModule;
  final NetworkModule _networkModule;

  Dio? _singletonDio;
  DioClient? _singletonDioClient;
  PersistHelper? _singletonPersistHelper;
  RequestHelper? _singletonRequestHelper;
  CookieService? _singletonCookieService;

  static AppServiceInject? _instance;

  AppServiceInject._internal(this._preferenceModule, this._networkModule);

  static Future<AppServiceInject> create(
    PreferenceModule preferenceModule,
    NetworkModule networkModule,
  ) async {
    return _instance ??= AppServiceInject._internal(preferenceModule, networkModule);
  }

  static AppServiceInject get instance {
    if (_instance == null) {
      throw Exception("AppServiceInject is not initialized. Call create() first.");
    }
    return _instance!;
  }

  MyApp _createApp() => MyApp(requestHelper: _createRequest(), persistHelper: _createPersistHelper());

  PersistHelper _createPersistHelper() => _singletonPersistHelper ??= _preferenceModule.providerPersistHelper();

  Dio _createDio() => _singletonDio ??= _networkModule.provideDio(_createPersistHelper(), _createCookieService());

  DioClient _createDioClient() => _singletonDioClient ??= _networkModule.provideDioClient(_createDio());

  RequestHelper _createRequest() => _singletonRequestHelper ??= _networkModule.provideRequestHelper(_createDioClient());

  CookieService _createCookieService() => _singletonCookieService ??= CookieService(_createPersistHelper());

  @override
  CookieService get providerCookieService => _createCookieService();

  @override
  PersistHelper get providerPersistHelper => _createPersistHelper();

  @override
  RequestHelper get providerRequestHelper => _createRequest();

  @override
  MyApp get getApp => _createApp();
}
