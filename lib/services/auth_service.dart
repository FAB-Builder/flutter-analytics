import 'dart:convert';

import 'package:fab_analytics/constants.dart';
import 'package:fab_analytics/models/config_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Map<String, dynamic>?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    var response = await http.post(
      Uri.parse('${constants.API_HOST}/api/auth/sign-in'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      String token = response.body;
      Config.token = token;
      // await Pref.write('token', token);
      return {'token': token, 'isLocked': false};
    } else if (response.body.toString().toLowerCase().startsWith('sorry')) {
      throw "Invalid Email or Password";
    } else if (response.body.toString().contains("isLocked")) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw response.reasonPhrase.toString();
    }
  }
}
