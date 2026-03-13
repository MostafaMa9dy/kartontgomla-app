import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service/service.dart';
import 'register_service/appsflyer/appsflyer.dart';

/// App starts
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializePushNotificationService();
  await AppsFlyerDynamicLink().startSDK();
  SharedPreferences sharedPref = await getSharedPref();

  await AppServiceInject.create(
    PreferenceModule(sharedPref: sharedPref),
    NetworkModule(),
  );

  runApp(AppServiceInject.instance.getApp);
}
