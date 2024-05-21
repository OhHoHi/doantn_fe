import 'package:doan_tn/home/home_user/address/controller/address_provider.dart';
import 'package:doan_tn/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../../../../../auth/login/model/login_response.dart';
import '../../../../../auth/login/model/test_luu_user.dart';
import '../../../../../base/controler/base_provider.dart';
import '../../../../../values/apppalette.dart';
import '../../model/address_response.dart';

class BodyCRUDAddress extends StatefulWidget {
  BodyCRUDAddress({Key? key , this.addressResponse}) : super(key: key);
  AddressResponse? addressResponse;

  @override
  State<BodyCRUDAddress> createState() => _BodyAddressState();
}

class _BodyAddressState extends State<BodyCRUDAddress> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  late AddressProvider addressProvider;
  bool _isButtonEnabled = false;
  late LoginResponse user;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressProvider = Provider.of<AddressProvider>(context, listen: false);
    user = TempUserStorage.currentUser!;

    // Add listeners to the controllers
    _fullNameController.addListener(_validateFields);
    _phoneController.addListener(_validateFields);
    _cityController.addListener(_validateFields);
    _districtController.addListener(_validateFields);
    _wardController.addListener(_validateFields);
    _streetController.addListener(_validateFields);


    if(widget.addressResponse != null){
      _fullNameController.text = widget.addressResponse!.fullName!;
      _phoneController.text = widget.addressResponse!.phone!;
      _cityController.text = widget.addressResponse!.city!;
      _districtController.text = widget.addressResponse!.district!;
      _wardController.text = widget.addressResponse!.ward!;
      _streetController.text = widget.addressResponse!.street!;
    }
  }

  void _validateFields() {
    setState(() {
      _isButtonEnabled = _fullNameController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _cityController.text.isNotEmpty &&
          _districtController.text.isNotEmpty &&
          _wardController.text.isNotEmpty &&
          _streetController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // Dispose the controllers
    _fullNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  widget.addressResponse == null ?  Selector<AddressProvider, Status>(builder: (context, value, child) {
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
      return buildData(addressProvider);
    }, selector: (context, pro) {
      return pro.statusAddAddress;
    }) : Selector<AddressProvider, Status>(builder: (context, value, child) {
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
          print('Load error r edit ${addressProvider.checkEditAddress}');
        });
      }
      return buildData(addressProvider);
    }, selector: (context, pro) {
      return pro.statusEditAddress;
    });
  }

  Widget buildData(AddressProvider addressProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Liên hệ ", style: AppStyles.nuntio_18,),
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
                controller: _phoneController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Số điện thoại',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor)),
              ),
            ),
            Text("Địa chỉ", style: AppStyles.nuntio_18,),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _cityController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Tỉnh / Thành phố',
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
                controller: _districtController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Quận / Huyện',
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
                controller: _wardController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Phường / Xã',
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
                controller: _streetController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    labelStyle: TextStyle(color: AppPalette.textColor),
                    hintText: 'Tên đường , tòa nhà , số nhà',
                    hintStyle: TextStyle(color: AppPalette.thinTextColor)),
              ),
            ),
            const SizedBox(height: 20,),
            widget.addressResponse == null ?
            ElevatedButton(
              onPressed: _isButtonEnabled ? () {
                addressProvider.addAddress(context,
                    _cityController.text,
                    _districtController.text,
                    _wardController.text,
                    _streetController.text,
                    _fullNameController.text,
                    _phoneController.text,
                    user.user.id);
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.green3Color,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                'Hoàn Thành',
                style: TextStyle(fontSize: 16),
              ),
            ) : Column(
              children: [
                ElevatedButton(
                  onPressed:  () {
                    addressProvider.deleteAddress(context, widget.addressResponse!.id, user.user.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.green3Color,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    'Xóa địa chỉ',
                    style: TextStyle(fontSize: 16),
                  ),
                ) ,
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: _isButtonEnabled ? () {
                    addressProvider.editAddress(context,
                        _cityController.text,
                        _districtController.text,
                        _wardController.text,
                        _streetController.text,
                        _fullNameController.text,
                        _phoneController.text,
                      widget.addressResponse!.id,
                      user.user.id
                        );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.green3Color,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    minimumSize: const Size(200, 50),
                  ),
                  child: const Text(
                    'Hoàn Thành',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ) ,
          ],
        ),
      ),
    );
  }
}
