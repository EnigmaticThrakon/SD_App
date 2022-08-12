import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();

    _enabled = false;
    _initializeApp();
  }

  void _initializeApp() async {
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          if (!_enabled) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Enable Sharing Units",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(children: [
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
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Enable Sharing Units",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                    ),
                    inputFormatters: [
                      GuidInputFormatter()
                    ],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: 20),
                    maxLines: 1,
                    maxLength: 36,
                    keyboardType: TextInputType.text,
                    enabled: true,
                  ),
                )
              ],
            ),
          ]
        ],
      ),
    );
  }
}

class GuidInputFormatter extends TextInputFormatter {
  static const separator = '-';

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
      if(newValue.text.isEmpty) {
        return newValue.copyWith(text: '');
      }

      String oldValueText = oldValue.text.replaceAll(separator, '');
      String newValueText = newValue.text.replaceAll(separator, '');

      if(oldValue.text.endsWith(separator) && oldValue.text.length == newValue.text.length + 1) {
        newValueText = newValueText.substring(0, newValueText.length - 1);
      }

      if(oldValueText != newValueText) {
        int selectionIndex = newValue.text.length - newValue.selection.extentOffset;

        String newString = '';
        switch(oldValue.text.length){
          case 8:
          case 13:
          case 18:
          case 23:
            newString = '${newValue.text}-';
            break;
          default:
            newString = newValue.text;
            break;
        }

        return TextEditingValue(
          text: newString.toString(),
          selection: TextSelection.collapsed(
            offset: newString.length - selectionIndex
          )
        );
      }

      return newValue;
    }
}