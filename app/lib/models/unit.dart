class Unit {
  String? id;
  bool? isConnected;
  String? name;
  bool? isAcquisitioning;

  Unit({
    this.id,
    this.isConnected,
    this.name,
    this.isAcquisitioning
  });
  
  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json["id"],
    isConnected: json["isConnected"],
    name: json["name"],
    isAcquisitioning: json["isAcquisitioning"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isConnected": isConnected,
    "name": name,
    "isAcquisitioning": isAcquisitioning
  };
}