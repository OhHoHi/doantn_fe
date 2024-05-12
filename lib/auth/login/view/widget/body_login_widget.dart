
import 'package:doan_tn/home/home_admin/view/admin_page.dart';
import 'package:doan_tn/home/home_user/view/user_product_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../home/home_admin/view/admin_product_tab.dart';
import '../../../../home/home_user/view/user_page.dart';
import '../../../../values/assets.dart';
import '../../../../values/colors.dart';
import '../../../register/view/register_view.dart';
import '../../controller/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../../services/secure_storage.dart';
import 'app_bar_login_widget.dart';



class LoginBodyWidget extends StatefulWidget {
  const LoginBodyWidget({Key? key}) : super(key: key);

  @override
  State<LoginBodyWidget> createState() => _LoginBodyWidgetState();
}

class _LoginBodyWidgetState extends State<LoginBodyWidget> {

  bool _showPass = false;
  bool? _isChecked = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginProvider loginProvider;

  void onToggleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  @override
  void initState() {
    super.initState();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    saveAccount();
  }
  Future saveAccount() async {
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    // var keyName = sharedPreferences.getString('name');
    // var keyPassword = sharedPreferences.getString('password');
    var keyName = await SecureStorage().read('name');
    var keyPassword = await SecureStorage().read('password');
    setState(() {
      _usernameController.text = keyName ?? '';
      _passwordController.text = keyPassword ?? '';
      _isChecked = true;
    });
  }

    @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ProgressHUD(
          child: Builder(builder: (context){
            return Stack(
              children: [
                const SingleChildScrollView(child: AppBarLoginWidget()),
                Selector<LoginProvider, Status>(builder: (context, value, child) {
                  if (value == Status.loading) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ProgressHUD.of(context)?.show();
                    });
                    print('bat dau load');
                  } else if (value == Status.loaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      ProgressHUD.of(context)?.dismiss();
                      if (_isChecked == true) {
                        SecureStorage().write('name', _usernameController.text);
                        SecureStorage().write('password', _passwordController.text);
                      }else {
                        SecureStorage().delete('name');
                        SecureStorage().delete('password');
                      }
                      if(loginProvider.checkAdmin!){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => AdminPage(
                              selectedIndex: 0,
                              // data: loginProvider.user!,
                            )));
                       // _navigatorToAdminPage(context);
                        print('load thanh cong');
                      }
                      else{
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => UserPage(
                              selectedIndex: 0,
                              // data: loginProvider.user!,
                            )));
                       // _navigatorToUserPage(context);
                        print('load thanh cong');
                      }
                    });
                  } else if (value == Status.error) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ProgressHUD.of(context)?.dismiss();
                    });
                    print('load erro');
                  }
                  return buildData(loginProvider);
                }, selector: (context, pro) {
                  return pro.statusLogin;
                }),
              ],
            );
          }),
        ),
      ),
    );
  }
  Widget buildData(LoginProvider provider){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
          reverse: true,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.04,
                right: size.width * 0.04,
              ),
              child: Container(
                margin: EdgeInsets.only(top: size.height * 0.35),
                //height: 430,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 24),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: ColorApp.textColor,
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nuntio",
                        ),
                      ),
                    ),
                    const SizedBox(height: 39,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:28 ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              SizedBox(width: 20,),
                              Text(
                                'Tên đăng nhập',
                                style: TextStyle(
                                    fontSize: 14, color: ColorApp.textColor , fontFamily: "Nuntio1",),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorApp.startColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            height: 51,
                            decoration: BoxDecoration(
                              color: ColorApp.textFieltColor,
                              borderRadius: BorderRadius.circular(25.5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: SvgPicture.asset(AppAssets.icoUser)
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 8,
                                  child: TextFormField(
                                    controller: _usernameController,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                    decoration: const InputDecoration(
                                        hintText: 'Nhập tên đăng nhập',
                                        hintStyle: TextStyle( fontFamily: "Nuntio1"),
                                        border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Row(
                            children: [
                              SizedBox(width: 20,),
                              Text(
                                'Mật khẩu',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorApp.textColor,
                                    fontFamily: "Nuntio1"
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorApp.startColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            height: 51,
                            decoration: BoxDecoration(
                              color: ColorApp.textFieltColor,
                              borderRadius: BorderRadius.circular(25.5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: SvgPicture.asset(AppAssets.icoLock)
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_showPass,
                                    decoration: const InputDecoration(
                                        hintText: 'Nhập mật khẩu',
                                        hintStyle: TextStyle( fontFamily: "Nuntio1"),
                                        border: InputBorder.none),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child:
                                    GestureDetector(
                                        onTap: () {
                                          onToggleShowPass();
                                        },
                                        child:
                                        SvgPicture.asset(AppAssets.icoEye))
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // SvgPicture.asset(AppAssets.icoDefault),
                                Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0), // Điều chỉnh bán kính để bo tròn góc
                                    ),
                                    value: false,
                                    activeColor: ColorApp.backgroundColor,
                                    onChanged: (bool? value) {
                                    }),
                                const Text(
                                  'Ghi nhớ tài khoản',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorApp.textColor,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30,),
                    GestureDetector(
                      onTap: () {
                        // if(_usernameController.text == "vanchuadau56@gmail.com"){
                        //   _checkAdmin = true;
                        // }
                        // else{
                        //   _checkAdmin = false;
                        // }
                        provider.login(context, _usernameController.text,
                            _passwordController.text);
                      },
                      child: Container(
                        height: 53,
                        margin: const EdgeInsets.only(left: 100, right: 100),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xff2F4674), Color(0xff0F1D31)],
                            ),
                          borderRadius: BorderRadius.circular(26.5),
                        ),
                        child: const Center(
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(color: Colors.white, fontSize: 24,
                              fontFamily: "Nuntio"
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => const RegisterView(
                            )));
                      },
                      child: const Text("Bạn chưa có tài khoản . Bấm vào đây", style: TextStyle(color: Colors.black , decoration: TextDecoration.underline , fontFamily: "Nuntio1"),)
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
