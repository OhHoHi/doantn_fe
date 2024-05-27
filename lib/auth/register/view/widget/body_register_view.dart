import 'package:doan_tn/auth/register/controller/register_provider.dart';
import 'package:doan_tn/base/widget/SkeletonTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../values/apppalette.dart';
import '../../../../values/colors.dart';
import '../../../login/view/widget/app_bar_login_widget.dart';

class BodyRegister extends StatefulWidget {
  const BodyRegister({Key? key}) : super(key: key);

  @override
  State<BodyRegister> createState() => _BodyRegisterState();
}

class _BodyRegisterState extends State<BodyRegister> {
  final _formKey = GlobalKey<FormState>();

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

  bool isEmailValid(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void validateAndRegister(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final fullName = _fullNameController.text.trim();
      final userName = _userNameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      registerProvider.register(context, fullName, userName, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonTab(
      title: 'Đăng ký',
      bodyWidgets: Selector<RegisterProvider, Status>(
        builder: (context, value, child) {
          if (value == Status.loading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.show();
            });
            print('Bắt đầu load');
          } else if (value == Status.loaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              ProgressHUD.of(context)?.dismiss();
            });
            print("Load thành công");
            print('Message chứa gì  ${registerProvider.message}');
          } else if (value == Status.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.dismiss();
              print('Load error');
              print('Message chứa gì  ${registerProvider.message}');
            });
          }
          return buildData(registerProvider);
        },
        selector: (context, pro) {
          return pro.statusRegister;
        },
      ),
      isBack: true,
    );
  }

  Widget buildData(RegisterProvider registerProvider) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _fullNameController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Họ và tên',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Họ và tên không được để trống';
                    }
                    return null;
                  },
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Địa chỉ email',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Địa chỉ email không được để trống';
                    }
                    if (!isEmailValid(value.trim())) {
                      return 'Địa chỉ email không hợp lệ';
                    }
                    return null;
                  },
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _userNameController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Tên đăng nhập',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Tên đăng nhập không được để trống';
                    }
                    return null;
                  },
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController,
                  maxLines: 1,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Mật khẩu',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mật khẩu không được để trống';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => validateAndRegister(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.buttonColor,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
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
      ),
    );
  }
}
