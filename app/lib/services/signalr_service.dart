import 'dart:convert';
import 'dart:developer';
import 'package:signalr_client/signalr_client.dart';
import 'package:mobx/mobx.dart';

import '../models/unit.dart';

class SignalRService {
  final String _baseUrl = 'http://paranoidandroid.network:52042/appMonitorHub';
  late HubConnection _hubConnection;
  final Observable<Unit> _onNewUnit = Observable<Unit>(Unit());

  Future<void> connect(String userId) async {
    try {
      _hubConnection = HubConnectionBuilder().withUrl('$_baseUrl?user=$userId').build();
      _hubConnection.start();

      _hubConnection.on("newConnection", (value) => {
        _onNewUnit.value = Unit.fromJson(value[0] as Map<String, dynamic>),
        _onNewUnit.reportChanged()
      });

    } catch (e) {
      log(e.toString());
    }
  }

  Observable getOnNewUnit() {
    return _onNewUnit;
  }
}