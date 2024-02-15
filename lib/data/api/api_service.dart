import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mobile_survey_app/model/post_survey.dart';
import 'package:mobile_survey_app/model/survey.dart';
import 'package:mobile_survey_app/model/detail_survey.dart';
import 'package:mobile_survey_app/model/user.dart';

class ApiService {
  static const String baseUrl = 'https://dev-api-lms.apps-madhani.com/v1';

  Future<Map<String, String>> login(String nik, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

      },
      body: jsonEncode(<String, String>{
        'nik': nik,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      String rawCookie = response.headers['set-cookie']!;
      final cookieList = rawCookie.split(';');
      final Map<String, String> tokens = {};
      for (var cookie in cookieList) {
        if (cookie.contains('refresh_token=')) {
          tokens['refresh_token'] = cookie.split('refresh_token=')[1];
        } else if (cookie.contains('token=')) {
          tokens['token'] = cookie.split('token=')[1];
        }
      }
      return tokens;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Survey> getSurvey(String token) async {
    final url = Uri.parse('$baseUrl/assessments?page=1&limit=10');
    final response = await http.get(url,headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': 'token=$token',
    },);

    if (response.statusCode == 200) {
      return Survey.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load survey');
    }
  }

  Future<DetailSurvey> getDetailSurvey(String token, String assessment_id) async {
    final url = Uri.parse('$baseUrl/assessments/question/$assessment_id');
    final response = await http.get(url,headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': 'token=$token',
    },);

    print('assessment_id: $assessment_id');
    print('url: $url');

    if (response.statusCode == 200) {
      return DetailSurvey.fromJson(json.decode(response.body));
    } else {
      print('Failed to load detail survey. Status code: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to load detail survey');
    }
  }

  Future<PostSurvey> postSurvey(String token, String assessmentId, String nikParticipant, List<Answer> answers) async {
    final url = Uri.parse('$baseUrl/assessments/send-answer');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'token=$token',
      },
      body: jsonEncode(<String, dynamic>{
        'assessment_id': assessmentId,
        'nik_participant': nikParticipant,
        'answers': answers.map((e) => e.toJson()).toList(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Success to post survey. response.body: ${response.body}');
      return PostSurvey.fromJson(json.decode(response.body));
    } else {
      print('Failed to post survey. Status code: ${response.statusCode}, body: ${response.body}');
      throw Exception('Failed to post survey');
    }
  }
}