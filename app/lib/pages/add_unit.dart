import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

class AddUnit extends StatefulWidget {
  const AddUnit({Key? key, required this.apiService, required this.userId})
      : super(key: key);

  final ApiService apiService;
  final String userId;

  @override
  // ignore: library_private_types_in_public_api
  _AddUnitState createState() =>
      // ignore: no_logic_in_create_state
      _AddUnitState(apiService, userId);
}

class _AddUnitState extends State<AddUnit> {
  _AddUnitState(this._apiService, this._userId);

  final String _userId;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Unit',
            style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Flexible(
                child: Text(
                  "Please Enter the Serial Number of the Device Below",
                  style: TextStyle(fontSize: 20, fontFamily: 'Serif'),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [SizedBox(height: 45)]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  // height: 80.0,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontSize: 30),
                    ),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(fontSize: 30, fontFamily: 'Serif'),
                    maxLines: 1,
                    maxLength: 16,
                    keyboardType: TextInputType.text,
                    enabled: true,
                    controller: _serialNumberController,
                  ),
                )
              ],
            ),
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          int response = await _apiService.addUnitToUser(
              _serialNumberController.text, _userId);

          if (response == 1 || response == 2) {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                        title: const Text('Error Pairing Device',
                            style: TextStyle(
                                fontFamily: 'Serif',
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        content: response == 2
                            ? const Text('Incorrect Data Sent to API',
                                style: TextStyle(
                                    fontFamily: 'Serif', fontSize: 20))
                            : const Text(
                                'Could Not Find Device, Ensure Device It Has Been Connected',
                                style: TextStyle(
                                    fontFamily: 'Serif', fontSize: 17)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel',
                                style: TextStyle(
                                    fontFamily: 'Serif', fontSize: 15)),
                          ),
                          TextButton(
                              onPressed: () => Navigator.pop(context, 'Okay'),
                              child: const Text('Okay',
                                  style: TextStyle(
                                      fontFamily: 'Serif', fontSize: 15)))
                        ]));
          } else {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        },
        tooltip: 'Save Selected Units',
        child: const Icon(Icons.save),
      ),
    );
  }
}
