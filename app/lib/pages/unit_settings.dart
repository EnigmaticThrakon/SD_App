import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

class UnitSettings extends StatefulWidget {
  const UnitSettings({Key? key, required this.apiService, required this.unitId})
      : super(key: key);

  final ApiService apiService;
  final String unitId;

  @override
  // ignore: library_private_types_in_public_api
  _UnitSettingsState createState() =>
      // ignore: no_logic_in_create_state
      _UnitSettingsState(apiService, unitId);
}

class _UnitSettingsState extends State<UnitSettings> {
  _UnitSettingsState(this._apiService, this._unitId);

  final String _unitId;
  final ApiService _apiService;
  final TextEditingController _serialNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  void _initializeApp() async {
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  final _unitSettingsKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Settings',
            style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _unitSettingsKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Device Name'
                ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Name Cannot Be Empty';
                }

                return null;
              },
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Serif'
              )
            )),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Humidity'),
                    Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child:                TextFormField(
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Humidity Cannot Be Empty';
                    }

                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                )
              ),

                  ]
                )
              ),
            ElevatedButton(
              onPressed: () {
                if(_unitSettingsKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit')
            )
          ]
        ),
      )
    );
  }
}
