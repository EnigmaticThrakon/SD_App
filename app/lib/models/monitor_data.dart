import 'package:mrx_charts/mrx_charts.dart';

class MonitorData {
  DateTime? timestamp;
  double? temperature;
  double? humidity;
  double? airFlow;
  double? weight;
  int? door;
  double? chartTimestamp;

  MonitorData({
    this.timestamp,
    this.temperature,
    this.humidity,
    this.airFlow,
    this.weight,
    this.door,
    this.chartTimestamp
  });
  
  factory MonitorData.fromJson(Map<String, dynamic> json) => MonitorData(
    timestamp: DateTime.parse(json["Timestamp"]),
    temperature: json["Temperature"],
    humidity: json["Humidity"],
    airFlow: json["AirFlow"],
    weight: json["Weight"],
    door: json["Door"],
    chartTimestamp: DateTime.parse(json["Timestamp"]).millisecondsSinceEpoch.toDouble()
  );
}

class ChartData {
  List<ChartLineDataItem> airFlow = <ChartLineDataItem>[];
  List<ChartLineDataItem> temperature = <ChartLineDataItem>[];
  List<ChartLineDataItem> humidity = <ChartLineDataItem>[];

  ChartData();
}