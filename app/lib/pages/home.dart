import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/device_service.dart';

import '../models/user.dart';
import '../services/signalr_service.dart';
import 'add_unit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String? _deviceId;
  late String? _userId;
  late User _currentUser;
  //late List<Unit> _units = null;

  @override
  void initState() {
    super.initState();

    _currentUser = User();
    _deviceId = _userId = null;
    _initializeApp();
  }

  void _initializeApp() async {
    _currentUser.deviceId = (await DeviceService().getId());
    _currentUser.id = (await ApiService().connect(_currentUser));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    SignalRService().connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        title: const Text('API Test'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'User Settings',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Settings()));
            }
          )
        ]
      ),
      body: _currentUser.id == null || _currentUser.id!.isEmpty
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
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed:(){Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddUnit()));},
        tooltip: 'Add Unit',
        child: const Icon(Icons.add),
        ),
    );
  }
}