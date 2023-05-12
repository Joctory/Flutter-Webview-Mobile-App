import 'dart:developer';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import './api.dart';
import './app_constant.dart';

class IwOneSignal {
  static const String oneSignalAppId = AppConstant.oneSignalAppId;

  static Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});

    var deviceState = await OneSignal.shared.getDeviceState();

    String pushToken = deviceState?.pushToken ?? "";
    String playerId = deviceState?.userId ?? "";
    bool isSubscribed = deviceState?.subscribed ?? false;
    log("pushToken is : {$pushToken}");
    log("playerId is : {$playerId}");
    log("isSubscribed is : {$isSubscribed}");

    await Api.sendDeviceInfo(
        oneSignalUserId: playerId,
        ip: "127.0.0.1",
        isSubscribed: isSubscribed,
        email: 'webview@email.com');
  }
}
