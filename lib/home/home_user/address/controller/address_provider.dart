import 'package:doan_tn/home/home_user/address/model/address_requets.dart';
import 'package:doan_tn/home/home_user/address/model/address_response.dart';
import 'package:doan_tn/home/home_user/notify_tab/model/notify_response.dart';
import 'package:doan_tn/home/home_user/notify_tab/service/notify_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../base/widget/dialog_base.dart';
import '../../../../values/assets.dart';
import '../../view/user_pay_screen.dart';
import '../service/address_service.dart';
import '../view/address_screen.dart';

class AddressProvider extends BaseProvider<AddressService> {
  AddressProvider(AddressService service) : super(service);

  Status statusAddAddress = Status.none;
  Status statusListAddress = Status.none;
  Status statusEditAddress = Status.none;
  Status statusDeleteAddress = Status.none;


  late List<AddressResponse> listAddress = [];
  AddressResponse? addressSelect;
  bool? checkAddAddress;
  bool? checkEditAddress;
  bool? checkDeleteAddress;

  // Method to set the selected address
  void selectAddress(AddressResponse address) {
    addressSelect = address;
    notifyListeners();
  }
  Future<void> addAddress(
      BuildContext context,
      String city,
      String district,
      String ward,
      String street,
      String fullName,
      String phone,
      int userId) async {
    resetStatus();
    try {
      startLoading(() {
        statusAddAddress = Status.loading;
      });
      checkAddAddress = await service.addAddress(
          AddressRequest(
              city: city,
              district: district,
              ward: ward,
              street: street,
              fullName: fullName,
              phone: phone),
          userId);

      if (checkAddAddress == true) {
        finishLoading(() {
          statusAddAddress = Status.loaded;
        });
        Navigator.pop(context , true);
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content: 'Thêm địa chỉ thành công',
                icon: AppAssets.icoDefault,
                button: true,
                // function:(){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => AddressScreen(),
                //     ),
                //   );
                // } ,
              );
            });
      } else {
        receivedError(() {
          statusAddAddress = Status.error;
        });
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content: 'Thất bại',
                icon: AppAssets.icoDefault,
                button: true,
              );
            });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusAddAddress = Status.error;
      });
    }
  }
  Future<void> getListAddress(int userId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListAddress = Status.loading;
      });
      listAddress = await service.getListAddress(userId);
      finishLoading(() {
        statusListAddress = Status.loaded;
        addressSelect = listAddress.isNotEmpty ? listAddress.first : null;
      });
      if (listAddress.isEmpty) {
        receivedNoData(() {
          statusListAddress = Status.noData;
        });
      } else {
        finishLoading(() {
          statusListAddress = Status.loaded;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListAddress = Status.error;
      });
    }
  }
  Future<void> editAddress(
      BuildContext context,
      String city,
      String district,
      String ward,
      String street,
      String fullName,
      String phone,
      int addressId,
      int userId) async {
    resetStatus();
    try {
      startLoading(() {
        statusEditAddress = Status.loading;
      });
      checkEditAddress = await service.editAddress(
          AddressRequest(
              city: city,
              district: district,
              ward: ward,
              street: street,
              fullName: fullName,
              phone: phone),
          addressId,
          userId);

      if (checkEditAddress == true) {
        finishLoading(() {
          statusEditAddress = Status.loaded;
        });
        Navigator.pop(context , true);
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content: 'Sửa địa chỉ thành công',
                icon: AppAssets.icoDefault,
                button: true,
                // function:(){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => AddressScreen(),
                //     ),
                //   );
                // } ,
              );
            });
      } else {
        receivedError(() {
          statusEditAddress = Status.error;
        });
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content: 'Thất bại',
                icon: AppAssets.icoDefault,
                button: true,
              );
            });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusEditAddress = Status.error;
      });
    }
  }
  Future<void> deleteAddress(BuildContext context, int addressId , int userId)async {
    resetStatus();
    try {
      startLoading((){
        statusDeleteAddress = Status.loading;
      });
      // startLoading();
      checkDeleteAddress = await service.deleteAddress(addressId, userId);
      if(checkDeleteAddress == true){
        finishLoading(() {
          statusDeleteAddress = Status.loaded;
        });
        Navigator.pop(context , true);
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content: 'Xóa địa chỉ thành công',
                icon: AppAssets.icoDefault,
                button: true,
                // function:(){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => AddressScreen(),
                //     ),
                //   );
                // } ,
              );
            });
      }
      else{
        receivedError(() {
          statusDeleteAddress = Status.error;
        });
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content: 'Thất bại',
                icon: AppAssets.icoDefault,
                button: true,
              );
            });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusDeleteAddress = Status.error;
      });
      showDialog(
          context: context,
          builder: (context) {
            return DialogBase(
              title: 'Thông báo',
              content: 'Thất bại',
              icon: AppAssets.icoDefault,
              button: true,
            );
          });
    }
  }
}
