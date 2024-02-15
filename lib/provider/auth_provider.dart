import 'package:flutter/material.dart';
import 'package:mobile_survey_app/data/api/api_service.dart';
import 'package:mobile_survey_app/data/db/auth_repository.dart';
import 'package:mobile_survey_app/model/user.dart';

enum ResultState { loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  AuthProvider(this.authRepository, this.apiService);

  ResultState _state = ResultState.loading;
  ResultState get state => _state;
  String _message = '';
  String get message => _message;
  final String _token = '';
  String get token => _token;

  Future<dynamic> login(String nik, String password, bool rememberMe) async {
    _state = ResultState.loading;
    notifyListeners();
    try {
      final tokens = await apiService.login(nik, password);
      await authRepository.saveTokens(tokens);
      if (rememberMe) {
        await authRepository.saveUser(User(nik: nik, password: password));
      }
      _state = ResultState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ResultState.error;
      _message = 'Login error, please try again later';
      notifyListeners();
      return false;
    }
  }

  Future<bool> autoLogin() async {
    _state = ResultState.loading;
    notifyListeners();
    final user = await authRepository.getUser();
    if (user != null) {
      return await login(user.nik, user.password, false);
    } else {
      _state = ResultState.error;
      notifyListeners();
      return false;
    }
  }
}
