
import 'package:shared_preferences/shared_preferences.dart';
import '../../../base/services/base_service.dart';
import '../../../base/services/services_url.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import 'package:dio/dio.dart';

class LoginServices extends BaseService {
  LoginServices(Dio client) : super(client);
  String? token;
  Future<LoginResponse> postLogin({required LoginRequest request}) async {
    final result = await client.fetch<Map<String, dynamic>>(
        setStreamType<LoginResponse>(Options(
          method: 'POST',
        ).compose(client.options, ServicesUrl.postLogin, data: {
          'email': request.email,
          'password': request.password
        })));
    token = result.data!['token'];
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token!);
    print('----------------------token before : $token');
    return LoginResponse.fromJson(result.data!);
  }
}