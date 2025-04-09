import 'dart:convert';
import 'dart:developer';
import 'package:desaihomes_crm_application/repository/helper/api_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class LoginService {
  static Future<dynamic> postLoginData(String email, String password) async {
    try {
      String encodedEmail = Uri.encodeComponent(email);
      String encodedPassword = Uri.encodeComponent(password);

      var decodedData = await ApiHelper.postData(
        endPoint: "login?email=$encodedEmail&password=$encodedPassword"
      );
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }
    static Future<dynamic> checkAppVersion() async {
    try {
      var response = await http.get(  
        Uri.parse("https://www.desaihomes.com/api/app/version/check"),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log("Failed to fetch app version. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      log("Error in checkAppVersion: $e");
      return null;
    }
  }

  static Future<bool> downloadApk(String downloadUrl, String savePath) async {
    try {
      var response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        log("APK downloaded successfully to $savePath");
        return true;
      } else {
        log("Failed to download APK. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Error in downloadApk: $e");
      return false;
    }
  }
}
