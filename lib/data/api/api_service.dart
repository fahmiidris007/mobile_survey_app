import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_survey_app/model/user.dart';

class ApiService {
  static const String baseUrl = 'https://dev-api-lms.apps-madhani.com/v1';

  Future<User> login(String nik, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

      },
      body: jsonEncode(<String, String>{
        'nik': nik,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}