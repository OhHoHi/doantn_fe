import 'dart:convert';

import 'package:doan_tn/auth/login/model/user_response.dart';

List<NotifyResponse> notifyResponseFromJson(String str) => List<NotifyResponse>.from(json.decode(str).map((x) => NotifyResponse.fromJson(x)));

String notifyResponseToJson(List<NotifyResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotifyResponse {
  int id;
  String message;
  String sentDateTime;
  UserResponse user;

  NotifyResponse({
    required this.id,
    required this.message,
    required this.sentDateTime,
    required this.user,
  });

  factory NotifyResponse.fromJson(Map<String, dynamic> json) => NotifyResponse(
    id: json["id"],
    message: json["message"],
    sentDateTime: json["sentDateTime"],
    user: UserResponse.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "sentDateTime": sentDateTime,
    "user": user.toJson(),
  };
}
