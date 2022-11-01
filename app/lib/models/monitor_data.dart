class MonitorData {
  DateTime? timestamp;
  double? temperature;
  double? humidity;
  double? airFlow;
  double? weight;
  int? door;

  MonitorData({
    this.timestamp,
    this.temperature,
    this.humidity,
    this.airFlow,
    this.weight,
    this.door
  });
  
  factory MonitorData.fromJson(Map<String, dynamic> json) => MonitorData(
    timestamp: DateTime.parse(json["Timestamp"]),
    temperature: json["Temperature"],
    humidity: json["Humidity"],
    airFlow: json["AirFlow"],
    weight: json["Weight"],
    door: json["Door"]
  );

  // Map<String, dynamic> toJson() => {
  //   "deviceId": deviceId,
  //   "id": id,
  //   "publicIP": publicIP
  // };
}