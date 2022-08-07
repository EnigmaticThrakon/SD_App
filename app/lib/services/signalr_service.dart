import 'dart:developer';
import 'dart:io';
import 'package:signalr_client/ihub_protocol.dart';
import 'package:signalr_client/signalr_client.dart';

class SignalRService {
  static String baseUrl = 'http://marvin.webredirect.org:52042/appMonitorHub';

  Future<void> connect() async {
    try {
      final hubConnection = HubConnectionBuilder().withUrl(baseUrl).build();
      hubConnection.start();
    } catch (e) {
      log(e.toString());
    }
  }
}