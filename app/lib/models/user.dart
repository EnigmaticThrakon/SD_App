class User {
  String? deviceId;
  String? id;
  String? publicIP;

  User({
    this.id,
    this.deviceId,
    this.publicIP
  });
  
  factory User.fromJson(Map<String, dynamic> json) => User(
    deviceId: json["deviceId"],
    id: json["id"],
    publicIP: json["publicIP"]
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "id": id,
    "publicIP": publicIP
  };
}