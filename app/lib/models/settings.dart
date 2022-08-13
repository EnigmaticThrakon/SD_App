class UserSettings {
  String? id;
  String? groupId;
  bool? groupsEnabled;
  String? userName;

  UserSettings({
    this.groupId,
    this.groupsEnabled,
    this.id,
    this.userName
  });
  
  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
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