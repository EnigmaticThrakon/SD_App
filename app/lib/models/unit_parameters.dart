class UnitParameters {
  double? temperature;
  double? humidity;
  double? airFlow;
  double? weight;
  bool? door;

  UnitParameters({
    this.temperature,
    this.humidity,
    this.airFlow,
    this.weight,
    this.door,
  });
  
  factory UnitParameters.fromJson(Map<String, dynamic> json) => UnitParameters(
    temperature: json["Temperature"],
    humidity: json["Humidity"],
    airFlow: json["AirFlow"],
    weight: json["Weight"],
    door: json["Door"]
  );
}