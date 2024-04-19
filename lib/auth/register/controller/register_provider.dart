import 'package:dio/dio.dart';
import 'package:doan_tn/auth/register/model/register_request.dart';
import 'package:doan_tn/auth/register/model/register_response.dart';
import 'package:doan_tn/auth/register/services/register_services.dart';
import 'package:doan_tn/base/controler/base_provider.dart';
import 'package:flutter/material.dart';

import '../../../base/services/dio_option.dart';
import '../../../base/widget/dialog_base.dart';
import '../../../values/assets.dart';

class RegisterProvider extends BaseProvider<RegisterService>{
  RegisterProvider(RegisterService servide) : super(servide);



  Status statusRegister = Status.none;

  RegisterResponse? response;
  String? message ;
  bool? checkthanhcong;


  Future<void> register( BuildContext context , String fullName , String userName , String email , String password)async {
    resetStatus();
    try{
      startLoading(() {
        statusRegister = Status.loading;
      });
     // startLoading();
      checkthanhcong  = await service.postRegister(request: RegisterRequest(fullName: fullName, userName: userName, email: email, password: password));
    // message = response;

      if(checkthanhcong == true){
        finishLoading(() {
          statusRegister = Status.loaded;
        });
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content: 'Đăng ký thành công',
                icon: AppAssets.icoDefault,
                button: true,
              );
            });
      }
      else{
        receivedError(() {
          statusRegister = Status.error;
        });
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content:'Đã có lỗi sảy ra , hãy check lại',
                icon: AppAssets.icoDefault,
                button: true,
              );
            });
      }

      //finishLoading();
    }
    on DioException catch(e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusRegister = Status.error;
      });
      // receivedError();
      showDialog(
          context: context,
          builder: (context) {
            return DialogBase(
              title: 'Thông báo',
              content:'loi',
              icon: AppAssets.icoDefault,
              button: true,
            );
          });

    }
  }


}