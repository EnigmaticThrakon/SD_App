import 'package:app/services/api_service.dart';
import 'package:app/services/signalr_service.dart';
import 'package:flutter/material.dart';

import '../models/unit.dart';

class UnitDetailed extends StatefulWidget {
  const UnitDetailed(
      {Key? key,
      required this.unit,
      required this.apiService,
      required this.signalR})
      : super(key: key);

  final Unit unit;
  final ApiService apiService;
  final SignalRService signalR;
  @override
  // ignore: library_private_types_in_public_api
  _UnitDetailedState createState() =>
      //ignore: no_logic_in_create_state
      _UnitDetailedState(unit, apiService, signalR);
}

class _UnitDetailedState extends State<UnitDetailed> {
  _UnitDetailedState(this._unit, this._apiService, this._signalRService);

  final Unit _unit;
  final ApiService _apiService;
  final SignalRService _signalRService;
  final TextEditingController _deviceNameController = TextEditingController();

  bool settingsChanged = false;

  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }

  void _initializeApp() async {
    _deviceNameController.text = _unit.name == null ? '' : _unit.name!;

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Detailed'),
      ),
      body: Column(children: <Widget>[
        SizedBox(
          height: 10.0,
          child: Container(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              // height: 80.0,
              child: TextField(
                decoration: const InputDecoration(
                  // border: OutlineInpuUtBorder(),
                  hintText: 'Device Name',
                  hintStyle: TextStyle(fontSize: 19),
                ),
                // inputFormatters: [
                //   GuidInputFormatter()
                // ],
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(fontSize: 19),
                maxLines: 1,
                maxLength: 100,
                keyboardType: TextInputType.text,
                enabled: true,
                controller: _deviceNameController,
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: ElevatedButton(
              onPressed: () async =>
                  {await _apiService.unlinkUnit(_unit), Navigator.pop(context)},
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Text(
                "Delete Unit",
                style: TextStyle(fontSize: 20),
              )),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async => {
          _unit.name = _deviceNameController.text,
          await _apiService.updateUnit(_unit),
          _signalRService.notifyUnitChange(_unit),
          setState(() => {})
        },
      ),
    );
  }
}
