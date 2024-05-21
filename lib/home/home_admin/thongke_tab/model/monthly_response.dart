import 'dart:convert';

List<MonthlyResponse> monthlyResponseFromJson(String str) => List<MonthlyResponse>.from(json.decode(str).map((x) => MonthlyResponse.fromJson(x)));

String monthlyResponseToJson(List<MonthlyResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MonthlyResponse {
  int month;
  int year;
  int revenue;

  MonthlyResponse({
    required this.month,
    required this.year,
    required this.revenue,
  });

  factory MonthlyResponse.fromJson(Map<String, dynamic> json) => MonthlyResponse(
    month: json["month"],
    year: json["year"],
    revenue: json["revenue"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "year": year,
    "revenue": revenue,
  };
}
