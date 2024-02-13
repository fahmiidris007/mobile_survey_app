import 'package:flutter/material.dart';
import 'package:mobile_survey_app/data/api/api_service.dart';
import 'package:mobile_survey_app/data/db/auth_repository.dart';
import 'package:mobile_survey_app/model/survey.dart';

enum ResultState { loading, noData, success, error }

class SurveyProvider extends ChangeNotifier{
  final ApiService apiService;
  final AuthRepository authRepository;

  SurveyProvider(this.apiService, this.authRepository){
    fetchSurvey();
  }

  late Survey _listSurvey;
  late ResultState _state = ResultState.loading;
  String _message = '';
  String get message => _message;
  Survey get result => _listSurvey;
  ResultState get state => _state;

  Future<dynamic> fetchSurvey() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final tokens = await authRepository.getTokens();
      if (tokens['token'] != null) {
        final survey = await apiService.getSurvey(tokens['token']!);
        if (survey.data.isEmpty) {
          _state = ResultState.noData;
          notifyListeners();
          return _message = 'No Data';
        } else {
          _state = ResultState.success;
          notifyListeners();
          return _listSurvey = survey;
        }
      } else {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'No token found';
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error \n$e';
    }
  }

  Future<void> logout() async {
    await authRepository.removeTokens();
  }

  Future<void> removeUser() async{
    await authRepository.removeUser();
  }
}