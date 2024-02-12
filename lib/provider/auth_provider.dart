import 'package:flutter/material.dart';
import 'package:mobile_survey_app/data/api/api_service.dart';
import 'package:mobile_survey_app/data/db/auth_repository.dart';

enum ResultState { loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  AuthProvider(this.authRepository, this.apiService);

  Future<bool> login(String nik, String password, bool rememberMe) async {
    _state = ResultState.loading;
    notifyListeners();
    try {
      final user = await apiService.login(nik, password);
      if (rememberMe) {
        await authRepository.saveUser(user, nik, password);
      }
      _state = ResultState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> autoLogin() async {
    _state = ResultState.loading;
    notifyListeners();
    final user = await authRepository.getUser();
    if (user != null) {
      final success = await login(user.nik, user.password!, true);
      _state = success ? ResultState.success : ResultState.error;
      notifyListeners();
      return success;
    } else {
      _state = ResultState.error;
      notifyListeners();
      return false;
    }
  }
}