import 'package:doan_tn/auth/login/model/user_response.dart';
import 'package:doan_tn/auth/login/services/user_srvices.dart';
import 'package:flutter/material.dart';
import '../../../base/controler/base_provider.dart';
import '../../../base/services/dio_option.dart';
import '../../../base/widget/dialog_base.dart';
import '../../../values/assets.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import '../model/test_luu_user.dart';
import '../services/login_services.dart';
import 'package:dio/dio.dart';

class UserProvider extends BaseProvider<UserServices> {
  UserProvider(UserServices service) : super(service);

  Status statusUser = Status.none;
  Status statusPass = Status.none;
  Status statusEdit = Status.none;


  bool? checkPass;
  bool? checkEdit;
  UserResponse userResponse = UserResponse(
      id: 0, fullName: '',
      userName: '',
      email: '',
      password: '',
      roles: [],
      enabled: false,
      username: '',
      authorities: [],
      accountNonLocked: false,
      credentialsNonExpired: false,
      accountNonExpired: false);


  Future<void> getUser(int id) async {
    resetStatus();
    try {
      startLoading((){
        statusUser = Status.loading;
      });
      //startLoading();
      userResponse = await service.getUser(id);
      finishLoading((){
        statusUser = Status.loaded;
      });
      // finishLoading();
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusUser = Status.error;
      });
    }
  }
  Future<void> password(int id ,String oldPass , String newPass) async {
    resetStatus();
    try {
      startLoading((){
        statusPass = Status.loading;
      });
      //startLoading();
      checkPass = await service.password(id , oldPass , newPass);
      if(checkPass == true){
        finishLoading((){
          statusPass = Status.loaded;
        });
      }
      else{
        receivedError((){
          statusPass = Status.error;
        });
      }
      // finishLoading();
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusPass = Status.error;
      });
    }
  }

  Future<void> editUser(int id ,String fullName , String email , String userName) async {
    resetStatus();
    try {
      startLoading((){
        statusEdit = Status.loading;
      });
      //startLoading();
      checkEdit = await service.editUser(id , fullName , email ,userName);
      if(checkPass == true){
        finishLoading((){
          statusEdit = Status.loaded;
        });
      }
      else{
        receivedError((){
          statusEdit = Status.error;
        });
      }
      // finishLoading();
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusEdit = Status.error;
      });
    }
  }
}