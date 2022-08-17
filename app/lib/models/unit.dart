class Unit {
  String? id;
  String? publicIP;
  bool? selected;
  bool? isConnected;
  String? pairedId;

  Unit({
    this.id,
    this.publicIP,
    this.selected,
    this.isConnected,
    this.pairedId
  });
  
  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json["id"],
    publicIP: json["publicIP"],
    isConnected: json["isConnected"],
    pairedId: json["pairedId"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "publicIP": publicIP,
    "pairedId": pairedId
  };
}