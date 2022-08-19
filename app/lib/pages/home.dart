import 'dart:convert';
import 'dart:developer';

import 'package:app/pages/settings.dart';
import 'package:app/pages/unit_detailed.dart';
import 'package:app/services/signalr_service.dart';
import 'package:flutter/material.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/device_service.dart';

import '../models/group.dart';
import '../models/settings.dart';
import '../models/unit.dart';
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
  final ApiService _apiService = ApiService();
  final SignalRService _signalRService = SignalRService();
  late List<Unit> _userUnits = <Unit>[];
  //late List<Unit> _units = null;

  @override
  void initState() {
    super.initState();

    _currentUser = User();
    _currentSettings = UserSettings();
    _initializeApp();
  }

  void _initializeApp() async {
    String? tempDeviceId = (await DeviceService().getId());

    if(tempDeviceId != null) {
      await setupSubscribers(tempDeviceId);
      _currentUser = (await _apiService.connect(tempDeviceId));
    }

    if (_currentUser != User() && _currentUser.id != null) {
      _currentSettings = (await _apiService.getSettings(_currentUser.id!));
      _userUnits = (await _apiService.getUserUnits(_currentUser.id!));
    }

    Future.delayed(const Duration(seconds: 5)).then((value) => setState(() {}));
  }

  Future<void> setupSubscribers(String deviceId) async {
    _signalRService.connect(deviceId);

    String newUnitId;
    _signalRService.getOnNewUnit().observe((onNewUnit) => {
          newUnitId = (onNewUnit.newValue as Unit).id!,
          if (_userUnits.any((t) => t.id == newUnitId))
            {
              _userUnits.where((t) => t.id == newUnitId).first.isConnected =
                  (onNewUnit.newValue as Unit).isConnected!
            },
          setState(() => {})
        });

    String linkedUnitId;
    _signalRService.getOnLinkedUnit().observe((onLinkedUnit) => {
          linkedUnitId = (onLinkedUnit.newValue as Unit).pairedId!,
          if(_currentUser.id == linkedUnitId || (_currentSettings!.groupsEnabled! && _currentSettings!.groupId! == linkedUnitId)) {
            _userUnits.add(onLinkedUnit.newValue as Unit)
          },

          setState(() => {})
    });

    String unlinkedUnitId;
    _signalRService.getOnUnlinkedUnit().observe((onUnlinkedUnit) => {
      unlinkedUnitId = (onUnlinkedUnit.newValue as Unit).id!,
      if(_userUnits.any((unit) => unit.id == unlinkedUnitId)) {
        _userUnits.removeWhere((unit) => unit.id == unlinkedUnitId)
      },

      setState(() => {})
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('API Test'),
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
              itemCount: _userUnits.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UnitDetailed(unit: _userUnits[index], apiService: _apiService,)))
                        },
                    child: Card(
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.black.withOpacity(0.5), width: 1.0),
                        //   borderRadius: const BorderRadius.all(Radius.circular(10.0)),

                        // ),
                        margin: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ImageIcon(
                                    const AssetImage('assets/meat-ager.png'),
                                    size: 75,
                                    color: _userUnits[index].isConnected!
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                )
                              ]),
                          Column(children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                    _userUnits[index].publicIP == null
                                        ? 'Device $index'
                                        : _userUnits[index].publicIP!,
                                    style: const TextStyle(fontSize: 25),
                                    overflow: TextOverflow.ellipsis))
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddUnit(
                        apiService: _apiService,
                        signalR: _signalRService,
                        group: Group(
                            userId: _currentUser.id,
                            groupId: _currentSettings!.groupId),
                        publicIP: _currentUser.publicIP == null ? '' : _currentUser.publicIP!)));
              },
              tooltip: 'Add Unit',
              child: const Icon(Icons.add),
            ),
    );
  }
}
