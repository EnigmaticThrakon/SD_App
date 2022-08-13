class Settings {
  String? id;
  String? groupId;
  bool? groupsEnabled;
  String? userName;

  Settings({
    this.groupId,
    this.groupsEnabled,
    this.id,
    this.userName
  });
  
  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    groupId: json["groupId"],
    id: json["id"],
    groupsEnabled: json["groupsEnabled"],
    userName: json["userName"]
  );

  Map<String, dynamic> toJson() => {
    "groupId": groupId,
    "id": id,
    "groupsEnabled": groupsEnabled,
    "userName": userName
  };
}