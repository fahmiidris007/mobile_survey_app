import 'package:mobile_survey_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<void> saveUser(User user, String nik, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nik', nik);
    await prefs.setString('password', password);
  }
}