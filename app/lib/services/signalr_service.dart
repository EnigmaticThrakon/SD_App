import 'dart:developer';
import 'package:signalr_client/signalr_client.dart';

class SignalRService {
  static String baseUrl = 'http://paranoidandroid.network:52042/appMonitorHub';
  late HubConnection hubConnection;

  Future<void> connect() async {
    try {
      hubConnection = HubConnectionBuilder().withUrl(baseUrl).build();
      hubConnection.start();
    } catch (e) {
      log(e.toString());
    }
  }
}