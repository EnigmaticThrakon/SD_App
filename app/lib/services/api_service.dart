import 'dart:convert';
import 'dart:developer';

import 'package:app/models/unit.dart';
import 'package:http/http.dart' as http;

import '../models/unit_settings.dart';
import '../models/user.dart';
import '../consts/network.dart';

class ApiService {
  final String _baseUrl =
      '${NetworkConsts.serverUrl}:${NetworkConsts.serverPort}/${NetworkConsts.apiBasePath}';
  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "accept": "text/plain"
  };

  /* #region NEEDED_FOR_DEMONSTRATION */
    Future<List<Unit>> getUserUnits(String userId) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.basePath}$userId');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<Unit> units = <Unit>[];

        for (Map map in jsonDecode(response.body)) {
          units.add(Unit.fromJson(map as Map<String, dynamic>));
        }

        return units;
      }
    } catch (e) {
      log(e.toString());
    }

    return <Unit>[];
  }

    Future<User> connect(String deviceId) async {
    try {
      var url = Uri.parse('$_baseUrl${UserApiConsts.basePath}$deviceId');
      var response =
          await http.put(url, headers: _headers, body: deviceId.toString());

      if (response.statusCode == 200) {
        User returnValue = User.fromJson(jsonDecode(response.body));
        returnValue.deviceId = deviceId;

        return returnValue;
      }
    } catch (e) {
      log(e.toString());
    }

    return User();
  }

    Future<int> addUnitToUser(String serialNumber, String userId) async {
    try {
      var url =
          Uri.parse('$_baseUrl${UnitApiConsts.addUnit}/$serialNumber/$userId');
      var response = await http.post(url, headers: _headers, body: "{}");

      switch(response.statusCode) {
        case 200: {
          return 0;
        }
        case 404: {
          return 1;
        }
        case 400: {
          return 2;
        }
        default: {
          return 3;
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return 3;
  }

  Future<int> removeUnitFromUser(String unitId, String userId) async {
    try {
      var url =
          Uri.parse('$_baseUrl${UnitApiConsts.removeUnit}/$unitId/$userId');
      var response = await http.post(url, headers: _headers, body: "{}");

      switch(response.statusCode) {
        case 200: {
          return 0;
        }
        case 404: {
          return 1;
        }
        case 400: {
          return 2;
        }
        default: {
          return 3;
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return 3;
  }

  Future<int> updateUnitName(String unitId, String unitName) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.updateName}/$unitId/$unitName');
      var response = await http.patch(url, headers: _headers, body: "{}");

      switch(response.statusCode) {
        case 200: {
          return 0;
        }
        case 404: {
          return 1;
        }
        case 400: {
          return 2;
        }
        default: {
          return 3;
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return 3;
  }

  Future<int> startAcquisition(String unitId) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.startAcquisition}/$unitId');
      var response = await http.put(url, headers: _headers, body: "{}");

      switch(response.statusCode) {
        case 200: {
          return 0;
        }
        case 404: {
          return 1;
        }
        case 400: {
          return 2;
        }
        default: {
          return 3;
        }
      }

    } catch(e) {
      log(e.toString());
    }

    return 3;
  }

  Future<int> stopAcquisitioning(String unitId) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.stopAcquisition}/$unitId');
      var response = await http.put(url, headers: _headers, body: "{}");

      switch(response.statusCode) {
        case 200: {
          return 0;
        }
        case 404: {
          return 1;
        }
        case 400: {
          return 2;
        }
        default: {
          return 3;
        }
      }

    } catch (e) {
      log(e.toString());
    }

    return 3;
  }

  Future<bool> isAcquisitioning(String unitId) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.isAcquisitioning}/$unitId');
      var response = await http.get(url);

      return response.body == "true";
    } catch (e) {
      log(e.toString());
    }

    return false;
  }

  Future<UnitSettings> getUnitSettings(String unitId) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.getConfigurations}/$unitId');
      var response = await http.get(url);

      if(response.statusCode == 200) {
        return UnitSettings.fromJson(jsonDecode(response.body));
      } 
    } catch(e) {
      log(e.toString());
    }

    return UnitSettings();
  }

  Future<int> saveUnitSettings(UnitSettings settings) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.updateConfigurations}');
      var response = await http.post(url, headers: _headers, body:  jsonEncode(settings.toJson()));

      switch(response.statusCode) {
        case 200: {
          return 0;
        }
        case 404: {
          return 1;
        }
        case 400: {
          return 2;
        }
        default: {
          return 3;
        }
      }

    } catch (e) {
      log(e.toString());
    }

    return 3;
  }
  /* #endregion */
}
