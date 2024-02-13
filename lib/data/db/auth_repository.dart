import 'package:mobile_survey_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<void> saveUser(User user, String nik, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nik', nik);
    await prefs.setString('password', password);
  }

  Future<Data?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik');
    final password = prefs.getString('password');

    if (nik != null && password != null) {
      return Data(
        userId: '',
        nik: nik,
        password: password,
        systemRoleId: 0,
        systemRole: '',
        name: '',
        email: '',
        phone: '',
        departementId: '',
        departement: '',
        siteLocationId: '',
        siteLocation: '',
      );
    } else {
      return null;
    }
  }
}