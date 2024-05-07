import 'package:doan_tn/auth/login/model/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../base/services/base_service.dart';
import '../../../base/services/services_url.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import 'package:dio/dio.dart';

class UserServices extends BaseService {
  UserServices(Dio client) : super(client);


  // Future<LoginResponse> getUser(int id) async {
  //   final result = await client.fetch<Map<String, dynamic>>(
  //       setStreamType<LoginResponse>(Options(
  //         method: 'GET',
  //       ).compose(client.options,)));
  //   return LoginResponse.fromJson(result.data!);
  // }

  Future<UserResponse> getUser(int id) async {
      final result =await client.get(
        "http://10.0.2.2:8080/api/v1/auth/$id",
      );
      return UserResponse.fromJson(result.data!);
  }

  Future<bool> password(int id , String oldPass , String newPass) async {
    try{
      await client.put(
        "http://10.0.2.2:8080/api/v1/auth/$id/password",
        data: {
          "oldPassword" : oldPass,
          "newPassword" : newPass
        }
      );
      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> editUser(int id , String fullName , String email , String userName) async {
    try{
      await client.put(
          "http://10.0.2.2:8080/api/v1/auth/edit/$id",
          data: {
            "fullName" : fullName,
            "email" : email,
            "userName" : userName,
          }
      );
      return true;
    }catch(e){
      return false;
    }
  }

}