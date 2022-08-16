class Group {
  String? userId;
  String? groupId;

  Group({
    this.userId,
    this.groupId,
  });
  
  factory Group.fromJson(Map<String, dynamic> json) => Group(
    userId: json["userId"],
    groupId: json["groupId"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "groupId": groupId,
  };
}