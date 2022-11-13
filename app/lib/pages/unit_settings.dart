import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import '../models/unit_settings.dart';

class UnitSettingsPage extends StatefulWidget {
  const UnitSettingsPage(
      {Key? key,
      required this.apiService,
      required this.unitId,
      required this.userId})
      : super(key: key);

  final ApiService apiService;
  final String unitId;
  final String userId;

  @override
  // ignore: library_private_types_in_public_api
  _UnitSettingsPageState createState() =>
      // ignore: no_logic_in_create_state
      _UnitSettingsPageState(apiService, unitId, userId);
}

class _UnitSettingsPageState extends State<UnitSettingsPage> {
  _UnitSettingsPageState(this._apiService, this._unitId, this._userId);

  final String _unitId;
  final String _userId;
  final ApiService _apiService;
  final TextEditingController _unitNameController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _airFlowController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  void _initializeApp() async {
    unitSettings = await _apiService.getUnitSettings(_unitId);

    _unitNameController.text = unitSettings.name!;

    if (unitSettings.unitParameters != null) {
      if (unitSettings.unitParameters!.airFlow != null) {
        _airFlowController.text =
            unitSettings.unitParameters!.airFlow.toString();
      }

      if (unitSettings.unitParameters!.temperature != null) {
        _temperatureController.text =
            unitSettings.unitParameters!.temperature.toString();
      }

      if (unitSettings.unitParameters!.humidity != null) {
        _humidityController.text =
            unitSettings.unitParameters!.humidity.toString();
      }
    }

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  late UnitSettings unitSettings = UnitSettings();
  final _unitSettingsKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Unit Settings',
              style:
                  TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
        ),
        body: unitSettings.id == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                key: _unitSettingsKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Device Name'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '';
                                }

                                return null;
                              },
                              textAlign: TextAlign.center,
                              controller: _unitNameController,
                              style: const TextStyle(fontFamily: 'Serif'))),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 27),
                                            child: Text('Humidity: ',
                                                style: TextStyle(
                                                    fontFamily: 'Serif',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)))
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 27, 0, 27),
                                            child: Text('Air Flow: ',
                                                style: TextStyle(
                                                    fontFamily: 'Serif',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)))
                                      ]),
                                  Row(children: const [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 27, 0, 15),
                                        child: Text('Temperature: ',
                                            style: TextStyle(
                                                fontFamily: 'Serif',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)))
                                  ]),
                                ]),
                                Column(children: [
                                  Row(children: [
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder()),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return '';
                                              }

                                              return null;
                                            },
                                            textAlign: TextAlign.center,
                                            controller: _humidityController,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ))
                                  ]),
                                  Row(children: [
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder()),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return '';
                                              }

                                              return null;
                                            },
                                            textAlign: TextAlign.center,
                                            controller: _airFlowController,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ))
                                  ]),
                                  Row(children: [
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return '';
                                              }

                                              return null;
                                            },
                                            textAlign: TextAlign.center,
                                            controller: _temperatureController,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ))
                                  ]),
                                ])
                              ])),
                      ElevatedButton(
                          onPressed: () async {
                            if (_unitSettingsKey.currentState!.validate()) {
                              unitSettings.name =
                                  _unitNameController.value.text;
                              unitSettings.unitParameters!.humidity =
                                  double.parse(_humidityController.value.text);
                              unitSettings.unitParameters!.temperature =
                                  double.parse(
                                      _temperatureController.value.text);
                              unitSettings.unitParameters!.airFlow =
                                  double.parse(_airFlowController.value.text);
                              var response = await _apiService
                                  .saveUnitSettings(unitSettings);

                              if (response == 0) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Settings Saved')),
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, unitSettings);
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Save Failed')),
                                );
                              }
                            }
                          },
                          child: const Text('Save',
                              style: TextStyle(
                                  fontFamily: 'Serif', fontSize: 20))),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                            onPressed: () async => {
                                  if (unitSettings.isAcquisitioning != null &&
                                      !unitSettings.isAcquisitioning!)
                                    {
                                      if (await _apiService.removeUnitFromUser(
                                              unitSettings.id!, _userId) ==
                                          0)
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text('Unit Unpaired')),
                                          ),
                                          unitSettings.isPaired = false,
                                          Navigator.pop(context, unitSettings)
                                        }
                                      else
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Unpairing Failed')),
                                          )
                                        }
                                    }
                                  else
                                    {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  title: const Text(
                                                      'Error Pairing Device',
                                                      style: TextStyle(
                                                          fontFamily: 'Serif',
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  content: const Text(
                                                      'Cannot unpair unit during acquisition, please stop aquisition first',
                                                      style: TextStyle(
                                                          fontFamily: 'Serif',
                                                          fontSize: 20)),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                      child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Serif',
                                                              fontSize: 15)),
                                                    ),
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'Okay'),
                                                        child: const Text(
                                                            'Okay',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Serif',
                                                                fontSize: 15)))
                                                  ]))
                                    }
                                },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red)),
                            child: const Text(
                              "Unpair Unit",
                              style:
                                  TextStyle(fontSize: 20, fontFamily: 'Serif'),
                            )),
                      ),
                    ]),
              )));
  }
}
