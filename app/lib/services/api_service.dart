import 'dart:convert';
import 'dart:developer';

import 'package:app/models/unit.dart';
import 'package:http/http.dart' as http;

import '../models/group.dart';
import '../models/settings.dart';
import '../models/user.dart';
import '../consts/network.dart';

class ApiService {
  final String _baseUrl = '${NetworkConsts.serverUrl}:${NetworkConsts.serverPort}/${NetworkConsts.apiBasePath}';
  final Map<String, String> _headers = { "Content-Type" : "application/json", "accept": "text/plain"};

  Future<User> connect(String deviceId) async {
    try {
      var url = Uri.parse('$_baseUrl${UserApiConsts.connect}$deviceId');
      var response = await http.put(url, headers: _headers, body: deviceId.toString());

      if(response.statusCode == 200) {
        User returnValue = User.fromJson(jsonDecode(response.body));
        returnValue.deviceId = deviceId;

        return returnValue;
      }
    } catch (e) {
      log(e.toString());
    }

    return User();
  }

  Future<UserSettings?> getSettings(String userId) async {
    try {
      var url = Uri.parse('$_baseUrl${UserApiConsts.getSettings}$userId');
      var response = await http.put(url);

      if(response.statusCode == 200) {
        UserSettings temp = UserSettings.fromJson(jsonDecode(response.body));
        return temp;
      }
    } catch(e) {
      log(e.toString());
    }

    return null;
  }

  Future<bool> saveSettings(UserSettings settings) async {
    try {
      var url = Uri.parse('$_baseUrl${UserApiConsts.saveSettings}');
      var response = await http.put(url, headers: _headers, body: jsonEncode(settings.toJson()));

      if(response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log(e.toString());
    }

    return false;
  }

  Future<List<Unit>> getAvailableUnits(Group group) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.findUnits}');
      var response = await http.put(url, headers: _headers, body: jsonEncode(group.toJson()));

      if(response.statusCode == 200) {
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

  Future<List<Unit>> getUserUnits(String userId) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.basePath}$userId');
      var response = await http.get(url);

      if(response.statusCode == 200) {
        List<Unit> units = <Unit>[];

        for(Map map in jsonDecode(response.body)) {
          units.add(Unit.fromJson(map as Map<String, dynamic>));
        }

        return units;
      }
    } catch (e) {
      log(e.toString());
    }

    return <Unit>[];
  }

  Future<bool> linkUnit(Unit unit) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.link}');
      var response = await http.put(url, headers: _headers, body: jsonEncode(unit.toJson()));

      if(response.statusCode == 200 && response.body == "true") {
        return true;
      }
    } catch (e) {
      log(e.toString());
    }

    return false;
  }

  Future<bool> unlinkUnit(Unit unit) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.unlink}');
      var response = await http.put(url, headers: _headers, body: jsonEncode(unit.toJson()));

      if(response.statusCode == 200 && response.body == "true") {
        return true;
      }
    } catch (e) {
      log(e.toString());
    }

    return false;
  }

    Future<bool> updateUnit(Unit unit) async {
    try {
      var url = Uri.parse('$_baseUrl${UnitApiConsts.update}');
      var response = await http.put(url, headers: _headers, body: jsonEncode(unit.toJson()));

      if(response.statusCode == 200 && response.body == "true") {
        return true;
      }
    } catch (e) {
      log(e.toString());
    }

    return false;
  }
}