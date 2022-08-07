import 'package:flutter/material.dart';
import 'package:app/services/device_service.dart';

class AddUnit extends StatefulWidget {
  const AddUnit({Key? key}) : super(key: key);


  @override
  _AddUnitState createState() => _AddUnitState();
}

class _AddUnitState extends State<AddUnit> {
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
        title: const Text('Add Unit'),
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
        ),
    );
  }
}