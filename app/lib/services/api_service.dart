import 'dart:convert';
import 'dart:developer';

import 'package:app/models/unit.dart';
import 'package:http/http.dart' as http;

import '../models/group.dart';
import '../models/settings.dart';
import '../models/user.dart';

class ApiService {
  static String baseUrl = 'http://paranoidandroid.network:52042';

  Future<String> getTest() async {
    try {
      var url = Uri.parse('$baseUrl/test');
      var response = await http.get(url);
      if(response.statusCode == 200) {
        return "succes";
      } else {
        return "something weird happened";
      }
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<User> connect(String deviceId) async {
    try {
      var url = Uri.parse('$baseUrl/api/Users/$deviceId');
      // var response = await http.put(url, headers: { "Content-Type" : "application/json"}, body: jsonEncode(user));
      var response = await http.put(url, headers: { "Content-Type" : "application/json", "accept": "text/plain"}, body: deviceId.toString());
      // var response = await http.put(url);
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
      var url = Uri.parse('$baseUrl/api/Settings/$userId');
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
      var url = Uri.parse('$baseUrl/api/Settings/Save');
      var response = await http.put(url, headers: { "Content-Type" : "application/json" }, body: jsonEncode(settings.toJson()));

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
      var url = Uri.parse('$baseUrl/api/Unit/Auto');
      var response = await http.put(url, headers: { "Content-Type" : "application/json" }, body: jsonEncode(group.toJson()));

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
      var url = Uri.parse('$baseUrl/api/Unit/$userId');
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
      var url = Uri.parse('$baseUrl/api/Unit/Link');
      var response = await http.post(url, headers: { "Content-Type" : "application/json" }, body: jsonEncode(unit.toJson()));

      if(response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log(e.toString());
    }

    return false;
  }
}