import 'package:app/pages/settings.dart';
import 'package:app/pages/unit_detailed.dart';
import 'package:flutter/material.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/device_service.dart';

import '../models/settings.dart';
import '../models/user.dart';
// import '../services/signalr_service.dart';
import 'add_unit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late User _currentUser;
  late UserSettings? _currentSettings;
  Color iconColor = Colors.black;
  //late List<Unit> _units = null;

  @override
  void initState() {
    super.initState();

    _currentUser = User();
    _currentSettings = UserSettings();
    _initializeApp();
  }

  void _initializeApp() async {
    _currentUser.deviceId = (await DeviceService().getId());
    String? tempUserId = (await ApiService().connect(_currentUser));

    if (tempUserId != null) {
      _currentUser.id = tempUserId;
      _currentSettings = (await ApiService().getSettings(_currentUser.id!));
    }

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    // SignalRService().connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('API Test'),
          backgroundColor: Colors.black,
          actions: _currentUser.id == null || _currentUser.id!.isEmpty
              ? <Widget>[Container()]
              : <Widget>[
                  IconButton(
                      icon: const Icon(Icons.settings),
                      tooltip: 'User Settings',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Settings(settings: _currentSettings!)));
                      })
                ]),
      body: _currentUser.id == null || _currentUser.id!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UnitDetailed(selectedColor: iconColor)))
                        },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        
                      ),
                      margin: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ImageIcon(
                                AssetImage('assets/meat-ager.png'),
                                size: 75,
                              ),
                            )
                          ]),
                      Column(
                        children: const [
                        Text(
                          "Ager Device",
                          style: TextStyle(fontSize: 25))
                        ]),
                    ])));

                // Column (
                //   children: [
                //     const SizedBox(
                //       height: 20.0,
                //     ),
                //     Row (
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: const [
                //         ImageIcon(
                //           AssetImage('assets/meat-ager.png'),
                //           size: 50,
                //         )
                //       ],
                //     ),
                //     const SizedBox(
                //       height: 20.0,
                //     ),
                //     Row (
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         Text('Device ID: $_deviceId'),
                //       ],
                //     ),
                //     const SizedBox(
                //       height: 20.0,
                //     )
                //   ],
                // )
              }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _currentUser.id == null || _currentUser.id!.isEmpty
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AddUnit()));
              },
              tooltip: 'Add Unit',
              child: const Icon(Icons.add),
              backgroundColor: Colors.black,
            ),
    );
  }
}
