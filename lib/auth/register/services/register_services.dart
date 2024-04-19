
import 'package:doan_tn/auth/register/model/register_request.dart';
import 'package:doan_tn/auth/register/model/register_response.dart';
import '../../../base/services/base_service.dart';
import '../../../base/services/services_url.dart';
import 'package:dio/dio.dart';

class RegisterService extends BaseService {
  RegisterService(Dio client) : super(client);

  Future<bool> postRegister({required RegisterRequest request}) async {
    try {
      // Gửi yêu cầu đăng ký và không xử lý phản hồi từ server
          await client.post(
            ServicesUrl.postRegister,
            data: {
              'full_name': request.fullName,
              'user_name': request.userName,
              'email': request.email,
              'password': request.password,
            },
          );
      // Nếu không có lỗi, đăng ký được coi là thành công
      return true;
    } catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }



  //   Future<String> postRegister({required RegisterRequest request}) async {
  //   try {
  //     final result = await client.fetch<Map<String, dynamic>>(
  //       setStreamType<String>(
  //         Options(
  //           method: 'POST',
  //         ).compose(client.options, ServicesUrl.postRegister, data: {
  //           'full_name': request.fullName,
  //           'user_name': request.userName,
  //           'email': request.email,
  //           'password': request.password
  //         }),
  //       ),
  //     );
  //     if (result.statusCode == 200) {
  //       // Trả về thông báo thành công từ server
  //       return 'Đăng ký thành công';
  //     } else if (result.statusCode == 500) {
  //       // Trả về thông báo lỗi từ server
  //       return 'Email đã tồn tại';
  //     } else if (result.statusCode == 400) {
  //       // Trả về thông báo lỗi từ server
  //       return 'Hãy điền đầy đủ thông tin';
  //     } else {
  //       // Xử lý các trường hợp khác nếu cần
  //       return 'Unexpected response from server';
  //     }
  //   } catch (e) {
  //     // Xử lý lỗi nếu có
  //     return 'Failed to communicate with the server';
  //   }
  }
}

