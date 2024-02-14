import 'package:flutter/material.dart';
import 'package:mobile_survey_app/data/api/api_service.dart';
import 'package:mobile_survey_app/data/db/auth_repository.dart';
import 'package:mobile_survey_app/model/detail_survey.dart';

enum ResultState { loading, noData, success, error }

class SurveyTestProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthRepository authRepository;

  SurveyTestProvider(this.apiService, this.authRepository);

  late DetailSurvey _surveyTest;
  late ResultState _state = ResultState.loading;
  String _message = '';
  String get message => _message;
  DetailSurvey get result => _surveyTest;
  ResultState get state => _state;

  Future<dynamic> getDetailSurveyTest(String assessment_id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final tokens = await authRepository.getTokens();
      if (tokens['token'] != null) {
        final surveyTest = await apiService.getDetailSurvey(tokens['token']!, assessment_id);
        if (surveyTest.data == null) {
          _state = ResultState.noData;
          notifyListeners();
          return _message = 'No Data';
        } else {
          _state = ResultState.success;
          notifyListeners();
          return _surveyTest = surveyTest;
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

}