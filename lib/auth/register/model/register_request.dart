import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) => RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) => json.encode(data.toJson());

class RegisterRequest {
  String fullName;
  String userName;
  String email;
  String password;

  RegisterRequest({
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => RegisterRequest(
    fullName: json["full_name"],
    userName: json["user_name"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "user_name": userName,
    "email": email,
    "password": password,
  };
}