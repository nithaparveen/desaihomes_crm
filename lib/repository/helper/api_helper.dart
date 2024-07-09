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
}