import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dart_ipify/dart_ipify.dart';

class DeviceService {
  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();

    if(Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
    
    return null;
  }

  Future<String> getPublicIP() async {
    return Ipify.ipv4(format: Format.TEXT);
  }
}