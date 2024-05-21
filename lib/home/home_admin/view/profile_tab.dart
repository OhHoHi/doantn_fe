import 'package:doan_tn/auth/login/controller/user_provider.dart';
import 'package:doan_tn/auth/login/model/user_response.dart';
import 'package:doan_tn/auth/login/services/user_srvices.dart';
import 'package:doan_tn/home/home_user/address/service/address_service.dart';
import 'package:doan_tn/home/home_user/pay/view/order_pay_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/login/model/login_response.dart';
import '../../../auth/login/model/test_luu_user.dart';
import '../../../base/controler/base_provider.dart';
import '../../../base/services/dio_option.dart';
import '../../../base/widget/SkeletonTab.dart';
import '../../../base/widget/dialog_base.dart';
import '../../../values/apppalette.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../../values/assets.dart';
import '../../../values/styles.dart';
import '../../home_user/address/controller/address_provider.dart';
import '../../home_user/address/model/address_response.dart';
import '../../home_user/address/view/address_screen.dart';
import '../../home_user/view/user_page.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) =>
                UserProvider(UserServices(DioOption().createDio())),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                AddressProvider(AddressService(DioOption().createDio())),
          ),
        ],
        child: const SkeletonTab(
            title: 'Thông tin người dùng',
            bodyWidgets: BodyProfileTab(),
            isBack: false));
  }
}

class BodyProfileTab extends StatefulWidget {
  const BodyProfileTab({Key? key}) : super(key: key);

  @override
  State<BodyProfileTab> createState() => _BodyProfileTabState();
}

class _BodyProfileTabState extends State<BodyProfileTab> {
  late UserProvider userProvider;
  late AddressProvider addressProvider ;
  late LoginResponse user;
  AddressResponse? selectedAddress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressProvider= Provider.of<AddressProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = TempUserStorage.currentUser!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.getUser(user.user.id);
      addressProvider.getListAddress(user.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserProvider, Status>(builder: (context, value, child) {
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
      } else if (value == Status.error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ProgressHUD.of(context)?.dismiss();
          print('Load error r');
        });
      }
      return buildData(userProvider);
    }, selector: (context, pro) {
      return pro.statusUser;
    });
  }

  Widget buildData(UserProvider userProvider) {
    return SizedBox(
      width: double.infinity,
      height: 700,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUser(userResponse: userProvider.userResponse , userProvider: userProvider,),
                    ),
                  );
                },
                child: const Text('Chỉnh sửa thông tin'),
              ),
              PopupMenuItem(
                  onTap: () async {
                    final address = await Navigator.push<AddressResponse?>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddressScreen(),
                      ),
                    );
                    if (address != null) {
                      setState(() {
                        selectedAddress = address;
                      });
                    }
                  },

                child: const Text('Địa chỉ của tôi'),
              ),
              PopupMenuItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePassword(userResponse: userProvider.userResponse , userProvider: userProvider,),
                    ),
                  );
                },
                child: const Text('Đổi mật khẩu'),
              ),

              PopupMenuItem(
                onTap: () {

                },
                child: const Text('Đăng xuất'),
              ),
            ],
            child:const SizedBox(
              height: 150,
              width: 150,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/3607/3607444.png"),
              ),
            ),
          ),
          const SizedBox(height: 10),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              user.user.roles.first.name == "ROLE_ADMIN" ?
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPayScreen(isAdmin: true, initialTabIndex: 0),
                    ),
                  );
                },
                child: const Column(
                  children: [
                    Icon(Icons.payment),
                    Text('Các đơn cần xác nhận'),
                  ],
                ),
              ) :InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPayScreen(isAdmin: false,initialTabIndex:  0),
                    ),
                  );
                },
                child: const Column(
                  children: [
                    Icon(Icons.payment),
                    Text('Chờ xác nhận'),
                  ],
                ),
              ),
              const SizedBox(width: 20,),
              InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPayScreen(isAdmin: false,initialTabIndex:  1),
                    ),
                  );
                },
                child: const Column(
                  children: [
                    Icon(Icons.drive_eta_rounded),
                    Text('Đơn hàng của bạn'),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 3,

          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 70,),
              Text('Thông tin cá nhân' , style: AppStyles.nuntio_14_blue,),
              const SizedBox(width: 20,),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUser(userResponse: userProvider.userResponse , userProvider: userProvider,),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit_note_rounded,
                  size: 30,
                  color: Colors.grey,
                ),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(
                    side: BorderSide(
                        width: 1,
                        color: Colors.grey.withOpacity(0.5)),
                  ),
                ),
              ),
            ],
          ),
          Text(
            userProvider.userResponse.userName,
            style: AppStyles.nuntio1_20_black,
          ),
          const SizedBox(height: 10),
          Text(
            userProvider.userResponse.fullName,
            style: AppStyles.nuntio1_20_black,
          ),
          const SizedBox(height: 10),
          Text(
            userProvider.userResponse.email,
            style: AppStyles.nuntio1_20_black,
          ),
          const Divider(
            thickness: 3,
          ),
        Text('Địa chỉ' , style: AppStyles.nuntio_14_blue,),
        Selector<AddressProvider, Status>(builder: (context, value, child) {
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
          } else if (value == Status.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ProgressHUD.of(context)?.dismiss();
              print('Load error r');
            });
          }
          if (addressProvider.listAddress.isNotEmpty &&
              addressProvider.addressSelect != null) {
            return GestureDetector(
              onTap: () async {
                final address = await Navigator.push<AddressResponse?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressScreen(),
                  ),
                );

                if (address != null) {
                  setState(() {
                    selectedAddress = address;
                  });
                }
              },
              child: Text(
                    '${selectedAddress?.street ?? addressProvider.listAddress.first.street} \n'
                    '${selectedAddress?.ward ?? addressProvider.listAddress.first.ward} , ${selectedAddress?.district ?? addressProvider.listAddress.first.district} ,  ${selectedAddress?.city ?? addressProvider.listAddress.first.city}',
                style: AppStyles.nuntio1_20_black,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            );
          } else {
            return ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.green3Color,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  minimumSize: const Size(double.infinity, 40)),
              child: const Text('Tạo mới địa chỉ'),
            );
          }
        }, selector: (context, pro) {
          return pro.statusListAddress;
        }),
          const Divider(
            thickness: 3,
          ),
          const SizedBox(height: 30,),
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => ChangePassword(userResponse: userProvider.userResponse , userProvider: userProvider,),
          //         ),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: AppPalette.green3Color,
          //       foregroundColor: Colors.white,
          //       shape: const RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(20))),
          //       minimumSize: const Size(250, 40),
          //     ),
          //     child: const Text(
          //       'Đổi mật khẩu',
          //       style: TextStyle(fontSize: 16),
          //     )),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
                onPressed: () {},
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
    );
  }
}

