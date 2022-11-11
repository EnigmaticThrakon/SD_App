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
    temperature: double.parse(json["temperature"].toString()),
    humidity: double.parse(json["humidity"].toString()),
    airFlow: double.parse(json["airFlow"].toString()),
    weight: double.parse(json["weight"].toString()),
    door: json["door"]
  );

  Map<String, dynamic> toJson() => {
    "temperature": temperature,
    "humidity": humidity,
    "airFlow": airFlow,
    "weight": weight,
    "door": door
  };
}