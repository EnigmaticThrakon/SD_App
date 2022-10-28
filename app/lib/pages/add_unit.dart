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
        title: const Text('Add Unit', style: TextStyle(fontFamily: 'Serif')),
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
          Navigator.pop(context);
        },
        tooltip: 'Save Selected Units',
        child: const Icon(Icons.save),
      ),
    );
  }
}
