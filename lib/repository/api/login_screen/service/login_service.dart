import 'dart:developer';

import 'package:desaihomes_crm_application/repository/helper/api_helper.dart';

class LoginService {
  static Future<dynamic> postLoginData(email,password) async {
    try {
      var decodedData =
          await ApiHelper.postData(endPoint: "login?email=$email&password=$password");
      return decodedData;
    } catch (e) {
      log("$e");
    }
  }
}
