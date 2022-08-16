class Unit {
  String? id;
  String? publicIP;
  bool? selected;

  Unit({
    this.id,
    this.publicIP,
    this.selected
  });
  
  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json["id"],
    publicIP: json["publicIP"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "publicIP": publicIP
  };
}