class ChangePassword extends StatelessWidget {
  ChangePassword({Key? key ,
    required this.userResponse ,
    required this.userProvider})
      :super(key: key);
  UserResponse userResponse;
  UserProvider userProvider;

  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> _changePassword() async {
      try {
        await userProvider.password(
            userResponse.id,
            _oldPassController.text,
            _newPassController.text
        );
        if (userProvider.checkPass == true) {
          showDialog(
              context: context,
              builder: (context) {
                return DialogBase(
                  title: 'Thông báo',
                  content: 'Mật khẩu đã được đổi thành công',
                  icon: AppAssets.icoDefault,
                  button: true,
                  function:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPage(selectedIndex: 3),
                      ),
                    );
                  } ,
                );
              });
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Failed to add product')),
          // );
          showDialog(
              context: context,
              builder: (context) {
                return DialogBase(
                  title: 'Thông báo',
                  content: 'Mật khẩu cũ không chính xác',
                  icon: AppAssets.icoDefault,
                  button: true,
                );
              });
        }
      }
      catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product')),
        );
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return DialogBase(
        //         title: 'Thông báo',
        //         content: 'Thêm sản phẩm thất bại',
        //         icon: AppAssets.icoDefault,
        //         button: true,
        //       );
        //     });
      }
    }
    return SkeletonTab(
        title: "Đổi mật khẩu",
        bodyWidgets: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _oldPassController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Mật khẩu cũ',
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
                controller: _newPassController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Mật khẩu mới',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _changePassword();              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.green3Color,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Đổi mật khẩu',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        isBack: true);
  }
}
class EditUser extends StatefulWidget {
  EditUser({Key? key ,
    required this.userResponse ,
    required this.userProvider})
      :super(key: key);
  UserResponse userResponse;
  UserProvider userProvider;

  @override
  State<EditUser> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditUser> {



  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userNameController.text = widget.userResponse.userName;
    _fullNameController.text = widget.userResponse.fullName;
    _emailController.text = widget.userResponse.email;



  }

  @override
  Widget build(BuildContext context) {
    Future<void> editUser() async {
      try {
        await widget.userProvider.editUser(
            widget.userResponse.id,
            _fullNameController.text,
            _emailController.text,
            _userNameController.text
        );
        if (widget.userProvider.checkEdit == true) {
          showDialog(
              context: context,
              builder: (context) {
                return DialogBase(
                  title: 'Thông báo',
                  content: 'Thông tin đã được đổi thành công',
                  icon: AppAssets.icoDefault,
                  button: true,
                  function:(){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPage(selectedIndex: 3),
                      ),
                    );
                  } ,
                );
              });
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Failed to add product')),
          // );
          showDialog(
              context: context,
              builder: (context) {
                return DialogBase(
                  title: 'Thông báo',
                  content: 'Thay đổi thất bại',
                  icon: AppAssets.icoDefault,
                  button: true,
                );
              });
        }
      }
      catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product')),
        );
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return DialogBase(
        //         title: 'Thông báo',
        //         content: 'Thêm sản phẩm thất bại',
        //         icon: AppAssets.icoDefault,
        //         button: true,
        //       );
        //     });
      }
    }
    return SkeletonTab(
        title: "Đổi mật khẩu",
        bodyWidgets: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    hintText: 'Mật khẩu cũ',
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
                controller: _fullNameController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Mật khẩu mới',
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
                    hintText: 'Mật khẩu cũ',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                editUser();              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.green3Color,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Cập nhật',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        isBack: true);
  }
}