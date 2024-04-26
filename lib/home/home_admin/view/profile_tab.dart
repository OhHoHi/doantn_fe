import 'package:flutter/material.dart';

import '../../../base/widget/SkeletonTab.dart';
import '../../../values/apppalette.dart';


class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.userModel});

  final UserModel userModel;

  void _logout(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonTab(
        title: 'Thông tin người dùng',
        bodyWidgets: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userModel.avtUrl),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                userModel.userName,
                style:
                const TextStyle(color: AppPalette.textColor, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                userModel.email,
                style:
                const TextStyle(color: AppPalette.textColor, fontSize: 18),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.green3Color,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    minimumSize: const Size(250, 40),
                  ),
                  child: const Text(
                    'Chỉnh sửa thông tin người dùng',
                    style: TextStyle(fontSize: 16),
                  )),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                    onPressed: () {
                      _logout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      minimumSize: const Size(200, 50),
                    ),
                    child: const Text(
                      'Đăng xuất',
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ],
          ),
        ),
        isBack: false);
  }
}

class UserModel {
  final String firstName;
  final String userName;
  final String passWord;
  final String email;
  final String avtUrl;

  UserModel(
      {required this.firstName,
        required this.userName,
        required this.passWord,
        required this.email,
        required this.avtUrl});
}

UserModel user = UserModel(
    firstName: 'quyet ngu',
    userName: 'quyet ngu',
    passWord: 'passWord',
    email: "email@gmail.com",
    avtUrl: 'https://cdn-icons-png.flaticon.com/512/3607/3607444.png');

UserModel admin = UserModel(
    firstName: 'Admin',
    userName: 'Admin',
    passWord: 'passWord',
    email: "email@gmail.com",
    avtUrl: 'https://cdn-icons-png.flaticon.com/512/3607/3607444.png');
