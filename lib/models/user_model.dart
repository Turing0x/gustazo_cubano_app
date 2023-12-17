import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String id;
  final bool enable;
  final String username;
  final String password;
  final String role;
  final String referalCode;
  final List<dynamic> shoppingHistory;

  User({
    required this.id,
    required this.enable,
    required this.username,
    required this.password,
    required this.role,
    required this.referalCode,
    required this.shoppingHistory,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    enable: json["enable"],
    username: json["username"],
    password: json["password"],
    role: json["role"],
    referalCode: json["referal_code"],
    shoppingHistory: List<dynamic>.from(json["shopping_history"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "enable": enable,
    "username": username,
    "password": password,
    "role": role,
    "referal_code": referalCode,
    "shopping_history": List<dynamic>.from(shoppingHistory.map((x) => x)),
  };
}
