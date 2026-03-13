import 'package:flutter/material.dart';
import 'dart:async';

class AppsFlyer {
  AppsFlyer._();

  static final AppsFlyer _instance = AppsFlyer._();

  static AppsFlyer get instance => _instance;

  Future<dynamic> startSDK() async {}

  Future<String?> generateInviteLink(String permalink) async {
    return permalink;
  }

  void onDeepLinking(BuildContext context) async {
    return null;
  }
}
