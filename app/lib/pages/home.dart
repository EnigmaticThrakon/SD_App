// import 'package:app/pages/settings.dart';
import 'package:app/pages/unit_detailed.dart';
import 'package:app/services/signalr_service.dart';
import 'package:flutter/material.dart';
import 'package:app/services/api_service.dart';
import 'package:app/services/device_service.dart';

// import '../models/settings.dart';
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
  // late UserSettings? _currentSettings;
  Color iconColor = Colors.black;
  final ApiService _apiService = ApiService();
  final SignalRService _signalRService = SignalRService();
  late List<Unit> _userUnits = <Unit>[];
  //late List<Unit> _units = null;

  @override
  void initState() {
    super.initState();

    _currentUser = User();
    // _currentSettings = UserSettings();
    _initializeApp();
  }

  void _initializeApp() async {
    String? tempDeviceId = (await DeviceService().getPlatformGenericId());

    if (tempDeviceId != null) {
      await setupSubscribers(tempDeviceId);
      _currentUser = (await _apiService.connect(tempDeviceId));
    }

    if (_currentUser != User() && _currentUser.id != null) {
      // _currentSettings = (await _apiService.getSettings(_currentUser.id!));
      _userUnits = (await _apiService.getUserUnits(_currentUser.id!));
    }

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  Future<void> setupSubscribers(String deviceId) async {
    _signalRService.connect(deviceId);

    String tempUnitId;
    _signalRService.getOnStatusChanged().observe((unitValue) => {
          tempUnitId = (unitValue.newValue as Unit).id!,
          if (_userUnits.any((unit) => unit.id == tempUnitId))
          {
            _userUnits.where((t) => t.id == (unitValue.newValue as Unit).id).first.isConnected = (unitValue.newValue as Unit).isConnected!,
            // _userUnits.removeWhere((unit) => unit.id == tempUnitId)
          } else {
            _userUnits.add(unitValue.newValue as Unit),
          },
          setState(() => {})
        });

    int changedIndex;
    _signalRService.getOnUnitChange().observe((onUnitChange) => {
          changedIndex = _userUnits.indexWhere(
              (unit) => unit.id == (onUnitChange.newValue as Unit).id),
          _userUnits.removeWhere(
              (unit) => unit.id == (onUnitChange.newValue as Unit).id),
          _userUnits.insert(changedIndex, (onUnitChange.newValue as Unit)),
          setState(() => {})
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meat Ager Monitor',
            style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
      ),
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
                              builder: (context) => UnitDetailed(
                                  unit: _userUnits[index],
                                  apiService: _apiService,
                                  signalR: _signalRService)))
                        },
                    child: Card(
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
                                    _userUnits[index].name == null
                                        ? _userUnits[index].id!
                                        : _userUnits[index].name!,
                                    style: const TextStyle(
                                        fontSize: 25, fontFamily: 'Serif'),
                                    overflow: TextOverflow.ellipsis))
                          ]),
                        ])));
              }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _currentUser.id == null || _currentUser.id!.isEmpty
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddUnit(
                        apiService: _apiService, userId: _currentUser.id!)));
              },
              tooltip: 'Add Unit',
              child: const Icon(Icons.add),
            ),
    );
  }
}
