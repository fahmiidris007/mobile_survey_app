import 'dart:convert';

class User {
  String nik;
  String password;

  User({
    required this.nik,
    required this.password,
  });

  @override
  String toString() => 'User(email: $nik, password: $password)';

  Map<String, dynamic> toMap() {
    return {
      'nik': nik,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      nik: map['nik'],
      password: map['password'],
    );
  }
  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
