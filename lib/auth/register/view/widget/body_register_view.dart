import 'package:doan_tn/auth/register/controller/register_provider.dart';
import 'package:doan_tn/base/widget/SkeletonTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../values/apppalette.dart';
import '../../../login/view/widget/app_bar_login_widget.dart';

class BodyRegister extends StatefulWidget {
  const BodyRegister({Key? key}) : super(key: key);

  @override
  State<BodyRegister> createState() => _BodyRegisterState();
}

class _BodyRegisterState extends State<BodyRegister> {

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late RegisterProvider registerProvider;

  @override
  void initState() {
    super.initState();
    registerProvider = Provider.of<RegisterProvider>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {
    return SkeletonTab(
        title: 'Đăng ký',
        bodyWidgets:
        Selector<RegisterProvider, Status>(builder: (context, value, child) {
          if (value == Status.loading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.show();
            });
            print('Bat dau load');
          } else if (value == Status.loaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              ProgressHUD.of(context)?.dismiss();
            });
            print("load thanh cong");
            print('message chứa gì  ${registerProvider.message}');

          } else if (value == Status.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.dismiss();
              print('Load error r');
              print('message chứa gì  ${registerProvider.message}');

            });
          }
          return buildData(registerProvider);
        }, selector: (context, pro) {
          return pro.statusRegister;
        }),
        isBack: true);

  }

  Widget buildData(RegisterProvider registerProvider) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
             Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _fullNameController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Họ và tên',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor)),
              ),
            ),
             Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _emailController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Địa chỉ email',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor)),
              ),
            ),
             Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _userNameController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Tên đăng nhập',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor)),
              ),
            ),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _passwordController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Mật khẩu',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor)),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                  registerProvider.register(context, _fullNameController.text,
                      _userNameController.text , _emailController.text , _passwordController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.green3Color,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Đăng ký',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
    //   SingleChildScrollView(
    //   reverse: true,
    //   child: Center(
    //     child: Padding(
    //       padding: EdgeInsets.only(
    //         left: size.width * 0.04,
    //         right: size.width * 0.04,
    //       ),
    //       child: Container(
    //         padding: EdgeInsets.only(top: size.height * 0.45),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Container(
    //               padding: EdgeInsets.only(top: 24),
    //               child: const Text(
    //                 'Đăng ký',
    //                 style: TextStyle(
    //                   color: ColorApp.textColor,
    //                   fontSize: 20,
    //                   fontWeight: FontWeight.w600,
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(left: 10),
    //               height: 40,
    //               decoration: BoxDecoration(
    //                 color: ColorApp.textFieltColor,
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //               child: Row(
    //                 children: [
    //                   Expanded(
    //                       flex: 1,
    //                       child: SvgPicture.asset(AppAssets.icoUser)
    //                   ),
    //                   const SizedBox(
    //                     width: 8,
    //                   ),
    //                   Expanded(
    //                     flex: 8,
    //                     child: TextFormField(
    //                       controller: _fullNameController,
    //                       style: const TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w400),
    //                       decoration: const InputDecoration(
    //                           hintText: 'full name',
    //                           border: InputBorder.none),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(left: 10),
    //               height: 40,
    //               decoration: BoxDecoration(
    //                 color: ColorApp.textFieltColor,
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //               child: Row(
    //                 children: [
    //                   Expanded(
    //                       flex: 1,
    //                       child: SvgPicture.asset(AppAssets.icoUser)
    //                   ),
    //                   const SizedBox(
    //                     width: 8,
    //                   ),
    //                   Expanded(
    //                     flex: 8,
    //                     child: TextFormField(
    //                       controller: _userNameController,
    //                       style: const TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w400),
    //                       decoration: const InputDecoration(
    //                           hintText: 'user name',
    //                           border: InputBorder.none),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(left: 10),
    //               height: 54
    //               ,
    //               decoration: BoxDecoration(
    //                 color: ColorApp.textFieltColor,
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //               child: Row(
    //                 children: [
    //                   Expanded(
    //                       flex: 1,
    //                       child: SvgPicture.asset(AppAssets.icoUser)
    //                   ),
    //                   const SizedBox(
    //                     width: 8,
    //                   ),
    //                   Expanded(
    //                     flex: 8,
    //                     child: TextFormField(
    //                       controller: _emailController,
    //                       style: const TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w400),
    //                       decoration: const InputDecoration(
    //                           hintText: 'Nhập email',
    //                           border: InputBorder.none),
    //                       validator: (email){
    //                         if(email!.isEmpty){
    //                           return 'Vui lòng nhập email';
    //                         }
    //                         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    //                           return 'Email không hợp lệ';
    //                         }
    //                         return null;
    //                       },
    //                       autovalidateMode: AutovalidateMode.onUserInteraction,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(left: 10),
    //               height: 40,
    //               decoration: BoxDecoration(
    //                 color: ColorApp.textFieltColor,
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //               child: Row(
    //                 children: [
    //                   Expanded(
    //                       flex: 1,
    //                       child: SvgPicture.asset(AppAssets.icoUser)
    //                   ),
    //                   const SizedBox(
    //                     width: 8,
    //                   ),
    //                   Expanded(
    //                     flex: 8,
    //                     child: TextFormField(
    //                       controller: _passwordController,
    //                       style: const TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.w400),
    //                       decoration: const InputDecoration(
    //                           hintText: 'Nhập password',
    //                           border: InputBorder.none),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             GestureDetector(
    //               onTap: () {
    //                 registerProvider.register(context, _fullNameController.text,
    //                     _userNameController.text , _emailController.text , _passwordController.text);
    //               },
    //               child: Container(
    //                 height: 40,
    //                 margin: EdgeInsets.only(left: 19, right: 19),
    //                 decoration: BoxDecoration(
    //                   color: ColorApp.buttonColor,
    //                   borderRadius: BorderRadius.circular(10),
    //                 ),
    //                 child: const Center(
    //                   child: Text(
    //                     'Đăng ký',
    //                     style: TextStyle(color: Colors.white, fontSize: 16),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //
    //             const SizedBox(
    //               height: 8,
    //             ),
    //             GestureDetector(
    //               onTap: () {
    //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
    //                     builder: (_) => const LoginScreen(
    //                     )));
    //               },
    //               child: Container(
    //                 height: 40,
    //                 margin: EdgeInsets.only(left: 19, right: 19),
    //                 decoration: BoxDecoration(
    //                   color: ColorApp.buttonColor,
    //                   borderRadius: BorderRadius.circular(10),
    //                 ),
    //                 child: const Center(
    //                   child: Text(
    //                     'Quay lại đăng nhập',
    //                     style: TextStyle(color: Colors.white, fontSize: 16),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
