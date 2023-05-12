import 'dart:developer';

import 'package:dio/dio.dart';
import './app_constant.dart';
import './iw_device_info.dart';

class Api {
  static final dio = Dio();
  static const sendDeviceInfoUrl =
      '${AppConstant.webviewUrl}/index.php?option=com_ajax&plugin=onesignalapi&method=create&format=raw';

  static sendDeviceInfo({
    required String oneSignalUserId,
    required bool isSubscribed,
    required String ip,
    String email = "",
  }) async {
    var info = IwDeviceInfo();
    String deviceData = await info.getInfo();

    var data = {
      "merchant_key": AppConstant.merchantKey,
      "hash": AppConstant.hash,
      "osdata": [
        {
          "one_signal_id": oneSignalUserId,
          "devices": deviceData,
          // "ip": ip,
          "status": isSubscribed ? "Subscribe" : "Unsubscribe",
          // "user_id": email,
        }
      ]
    };

    try {
      var res = await dio.post(sendDeviceInfoUrl, data: data);
      log(res.data);
    } on DioError catch (err) {
      log(err.message ?? "error on dio");
    }
  }
}
