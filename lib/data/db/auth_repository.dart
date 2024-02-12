import 'package:mobile_survey_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<void> saveTokens(Map<String, String> tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tokens['token']!);
    await prefs.setString('refresh_token', tokens['refresh_token']!);
  }

  Future<Map<String, String?>> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final refreshToken = prefs.getString('refresh_token');
    return {'token': token, 'refresh_token': refreshToken};
  }

  Future<void> removeTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refresh_token');
  }
}