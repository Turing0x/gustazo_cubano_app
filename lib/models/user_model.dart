import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String id;
  final bool enable;
  final String username;
  final String password;
  final String role;
  final String commercialCode;
  final PersonalInfo personalInfo;

  User({
    required this.id,
    required this.enable,
    required this.username,
    required this.password,
    required this.role,
    required this.commercialCode,
    required this.personalInfo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    enable: json["enable"],
    username: json["username"],
    password: json["password"],
    role: json["role"],
    commercialCode: json["commercial_code"],
    personalInfo: PersonalInfo.fromJson(json["personal_info"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "enable": enable,
    "username": username,
    "password": password,
    "role": role,
    "commercial_code": commercialCode,
    "personal_info": personalInfo.toJson(),
  };
}

class PersonalInfo {
  final String ci;
  final String fullName;
  final String address;
  final String phone;

  PersonalInfo({
    required this.ci,
    required this.fullName,
    required this.address,
    required this.phone,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
    ci: json["ci"],
    fullName: json["full_name"],
    address: json["address"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "ci": ci,
    "full_name": fullName,
    "address": address,
    "phone": phone,
  };
}
