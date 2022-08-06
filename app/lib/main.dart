import 'package:flutter/material.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/device_service.dart';

void main() {
  runApp(const MaterialApp(
    home: Home()
  ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  late String? _deviceId;
  late String? _userId;
  //late List<Unit> _units = null;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    _deviceId = (await DeviceService().getId())!;
    _userId = (await ApiService().getUserId(_deviceId!));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        title: const Text('API Test'),
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
                  Row (
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('User ID: $_userId'),
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