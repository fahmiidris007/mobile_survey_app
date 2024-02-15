import 'package:flutter/material.dart';
import 'package:mobile_survey_app/data/api/api_service.dart';
import 'package:mobile_survey_app/data/db/auth_repository.dart';
import 'package:mobile_survey_app/model/post_survey.dart';

enum PostResultState { loading, noData, success, error }

class PostSurveyProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthRepository authRepository;

  PostSurveyProvider(this.apiService, this.authRepository);

  PostResultState _state = PostResultState.loading;

  PostResultState get state => _state;
  String _message = '';

  String get message => _message;

  Future<dynamic> postSurvey(String id, String nik, List<Answer> answer) async {
    _state = PostResultState.loading;
    notifyListeners();
    try {
      final tokens = await authRepository.getTokens();
      if (tokens['token'] != null) {
        final survey =
            await apiService.postSurvey(tokens['token']!, id, nik, answer);
        if (survey.status == true) {
          _state = PostResultState.success;
          notifyListeners();
          return _message =
              'Your survey has been submitted, thank you for your participation';
        } else {
          _state = PostResultState.noData;
          _message = 'Please answer all questions';
          notifyListeners();
          return true;
        }
      } else {
        _state = PostResultState.error;
        notifyListeners();
        return _message = 'No token found';
      }
    } catch (e) {
      _state = PostResultState.error;
      notifyListeners();
      print(e);
      return _message = 'Error \n$e';
    }
  }
}
