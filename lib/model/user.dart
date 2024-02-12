import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  int code;
  bool status;
  String message;
  Data data;

  User({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
  String userId;
  String nik;
  int systemRoleId;
  String systemRole;
  String name;
  String email;
  String phone;
  String departementId;
  String departement;
  String siteLocationId;
  String siteLocation;

  Data({
    required this.userId,
    required this.nik,
    required this.systemRoleId,
    required this.systemRole,
    required this.name,
    required this.email,
    required this.phone,
    required this.departementId,
    required this.departement,
    required this.siteLocationId,
    required this.siteLocation,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    nik: json["nik"],
    systemRoleId: json["system_role_id"],
    systemRole: json["system_role"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    departementId: json["departement_id"],
    departement: json["departement"],
    siteLocationId: json["site_location_id"],
    siteLocation: json["site_location"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "nik": nik,
    "system_role_id": systemRoleId,
    "system_role": systemRole,
    "name": name,
    "email": email,
    "phone": phone,
    "departement_id": departementId,
    "departement": departement,
    "site_location_id": siteLocationId,
    "site_location": siteLocation,
  };
}
