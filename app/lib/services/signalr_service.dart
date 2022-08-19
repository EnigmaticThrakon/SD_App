import 'dart:convert';
import 'dart:developer';
import 'package:signalr_client/signalr_client.dart';
import 'package:mobx/mobx.dart';

import '../models/unit.dart';

class SignalRService {
  final String _baseUrl = 'http://paranoidandroid.network:52042/appMonitorHub';
  late HubConnection _hubConnection;

  final Observable<Unit> _onNewUnit = Observable<Unit>(Unit());
  final Observable<Unit> _onLinkedUnit = Observable<Unit>(Unit());

  Future<void> connect(String deviceId) async {
    try {
      _hubConnection = HubConnectionBuilder().withUrl('$_baseUrl?deviceId=$deviceId').build();
      _hubConnection.start();

      setupListeners(_hubConnection);

    } catch (e) {
      log(e.toString());
    }
  }

  void setupListeners(HubConnection connection) {
      connection.on("newConnection", (value) => {
        _onNewUnit.value = Unit.fromJson(value[0] as Map<String, dynamic>),
        _onNewUnit.reportChanged()
      });

      connection.on("unitLinked", (value) => {
        _onLinkedUnit.value = Unit.fromJson(value[0] as Map<String, dynamic>),
        _onLinkedUnit.reportChanged()
      });
  }

  Observable getOnNewUnit() {
    return _onNewUnit;
  }

  Observable getOnLinkedUnit() {
    return _onLinkedUnit;
  }
}