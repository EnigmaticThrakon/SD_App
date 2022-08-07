import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class ApiService {
  static String baseUrl = 'http://marvin.webredirect.org:52042';

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

  Future<String?> connect(User user) async {
    try {
      var url = Uri.parse('$baseUrl/api/Users/Connect');
      var response = await http.put(url, headers: { "Content-Type" : "application/json"}, body: jsonEncode(user));
      // var response = await http.put(url);
      if(response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }
}