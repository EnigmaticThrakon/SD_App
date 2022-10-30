import 'package:app/services/api_service.dart';
import 'package:app/services/signalr_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrx_charts/mrx_charts.dart';

import '../models/unit.dart';

class UnitDetailed extends StatefulWidget {
  const UnitDetailed(
      {Key? key,
      required this.unit,
      required this.apiService,
      required this.signalR})
      : super(key: key);

  final Unit unit;
  final ApiService apiService;
  final SignalRService signalR;
  @override
  // ignore: library_private_types_in_public_api
  _UnitDetailedState createState() =>
      //ignore: no_logic_in_create_state
      _UnitDetailedState(unit, apiService, signalR);
}

class _UnitDetailedState extends State<UnitDetailed> {
  _UnitDetailedState(this._unit, this._apiService, this._signalRService);

  final Unit _unit;
  final ApiService _apiService;
  final SignalRService _signalRService;
  final TextEditingController _deviceNameController = TextEditingController();
  ChartLineDataItem currentValue = ChartLineDataItem(x: DateTime.now().millisecondsSinceEpoch.toDouble(), value: 0.0);
  List<ChartLineDataItem> chartValues = <ChartLineDataItem>[ChartLineDataItem(value: 0.0, x: DateTime.now().millisecondsSinceEpoch.toDouble())];
  List<double> tempValues = <double>[];
  bool isAcquisitioning = false;
  bool settingsChanged = false;
  double maxValue = 0;
  double minValue = 0;

  List<ChartLayer> layers() {
    final from = chartValues.first.x;
    final to = chartValues.last.x;
    final frequency =
        (to - from) / 3.0;
    return [
      ChartAxisLayer(
        settings: ChartAxisSettings(
          x: ChartAxisSettingsAxis(
            frequency: (chartValues.last.x - chartValues.first.x == chartValues.last.x ? chartValues.last.x - 1 : chartValues.first.x) / 2,
            max: chartValues.last.x,
            min: chartValues.first.x,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
          y: ChartAxisSettingsAxis(
            frequency: maxValue - minValue,
            max: maxValue,
            min: minValue,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
        ),
        labelX: (value) => DateFormat('mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
        // labelX: (value) => "",
        labelY: (value) => value.toString(),
      ),
      ChartLineLayer(
        items: chartValues,
        settings: const ChartLineSettings(
          color: Colors.black,
          thickness: 1.0,
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }

  void _initializeApp() async {
    _deviceNameController.text = _unit.name == null ? '' : _unit.name!;

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void setupSubscribers() {
      _signalRService.getOnChangeValue().observe((value) => {
          setState(() => {
            tempValues.add(value.newValue),
            currentValue = ChartLineDataItem(value: value.newValue, x: DateTime.now().millisecondsSinceEpoch.toDouble()),

            if(tempValues.length > 5) {
              chartValues.add(ChartLineDataItem(x: DateTime.now().millisecondsSinceEpoch.toDouble(), value: tempValues.reduce((value, element) => value = value + element) / tempValues.length)),
              tempValues.clear()
            },

            if(currentValue.value > maxValue) {
              maxValue = currentValue.value,
            },

            if(currentValue.value < minValue) {
              minValue = currentValue.value
            }
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Details',
            style: TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
      ),
      body: 
      //  chartValues == null
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
        Column(children: <Widget>[
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
                  hintText: 'Device Name',
                  hintStyle: TextStyle(fontSize: 19, fontFamily: 'Serif'),
                ),
                // inputFormatters: [
                //   GuidInputFormatter()
                // ],
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(fontSize: 19, fontFamily: 'Serif'),
                maxLines: 1,
                maxLength: 100,
                keyboardType: TextInputType.text,
                enabled: true,
                controller: _deviceNameController,
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Text(currentValue.value.toString())
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: 200,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          // padding: const EdgeInsets.all(24.0),
          child: Chart(
            layers: layers(),
            // padding: const EdgeInsets.symmetric(horizontal: 30.0).copyWith(
            //   bottom: 12.0,
            // ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: ElevatedButton(
              onPressed: () async => {
                    setupSubscribers(),
                    isAcquisitioning = !isAcquisitioning,
                    if(!isAcquisitioning) {
                      await _apiService.stopAcquisitioning(_unit.id!),
                      setState(() => {})
                    } else {
                      await _apiService.startAcquisition(_unit.id!)
                    },
                  },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(isAcquisitioning ? Colors.red : Colors.green)),
              child: Text(isAcquisitioning ? "Stop Acquisitioning" : "Start Acquisition",
                style: const TextStyle(fontSize: 20, fontFamily: 'Serif'),
              )),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: ElevatedButton(
              onPressed: () async => {
                    await _apiService.removeUnitFromUser(_unit.id!, ""),
                    Navigator.pop(context)
                  },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
              child: const Text(
                "Unpair Unit",
                style: TextStyle(fontSize: 20, fontFamily: 'Serif'),
              )),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async => {
          _unit.name = _deviceNameController.text,
          await _apiService.updateUnit(_unit),
          _signalRService.notifyUnitChange(_unit),
          setState(() => {})
        },
      ),
    );
  }
}
