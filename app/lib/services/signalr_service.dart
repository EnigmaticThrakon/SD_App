import 'dart:convert';
import 'dart:developer';
// ignore: import_of_legacy_library_into_null_safe
import 'package:signalr_client/signalr_client.dart';
import 'package:mobx/mobx.dart';

import '../models/monitor_data.dart';
import '../models/unit.dart';
import '../consts/network.dart';

class SignalRService {
  final String _baseUrl = '${NetworkConsts.serverUrl}:${NetworkConsts.serverPort}/${NetworkConsts.signalRBasePath}';
  late HubConnection _hubConnection;

  final Observable<Unit> _onNewUnit = Observable<Unit>(Unit());
  final Observable<Unit> _onStatusChanged = Observable<Unit>(Unit());
  // final Observable<Unit> _onUnlinkedUnit = Observable<Unit>(Unit());
  final Observable<Unit> _onUnitChange = Observable<Unit>(Unit());
  final Observable<MonitorData> _onMonitorData = Observable<MonitorData>(MonitorData());

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

      connection.on("statusChanged", (value) => {
        _onStatusChanged.value = Unit.fromJson(value[0] as Map<String, dynamic>),
        _onStatusChanged.reportChanged()
      });

      // connection.on("unitUnlinked", (value) => {
      //   _onUnlinkedUnit.value = Unit.fromJson(value[0] as Map<String, dynamic>),
      //   _onUnlinkedUnit.reportChanged()
      // });

      // connection.on("newValue", (value) => {
      //   for (Map<String, dynamic> mapping in jsonDecode(value[0].toString())) {
      //     _onMonitorData.value = MonitorData.fromJson(mapping),
      //     _onMonitorData.reportChanged()
      //   },
      // });
  }

  void listenToMonitorData() {
    _hubConnection.on("newValue", (value) => {
        for (Map<String, dynamic> mapping in jsonDecode(value[0].toString())) {
          _onMonitorData.value = MonitorData.fromJson(mapping),
          _onMonitorData.reportChanged()
        },
      });
  }

  Observable getOnChangeValue(bool startListening) {
    if(startListening) {
      listenToMonitorData();
    }

    return _onMonitorData;
  }

  Observable getOnNewUnit() {
    return _onNewUnit;
  }

  Observable getOnStatusChanged() {
    return _onStatusChanged;
  }

  // Observable getOnUnlinkedUnit() {
  //   return _onUnlinkedUnit;
  // }

  Observable getOnUnitChange() {
    return _onUnitChange;
  }

  void notifyUnitChange(Unit unit) {
    _onUnitChange.value = unit;
    _onUnitChange.reportChanged();
  }
}