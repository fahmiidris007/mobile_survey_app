import 'dart:convert';

PostSurvey postSurveyFromJson(String str) =>
    PostSurvey.fromJson(json.decode(str));

String postSurveyToJson(PostSurvey data) => json.encode(data.toJson());

class PostSurvey {
  String assessmentId;
  String nikParticipant;
  List<Answer> answers;
  bool status;

  PostSurvey({
    required this.assessmentId,
    required this.nikParticipant,
    required this.answers,
    this.status = false,
  });

  factory PostSurvey.fromJson(Map<String, dynamic> json) => PostSurvey(
        assessmentId: json["assessment_id"] ?? '',
        nikParticipant: json["nik_participant"] ?? '',
        answers: json["answers"] != null
            ? List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x)))
            : [],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "assessment_id": assessmentId,
        "nik_participant": nikParticipant,
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
        "status": status,
      };
}

class Answer {
  String questionId;
  String answer;

  Answer({
    required this.questionId,
    required this.answer,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        questionId: json["question_id"] ?? '',
        answer: json["answer"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "answer": answer,
      };
}
