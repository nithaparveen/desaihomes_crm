import 'dart:developer';
import 'package:desaihomes_crm_application/repository/helper/api_helper.dart';

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
}
