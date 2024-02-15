import 'dart:convert';

Survey surveyFromJson(String str) => Survey.fromJson(json.decode(str));

String surveyToJson(Survey data) => json.encode(data.toJson());

class Survey {
  int code;
  bool status;
  int page;
  int count;
  int totalData;
  String message;
  List<Datum> data;

  Survey({
    required this.code,
    required this.status,
    required this.page,
    required this.count,
    required this.totalData,
    required this.message,
    required this.data,
  });

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        code: json["code"],
        status: json["status"],
        page: json["page"],
        count: json["count"],
        totalData: json["total_data"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "page": page,
        "count": count,
        "total_data": totalData,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String name;
  DateTime assessmentDate;
  String description;
  Type type;
  int roleAssessor;
  Role roleAssessorName;
  int roleParticipant;
  RoleParticipantName roleParticipantName;
  String departementId;
  String departementName;
  String siteLocationId;
  SiteLocationName siteLocationName;
  String image;
  List<Participant> participants;
  dynamic assessors;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic downloadedAt;
  bool hasResponses;

  Datum({
    required this.id,
    required this.name,
    required this.assessmentDate,
    required this.description,
    required this.type,
    required this.roleAssessor,
    required this.roleAssessorName,
    required this.roleParticipant,
    required this.roleParticipantName,
    required this.departementId,
    required this.departementName,
    required this.siteLocationId,
    required this.siteLocationName,
    required this.image,
    required this.participants,
    required this.assessors,
    required this.createdAt,
    required this.updatedAt,
    required this.downloadedAt,
    required this.hasResponses,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        assessmentDate: DateTime.parse(json["assessment_date"]),
        description: json["description"],
        type: typeValues.map[json["type"]]!,
        roleAssessor: json["role_assessor"],
        roleAssessorName: roleValues.map[json["role_assessor_name"]]!,
        roleParticipant: json["role_participant"],
        roleParticipantName:
            roleParticipantNameValues.map[json["role_participant_name"]]!,
        departementId: json["departement_id"],
        departementName: json["departement_name"],
        siteLocationId: json["site_location_id"],
        siteLocationName:
            siteLocationNameValues.map[json["site_location_name"]]!,
        image: json["image"],
        participants: json["participants"] == null
            ? []
            : List<Participant>.from(
                json["participants"]!.map((x) => Participant.fromJson(x))),
        assessors: json["assessors"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        downloadedAt: json["downloaded_at"],
        hasResponses: json["has_responses"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "assessment_date": assessmentDate.toIso8601String(),
        "description": description,
        "type": typeValues.reverse[type],
        "role_assessor": roleAssessor,
        "role_assessor_name": roleValues.reverse[roleAssessorName],
        "role_participant": roleParticipant,
        "role_participant_name":
            roleParticipantNameValues.reverse[roleParticipantName],
        "departement_id": departementId,
        "departement_name": departementName,
        "site_location_id": siteLocationId,
        "site_location_name": siteLocationNameValues.reverse[siteLocationName],
        "image": image,
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "assessors": assessors,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "downloaded_at": downloadedAt,
        "has_responses": hasResponses,
      };
}

class Participant {
  String nik;
  String name;
  String departement;
  String departementId;
  Role role;
  int roleId;
  String siteLocation;
  String siteLocationId;
  int totalAssessment;
  DateTime lastAssessment;
  String imageProfile;
  DateTime createdAt;

  Participant({
    required this.nik,
    required this.name,
    required this.departement,
    required this.departementId,
    required this.role,
    required this.roleId,
    required this.siteLocation,
    required this.siteLocationId,
    required this.totalAssessment,
    required this.lastAssessment,
    required this.imageProfile,
    required this.createdAt,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        nik: json["nik"],
        name: json["name"],
        departement: json["departement"],
        departementId: json["departement_id"],
        role: roleValues.map[json["role"]]!,
        roleId: json["role_id"],
        siteLocation: json["site_location"],
        siteLocationId: json["site_location_id"],
        totalAssessment: json["total_assessment"],
        lastAssessment: DateTime.parse(json["last_assessment"]),
        imageProfile: json["image_profile"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "name": name,
        "departement": departement,
        "departement_id": departementId,
        "role": roleValues.reverse[role],
        "role_id": roleId,
        "site_location": siteLocation,
        "site_location_id": siteLocationId,
        "total_assessment": totalAssessment,
        "last_assessment": lastAssessment.toIso8601String(),
        "image_profile": imageProfile,
        "created_at": createdAt.toIso8601String(),
      };
}

enum Role { EMPTY, SUPERINTENDENT, SUPERVISOR }

final roleValues = EnumValues({
  "": Role.EMPTY,
  "Superintendent": Role.SUPERINTENDENT,
  "Supervisor": Role.SUPERVISOR
});

enum RoleParticipantName { EMPTY, FOREMAN, SUPERVISOR }

final roleParticipantNameValues = EnumValues({
  "": RoleParticipantName.EMPTY,
  "Foreman": RoleParticipantName.FOREMAN,
  "Supervisor": RoleParticipantName.SUPERVISOR
});

enum SiteLocationName { EMPTY, THE_037_C_KEL }

final siteLocationNameValues = EnumValues(
    {"": SiteLocationName.EMPTY, "037C KEL": SiteLocationName.THE_037_C_KEL});

enum Type { AT_FIELD }

final typeValues = EnumValues({"at_field": Type.AT_FIELD});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
