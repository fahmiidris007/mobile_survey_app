import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String nik;
  String password;

  User({
    required this.nik,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    nik: json["nik"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "nik": nik,
    "password": password,
  };
}
