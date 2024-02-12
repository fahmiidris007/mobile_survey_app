import 'package:flutter/material.dart';
import 'package:mobile_survey_app/data/api/api_service.dart';
import 'package:mobile_survey_app/data/db/auth_repository.dart';
import 'package:mobile_survey_app/model/user.dart';
import 'package:mobile_survey_app/screen/home/home_screen.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  AuthProvider(this.authRepository, this.apiService);

  Future<bool> login(String nik, String password, bool rememberMe) async {
    try {
      final user = await apiService.login(nik, password);
      if (rememberMe) {
        await authRepository.saveUser(user, nik, password);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}