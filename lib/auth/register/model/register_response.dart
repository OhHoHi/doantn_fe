import 'dart:convert';

class RegisterResponse {
  bool success;

  RegisterResponse({required this.success});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(success: true); // Giả sử đăng ký thành công nếu không có phản hồi từ server
  }
}
