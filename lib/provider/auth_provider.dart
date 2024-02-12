import 'package:flutter/material.dart';
import 'package:mobile_survey_app/data/api/api_service.dart';
import 'package:mobile_survey_app/data/db/auth_repository.dart';

enum ResultState { loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  AuthProvider(this.authRepository, this.apiService);

  ResultState _state = ResultState.loading;
  ResultState get state => _state;
  String _message = '';
  String get message => _message;
  String _token = '';
  String get token => _token;

  Future<dynamic> login(String nik, String password, bool rememberMe) async {
    _state = ResultState.loading;
    notifyListeners();
    try {
      final tokens = await apiService.login(nik, password);
      if (rememberMe) {
        await authRepository.saveTokens(tokens);
      }
      _state = ResultState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error \n$e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> autoLogin() async {
    _state = ResultState.loading;
    notifyListeners();
    final tokens = await authRepository.getTokens();
    if (tokens['token'] != null) {
      _token = tokens['token']!;
      _state = ResultState.success;
      notifyListeners();
      return true;
    } else {
      _state = ResultState.error;
      notifyListeners();
      return false;
    }
  }}