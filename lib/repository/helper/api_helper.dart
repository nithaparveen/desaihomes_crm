import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../app_config/app_config.dart';

class ApiHelper {
  static postData({
    required String endPoint,
    Map<String, String>? header,
    Map<String, dynamic>? body,
  }) async {
    log("input $body");
    final url = Uri.parse(AppConfig.baseurl + endPoint);
    log("$url -> url");
    try {
      var response = await http.post(url, body: body, headers: header);
      log("StatusCode -> ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        log("Api Failed");
        var data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      }
    } catch (e) {
      log("$e");
    }
  }

  static getData({
    required String endPoint,
    Map<String, String>? header,
  }) async {
    log("ApiHelper -> getData");
    final url = Uri.parse(AppConfig.baseurl + endPoint);
    log("url -> $url");
    try {
      var response = await http.get(url, headers: header);
      log("getData -> Status code -> ${response.statusCode}");
      // log("response -> ${response.body.toString()}");
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        // log("$decodedData");
        return decodedData;
      } else {
        log("Else Condition >> Api failed");
      }
    } catch (e) {
      log("$e");
    }
  }

  static getDataWObaseUrl({
    required String endPoint,
    Map<String, String>? header,
  }) async {
    log("ApiHelper -> getData");
    final url = Uri.parse(endPoint);
    log("url -> $url");
    try {
      var response = await http.get(url, headers: header);
      log("getData -> Status code -> ${response.statusCode}");
      // log("response -> ${response.body.toString()}");
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        // log("$decodedData");
        return decodedData;
      } else {
        log("Else Condition >> Api failed");
      }
    } catch (e) {
      log("$e");
    }
  }

  static Map<String, String> getApiHeader({String? access, String? dbName}) {
    if (access != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access'
      };
    } else if (dbName != null) {
      return {'Content-Type': 'application/json', 'dbName': dbName};
    } else {
      return {
        'Content-Type': 'application/json',
      };
    }
  }
}
