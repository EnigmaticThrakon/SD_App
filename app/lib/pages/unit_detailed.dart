import 'package:app/models/monitor_data.dart';
import 'package:app/pages/unit_settings.dart';
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
  bool isAcquisitioning = false;
  bool settingsChanged = false;
  bool startListening = true;
  ChartData chartData = ChartData();
  bool doorOpen = false;

  List<ChartLayer> airFlowChartLayers() {
    double yMax = chartData.airFlow
        .reduce((current, next) => current.value > next.value ? current : next)
        .value;
    double yMin = chartData.airFlow
        .reduce((current, next) => current.value < next.value ? current : next)
        .value;
    return [
      ChartAxisLayer(
        settings: ChartAxisSettings(
          x: ChartAxisSettingsAxis(
            frequency: (chartData.airFlow.last.x -
                    (chartData.airFlow.first.x == chartData.airFlow.last.x
                        ? chartData.airFlow.last.x - 1
                        : chartData.airFlow.first.x)) /
                2,
            max: chartData.airFlow.last.x,
            min: chartData.airFlow.first.x,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
          y: ChartAxisSettingsAxis(
            frequency: (yMax - yMin) / 4,
            max: yMax.roundToDouble(),
            min: yMin.roundToDouble(),
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
        ),
        labelX: (value) => DateFormat('h:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
        labelY: (value) => value.roundToDouble().toString(),
      ),
      ChartLineLayer(
        items: chartData.airFlow,
        settings: const ChartLineSettings(
          color: Colors.black,
          thickness: 1.0,
        ),
      ),
    ];
  }

  List<ChartLayer> tempChartLayers() {
    double yMax = chartData.temperature
        .reduce((current, next) => current.value > next.value ? current : next)
        .value;
    double yMin = chartData.temperature
        .reduce((current, next) => current.value < next.value ? current : next)
        .value;
    return [
      ChartAxisLayer(
        settings: ChartAxisSettings(
          x: ChartAxisSettingsAxis(
            frequency: (chartData.temperature.last.x -
                    (chartData.temperature.first.x ==
                            chartData.temperature.last.x
                        ? chartData.temperature.last.x - 1
                        : chartData.temperature.first.x)) /
                2,
            max: chartData.temperature.last.x,
            min: chartData.temperature.first.x,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
          y: ChartAxisSettingsAxis(
            frequency: (yMax - yMin) / 4,
            max: yMax.roundToDouble(),
            min: yMin.roundToDouble(),
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
        ),
        labelX: (value) => DateFormat('h:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
        labelY: (value) => value.roundToDouble().toString(),
      ),
      ChartLineLayer(
        items: chartData.temperature,
        settings: const ChartLineSettings(
          color: Colors.black,
          thickness: 1.0,
        ),
      ),
    ];
  }

  List<ChartLayer> humidityChartLayers() {
    double yMax = chartData.humidity
        .reduce((current, next) => current.value > next.value ? current : next)
        .value;
    double yMin = chartData.humidity
        .reduce((current, next) => current.value < next.value ? current : next)
        .value;
    return [
      ChartAxisLayer(
        settings: ChartAxisSettings(
          x: ChartAxisSettingsAxis(
            frequency: (chartData.humidity.last.x -
                    (chartData.humidity.first.x == chartData.humidity.last.x
                        ? chartData.humidity.last.x - 1
                        : chartData.humidity.first.x)) /
                2,
            max: chartData.humidity.last.x,
            min: chartData.humidity.first.x,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
          y: ChartAxisSettingsAxis(
            frequency: (yMax - yMin) / 4,
            max: yMax.roundToDouble(),
            min: yMin.roundToDouble(),
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
        ),
        labelX: (value) => DateFormat('h:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
        labelY: (value) => value.roundToDouble().toString(),
      ),
      ChartLineLayer(
        items: chartData.humidity,
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
    startListening = false;
    setupSubscribers();

    super.dispose();
  }

  void _initializeApp() async {
    _deviceNameController.text = _unit.name == null ? '' : _unit.name!;
    isAcquisitioning = await _apiService.isAcquisitioning(_unit.id!);

    if (isAcquisitioning) {
      setupSubscribers();
    }

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void setupSubscribers() {
    _signalRService.getOnChangeValue(startListening).observe(
        (value) => {
              if ((value.newValue as MonitorData).chartTimestamp != null)
                {
                  if ((value.newValue as MonitorData).temperature != null)
                    {
                      chartData.temperature.add(ChartLineDataItem(
                          value: (value.newValue as MonitorData).temperature!,
                          x: (value.newValue as MonitorData)
                              .timestamp!
                              .millisecondsSinceEpoch
                              .toDouble()))
                    },
                  if ((value.newValue as MonitorData).humidity != null)
                    {
                      chartData.humidity.add(ChartLineDataItem(
                          value: (value.newValue as MonitorData).humidity!,
                          x: (value.newValue as MonitorData)
                              .timestamp!
                              .millisecondsSinceEpoch
                              .toDouble()))
                    },
                  if ((value.newValue as MonitorData).airFlow != null)
                    {
                      chartData.airFlow.add(ChartLineDataItem(
                          value: (value.newValue as MonitorData).airFlow!,
                          x: (value.newValue as MonitorData)
                              .timestamp!
                              .millisecondsSinceEpoch
                              .toDouble()))
                    },
                },
              if ((value.newValue as MonitorData).door != null)
                {doorOpen = (value.newValue as MonitorData).door!},
              if (chartData.airFlow.length > 50)
                {
                  chartData.airFlow = chartData.airFlow
                      .skip(chartData.airFlow.length - 50)
                      .take(50)
                      .toList()
                },
              if (chartData.temperature.length > 50)
                {
                  chartData.temperature = chartData.temperature
                      .skip(chartData.temperature.length - 50)
                      .take(50)
                      .toList()
                },
              if (chartData.humidity.length > 50)
                {
                  chartData.humidity = chartData.humidity
                      .skip(chartData.humidity.length - 50)
                      .take(50)
                      .toList()
                },
              if (startListening) {setState(() => {})}
            },
        fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Unit Details',
              style:
                  TextStyle(fontFamily: 'Serif', fontWeight: FontWeight.bold)),
          actions: _unit.id == null || _unit.id!.isEmpty
              ? <Widget>[Container()]
              : <Widget>[
                  IconButton(
                      icon: const Icon(Icons.settings),
                      tooltip: 'Unit Settings',
                      onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => UnitSettings(
                        apiService: _apiService, unitId: _unit.id!)))})
                ]),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        if (isAcquisitioning) ...[
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(_unit.name!,
                  // decoration: const InputDecoration(
                  //   // border: OutlineInpuUtBorder(),
                  //   hintText: 'Device Name',
                  //   hintStyle: TextStyle(fontSize: 19, fontFamily: 'Serif'),
                  // ),
                  // inputFormatters: [
                  //   GuidInputFormatter()
                  // ],
                  textAlign: TextAlign.center,
                  // textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(fontSize: 19, fontFamily: 'Serif'),
                  maxLines: 1,
                  // maxLength: 100,
                  // keyboardType: TextInputType.text,
                  // enabled: true,
                  // controller: _deviceNameController,
                )),
              ),
            ],
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.7,
          //   child: ElevatedButton(
          //       onPressed: () async => {
          //             await _apiService.stopAcquisitioning(_unit.id!),
          //             isAcquisitioning = !isAcquisitioning,
          //             startListening = false,
          //             setupSubscribers(),
          //             setState(() => {})
          //           },
          //       style: ButtonStyle(
          //           backgroundColor:
          //               MaterialStateProperty.all<Color>(Colors.red)),
          //       child: const Text(
          //         "Stop Acquisitioning",
          //         style: TextStyle(fontSize: 20, fontFamily: 'Serif'),
          //       )),
          // ),
          Row(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05, 15, 0, 15),
              child: const Text('Temperature: ',
                  style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Text(
                    chartData.temperature.isNotEmpty
                        ? chartData.temperature.last.value.toString()
                        : '-',
                    style: const TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)))
          ]),
          Container(
              constraints: BoxConstraints(
                maxHeight: 200,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              // padding: const EdgeInsets.all(24.0),
              child: chartData.temperature.length > 2
                  ? Chart(
                      layers: tempChartLayers(),
                      // padding: const EdgeInsets.symmetric(horizontal: 30.0).copyWith(
                      //   bottom: 12.0,
                      // ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    )),
          // SizedBox(
          //     width: MediaQuery.of(context).size.width * 0.7,
          //     child: Text(currentValue.value.toString())),
          Row(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05, 15, 0, 15),
              child: const Text('Airflow: ',
                  style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Text(
                    chartData.airFlow.isNotEmpty
                        ? chartData.airFlow.last.value.toString()
                        : '-',
                    style: const TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold)))
          ]),
          Container(
              constraints: BoxConstraints(
                maxHeight: 200,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              // padding: const EdgeInsets.all(24.0),
              child: chartData.airFlow.length > 2
                  ? Chart(
                      layers: airFlowChartLayers(),
                      // padding: const EdgeInsets.symmetric(horizontal: 30.0).copyWith(
                      //   bottom: 12.0,
                      // ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    )),
          Row(children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05, 15, 0, 15),
              child: const Text('Humidity: ',
                  style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Text(
                    chartData.humidity.isNotEmpty
                        ? chartData.humidity.last.value.toString()
                        : '-',
                    style: const TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
            // FloatingActionButton(onPressed: () => {setState(() => {})})
          ]),
          Container(
              constraints: BoxConstraints(
                maxHeight: 200,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              // padding: const EdgeInsets.all(24.0),
              child: chartData.humidity.length > 2
                  ? Chart(
                      layers: humidityChartLayers(),
                      // padding: const EdgeInsets.symmetric(horizontal: 30.0).copyWith(
                      //   bottom: 12.0,
                      // ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    )),
          const Padding(
            padding: EdgeInsets.all(40)
          )
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
                child: Text(_unit.name!,
                  // decoration: const InputDecoration(
                  //   // border: OutlineInpuUtBorder(),
                  //   hintText: 'Device Name',
                  //   hintStyle: TextStyle(fontSize: 19, fontFamily: 'Serif'),
                  // ),
                  textAlign: TextAlign.center,
                  // textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(fontSize: 19, fontFamily: 'Serif'),
                  maxLines: 1,
                  // maxLength: 100,
                  // keyboardType: TextInputType.text,
                  // enabled: true,
                  // controller: _deviceNameController,
                ),
              ),
            ],
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.7,
          //   child: ElevatedButton(
          //       onPressed: () async => {
          //             startListening = true,
          //             setupSubscribers(),
          //             isAcquisitioning = !isAcquisitioning,
          //             await _apiService.startAcquisition(_unit.id!),
          //           },
          //       style: ButtonStyle(
          //           backgroundColor:
          //               MaterialStateProperty.all<Color>(Colors.green)),
          //       child: const Text(
          //         "Start Acquisition",
          //         style: TextStyle(fontSize: 20, fontFamily: 'Serif'),
          //       )),
          // ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.7,
          //   child: ElevatedButton(
          //       onPressed: () async => {
          //             if (!isAcquisitioning)
          //               {
          //                 await _apiService.removeUnitFromUser(_unit.id!, ""),
          //                 Navigator.pop(context)
          //               }
          //             else
          //               {
          //                 showDialog(
          //                     context: context,
          //                     builder: (BuildContext context) => AlertDialog(
          //                             title: const Text('Error Pairing Device',
          //                                 style: TextStyle(
          //                                     fontFamily: 'Serif',
          //                                     fontSize: 20,
          //                                     fontWeight: FontWeight.bold)),
          //                             content: const Text(
          //                                 'Cannot unpair unit during acquisition, please stop aquisition first',
          //                                 style: TextStyle(
          //                                     fontFamily: 'Serif',
          //                                     fontSize: 20)),
          //                             actions: <Widget>[
          //                               TextButton(
          //                                 onPressed: () =>
          //                                     Navigator.pop(context, 'Cancel'),
          //                                 child: const Text('Cancel',
          //                                     style: TextStyle(
          //                                         fontFamily: 'Serif',
          //                                         fontSize: 15)),
          //                               ),
          //                               TextButton(
          //                                   onPressed: () =>
          //                                       Navigator.pop(context, 'Okay'),
          //                                   child: const Text('Okay',
          //                                       style: TextStyle(
          //                                           fontFamily: 'Serif',
          //                                           fontSize: 15)))
          //                             ]))
          //               }
          //           },
          //       style: ButtonStyle(
          //           backgroundColor:
          //               MaterialStateProperty.all<Color>(Colors.red)),
          //       child: const Text(
          //         "Unpair Unit",
          //         style: TextStyle(fontSize: 20, fontFamily: 'Serif'),
          //       )),
          // ),
        ]
      ])),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          if(isAcquisitioning) {
            await _apiService.stopAcquisitioning(_unit.id!);
            isAcquisitioning = !isAcquisitioning;
            startListening = false;
            setupSubscribers();
          } else {
            await _apiService.startAcquisition(_unit.id!);
            isAcquisitioning = !isAcquisitioning;
            startListening = true;
            setupSubscribers();
          }

          setState(() => {});
        },
        style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(isAcquisitioning ? Colors.red : Colors.green)),
        child: Text(isAcquisitioning ? 'Stop Acquisitioning' : 'Start Acquisitioning',
          style: const TextStyle(fontSize: 20, fontFamily: 'Serif')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
