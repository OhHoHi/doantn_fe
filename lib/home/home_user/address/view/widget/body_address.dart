import 'package:doan_tn/home/home_user/address/view/address_crud_screen.dart';
import 'package:doan_tn/home/home_user/view/user_pay_screen.dart';
import 'package:doan_tn/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../../../../auth/login/model/login_response.dart';
import '../../../../../auth/login/model/test_luu_user.dart';
import '../../../../../base/controler/base_provider.dart';
import '../../../../../base/controler/consumer_base.dart';
import '../../../../../values/apppalette.dart';
import '../../../../controller/product_provider.dart';
import '../../../../model/cart_response.dart';
import '../../controller/address_provider.dart';
import '../../model/address_response.dart';
class BodyAddress extends StatefulWidget {
  const BodyAddress({Key? key}) : super(key: key);
  @override
  State<BodyAddress> createState() => _BodyAddressState();
}

class _BodyAddressState extends State<BodyAddress> {
  late AddressProvider addressProvider;
  late LoginResponse user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressProvider = Provider.of<AddressProvider>(context , listen:  false);
    user = TempUserStorage.currentUser!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressProvider.getListAddress(user.user.id);
      print("lay id duoc khong ${user.user.id}");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Selector<AddressProvider, Status>(builder: (context, value, child) {
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
      return pro.statusListAddress;
    });
  }

  Widget buildData(AddressProvider addressProvider){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            height: 550,
            child: ListView.builder(
            itemCount: addressProvider.listAddress.length,
            itemBuilder: (context, index) {
              final address = addressProvider.listAddress[index];
              return InkWell(
                onTap: () {
                  Navigator.pop(context, address);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${address.fullName} | ${address.phone} \n'
                                  '${address.street} \n'
                                  '${address.ward}, ${address.district}, ${address.city}',
                              style: AppStyles.nuntio_14_black,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          IconButton(
                              onPressed: () async{
                                final resul = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AddressCRUDScreen(addressResponse: address),
                                  ),
                                );
                                if(resul == true) {
                                  addressProvider.getListAddress(user.user.id);
                                }
                              },
                              icon: const Icon(Icons.edit_rounded,
                                  size: 20))
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      )
                    ],
                  ),
                ),
              );
            },
        ),
          ),
          const SizedBox(height: 50,),
          ElevatedButton(
            onPressed:() async{
              final resul = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddressCRUDScreen(),
                ),
              );
              if(resul == true) {
                addressProvider.getListAddress(user.user.id);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.green3Color,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              minimumSize: const Size(200, 50),
            ),
            child: const Text(
              'Thêm địa chỉ mới',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ]
      ),
    );
  }
}
