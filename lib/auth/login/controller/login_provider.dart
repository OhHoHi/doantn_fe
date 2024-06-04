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

import '../services/secure_storage.dart';
import '../view/login_screen.dart';

class LoginProvider extends BaseProvider<LoginServices> {
  LoginProvider(LoginServices service) : super(service);
  LoginResponse? _user;
  LoginResponse? get user => _user;
  bool? checkAdmin;
  Status statusLogin = Status.none;
  void setUser(LoginResponse? user) {
    _user = user;
    notifyListeners();
  }
  void setUser1(LoginResponse? user) {
    TempUserStorage.currentUser = user;
    notifyListeners();
  }

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      startLoading(() {
        statusLogin = Status.loading;
      });
      final loginRequest = LoginRequest(email: email, password: password);
      final loginService = LoginServices(DioOption().createDio(addToken: false));
      final user = await loginService.postLogin(request: loginRequest);

      //setUser(user);
      setUser1(user);
      if(user.user.roles.first.name == "ROLE_ADMIN"){
        checkAdmin = true;
      }
      else {
        checkAdmin = false;
      }
      print("test o day ne ${user.user.roles.first.name}");
      finishLoading(() {
        statusLogin = Status.loaded;
      });
    } on DioException catch (e) {
      print(e.message);
      receivedError(() {
        statusLogin = Status.error;
      });
      showDialog(
          context: context,
          builder: (context) {
            return DialogBase(
              title: 'Thất bại',
              content: 'Thông tin tài khoản hoặc mật khẩu không chính xác',
              icon: AppAssets.icoFail,
              button: false,
            );
          });
    }
  }

  bool? isChecked = false;
  Future<void> logout(BuildContext context) async {

    if(isChecked == true){
      // Xóa thông tin người dùng khỏi SecureStorage
      await SecureStorage().delete('name');
      await SecureStorage().delete('password');
    }
    // Chuyển hướng người dùng về màn hình đăng nhập
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );

    // Thông báo cập nhật trạng thái (nếu cần)
    notifyListeners();
  }
}