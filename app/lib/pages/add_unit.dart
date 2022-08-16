import 'package:app/models/group.dart';
import 'package:app/models/unit.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

class AddUnit extends StatefulWidget {
  AddUnit({Key? key, required this.apiService, required this.group}) : super(key: key);

  ApiService apiService;
  Group group;

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _AddUnitState createState() => _AddUnitState(apiService, group);
}

class _AddUnitState extends State<AddUnit> {
  _AddUnitState(this._apiService, this.group);

  final ApiService _apiService;
  Group group;
  List<Unit> _availableUnits = <Unit>[];

  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  void _initializeApp() async {
    _availableUnits = (await _apiService.getAvailableUnits(group));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        title: const Text('Add Unit'),
      ),
      body: _availableUnits.isEmpty ? const Center(
              child: CircularProgressIndicator(),
            ) : ListView.builder(
              itemCount: _availableUnits.length + 1,
              itemBuilder: (context, index) {
                return index != 0 ? GestureDetector(
                  onTap: () => {
                    _availableUnits[index - 1].selected != null ? _availableUnits[index - 1].selected = !_availableUnits[index - 1].selected! : true,
                    setState(() => {})
                  },
                  child: Card(
                    child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _availableUnits[index - 1].id!,
                            style: const TextStyle(fontSize: 16)
                            ),
                          Checkbox(
                            value: _availableUnits[index - 1].selected != null ? _availableUnits[index - 1].selected! : false, 
                            onChanged: (value) => {
                              _availableUnits[index - 1].selected = value,
                              setState(() => {})
                            })
                          ]
                      )
                  )
                ) : const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                  "Select the Devices to Add",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                  )
                );
              }
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {  
          },
        tooltip: 'Save Selected Units',
        child: const Icon(Icons.save),
      ),
    );
  }
}