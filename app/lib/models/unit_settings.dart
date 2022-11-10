import 'dart:convert';

import 'package:app/models/unit_parameters.dart';

class UnitSettings {
  String? id;
  String? serialNumber;
  String? name;
  bool? isAcquisitioning;
  UnitParameters? unitParameters;

  UnitSettings({
    this.id,
    this.serialNumber,
    this.name,
    this.isAcquisitioning,
    this.unitParameters
  });
  
  factory UnitSettings.fromJson(Map<String, dynamic> json) => UnitSettings(
    id: json["id"],
    serialNumber: json["serialNumber"],
    name: json["name"],
    isAcquisitioning: json["isAcquisitioning"],
    unitParameters: UnitParameters.fromJson(json["unitParameters"])
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serialNumber": serialNumber,
    "name": name,
    "isAcquisitioning": isAcquisitioning,
    "unitParameters": jsonEncode(unitParameters)
  };
}