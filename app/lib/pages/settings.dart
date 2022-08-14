import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/settings.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.settings}) : super(key: key);

  final UserSettings settings;

  @override
  // ignore: library_private_types_in_public_api
  _SettingsState createState() => _SettingsState(this.settings);
}

class _SettingsState extends State<Settings> {
  _SettingsState(this.userSettings);

  final UserSettings userSettings;
  bool _enabled = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _groupIdController = TextEditingController();
  bool saveLoading = false;

  @override
  void initState() {
    super.initState();

    _enabled = userSettings.groupsEnabled!;
    _usernameController.text = userSettings.userName!;
    _groupIdController.text = userSettings.groupId!;

    _initializeApp();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _groupIdController.dispose();

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
        title: const Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          if (!_enabled) ...[
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
                      hintText: 'Username',
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
                    controller: _usernameController,
                  ),
                )
              ],
            ),
            SizedBox(
              child: Row(
                children: [
                  SizedBox(
                    // height: 80.0,
                    width: MediaQuery.of(context).size.width * 0.07,
                    child: Container(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Enable Sharing Units",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.26,
                      child: Container()),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          value: _enabled,
                          onChanged: (value) {
                            setState(() {
                              _enabled = value;
                            });
                          },
                        )
                      ])
                ],
              ),
            ),
          ] else ...[
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
                      hintText: 'Username',
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
                    controller: _usernameController,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  SizedBox(
                    // height: 80.0,
                    width: MediaQuery.of(context).size.width * 0.02,
                    child: Container(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Enable Sharing Units",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.26,
                      child: Container()),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          value: _enabled,
                          onChanged: (value) {
                            setState(() {
                              _enabled = value;
                            });
                          },
                        )
                      ])
                ],
              ),
            ),
                            SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 20.0,
                  child: Container()
                ),
                        Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  // height: 80.0,
                  child: const Text(
                  'Share Value for Other Devices to Join Your Group or Update to Join Someone Elses Group',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(fontSize: 12)
                )
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  // height: 80.0,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                      hintStyle: TextStyle(fontSize: 19),
                    ),
                    inputFormatters: [GuidInputFormatter()],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(fontSize: 17),
                    maxLines: 1,
                    maxLength: 36,
                    keyboardType: TextInputType.text,
                    enabled: true,
                    controller: _groupIdController,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async { 
          saveLoading = true;
          userSettings.userName = _usernameController.text;
          userSettings.groupId = _groupIdController.text;
          userSettings.groupsEnabled = _enabled;
          saveLoading = (await ApiService().saveSettings(userSettings))!; 
          },
        tooltip: 'Save Settings',
        child: const Icon(Icons.save),
      ),
    );
  }
}

class GuidInputFormatter extends TextInputFormatter {
  static const separator = '-';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String newString = '';
    String tempString = newValue.text.replaceAll(separator, '');

    for (var i = 0; i < tempString.length; i++) {
      newString += tempString[i];

      if (i == 7 || i == 11 || i == 15 || i == 19) {
        newString += separator;
      }
    }

    if (newString[newString.length - 1] == separator) {
      newString = newString.substring(0, newString.length - 1);
    }

    return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(offset: newString.length));
  }
}
