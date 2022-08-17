class Unit {
  String? id;
  String? publicIP;
  bool? selected;
  bool? isConnected;

  Unit({
    this.id,
    this.publicIP,
    this.selected,
    this.isConnected
  });
  
  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json["id"],
    publicIP: json["publicIP"],
    isConnected: json["isConnected"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "publicIP": publicIP
  };
}