import 'package:flutter/material.dart';
import 'package:app/services/device_service.dart';


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);


  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String? _deviceId;
  late String? _userId;
  //late List<Unit> _units = null;

  @override
  void initState() {
    super.initState();

    _deviceId = _userId = null;
    _initializeApp();
  }

  void _initializeApp() async {
    _deviceId = (await DeviceService().getId())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        title: const Text('Settings'),
      ),
      body: _userId == null || _userId!.isEmpty
        ? const Center(
          child: CircularProgressIndicator(),
          )
        : ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Card(
              child: Column (
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('User ID: $_userId'),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Device ID: $_deviceId'),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  )
                ],
              )
            );
          }
        )
    );
  }
}