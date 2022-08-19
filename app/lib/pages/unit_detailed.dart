import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

import '../models/unit.dart';

class UnitDetailed extends StatefulWidget {
  const UnitDetailed({Key? key, required this.unit, required this.apiService}) : super(key: key);

  final Unit unit;
  final ApiService apiService;
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _UnitDetailedState createState() => _UnitDetailedState(unit, apiService);
}

class _UnitDetailedState extends State<UnitDetailed> {
  _UnitDetailedState(this._unit, this._apiService);

  final Unit _unit;
  final ApiService _apiService;
  final TextEditingController _deviceNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializeApp() async {
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Detailed'),
      ),
      body: Column(
        children: <Widget>[
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
                            FloatingActionButton(
                  child: const Icon(Icons.delete),
                  onPressed: () async => {
                    await _apiService.unlinkUnit(_unit),
                    Navigator.pop(context)
                  }
                )
        ]
      )

    );
  }
}
