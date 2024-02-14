import 'dart:convert';

DetailSurvey surveyTestFromJson(String str) => DetailSurvey.fromJson(json.decode(str));

String surveyTestToJson(DetailSurvey data) => json.encode(data.toJson());

class DetailSurvey {
  int code;
  bool status;
  String message;
  Data data;

  DetailSurvey({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory DetailSurvey.fromJson(Map<String, dynamic> json) => DetailSurvey(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  String name;
  List<Question> question;

  Data({
    required this.id,
    required this.name,
    required this.question,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    question: List<Question>.from(json["question"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "question": List<dynamic>.from(question.map((x) => x.toJson())),
  };
}

class Question {
  String questionid;
  String section;
  String number;
  String type;
  String questionName;
  bool scoring;
  List<Option> options;

  Question({
    required this.questionid,
    required this.section,
    required this.number,
    required this.type,
    required this.questionName,
    required this.scoring,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    questionid: json["questionid"],
    section: json["section"],
    number: json["number"],
    type: json["type"],
    questionName: json["question_name"],
    scoring: json["scoring"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "questionid": questionid,
    "section": section,
    "number": number,
    "type": type,
    "question_name": questionName,
    "scoring": scoring,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class Option {
  String optionid;
  String optionName;
  int points;
  int flag;

  Option({
    required this.optionid,
    required this.optionName,
    required this.points,
    required this.flag,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    optionid: json["optionid"],
    optionName: json["option_name"],
    points: json["points"],
    flag: json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "optionid": optionid,
    "option_name": optionName,
    "points": points,
    "flag": flag,
  };
}
