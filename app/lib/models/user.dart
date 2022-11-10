class User {
  String? deviceId;
  String? id;
  String? userName;

  User({
    this.id,
    this.deviceId,
    this.userName
  });
  
  factory User.fromJson(Map<String, dynamic> json) => User(
    deviceId: json["deviceId"],
    id: json["id"],
    userName: json["userName"]
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "id": id,
    "userName": userName
  };
}