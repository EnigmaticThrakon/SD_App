import 'dart:developer';
// ignore: import_of_legacy_library_into_null_safe
import 'package:signalr_client/signalr_client.dart';
import 'package:mobx/mobx.dart';

import '../models/unit.dart';
import '../consts/network.dart';

class SignalRService {
  final String _baseUrl = '${NetworkConsts.serverUrl}:${NetworkConsts.serverPort}/${NetworkConsts.signalRBasePath}';
  late HubConnection _hubConnection;

  final Observable<Unit> _onNewUnit = Observable<Unit>(Unit());
  final Observable<Unit> _onLinkedUnit = Observable<Unit>(Unit());
  final Observable<Unit> _onUnlinkedUnit = Observable<Unit>(Unit());
  final Observable<Unit> _onUnitChange = Observable<Unit>(Unit());
  final Observable<double> _onValueChange = Observable<double>(0);

  Future<void> connect(String deviceId) async {
    try {
      _hubConnection = HubConnectionBuilder().withUrl('$_baseUrl?deviceId=$deviceId').build();
      _hubConnection.start();

      setupListeners(_hubConnection);

      _hubConnection.onclose((err) => {
        log(err.toString()),
        _hubConnection.start()
      });

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

      connection.on("unitUnlinked", (value) => {
        _onUnlinkedUnit.value = Unit.fromJson(value[0] as Map<String, dynamic>),
        _onUnlinkedUnit.reportChanged()
      });

      connection.on("newValue", (value) => {
        _onValueChange.value = double.parse(value[0].toString()),
        _onValueChange.reportChanged()
      });
  }

  Observable getOnChangeValue() {
    return _onValueChange;
  }

  Observable getOnNewUnit() {
    return _onNewUnit;
  }

  Observable getOnLinkedUnit() {
    return _onLinkedUnit;
  }

  Observable getOnUnlinkedUnit() {
    return _onUnlinkedUnit;
  }

  Observable getOnUnitChange() {
    return _onUnitChange;
  }

  void notifyUnitChange(Unit unit) {
    _onUnitChange.value = unit;
    _onUnitChange.reportChanged();
  }
}