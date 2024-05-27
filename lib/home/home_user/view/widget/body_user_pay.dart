import 'package:doan_tn/base/widget/SkeletonTab.dart';
import 'package:doan_tn/home/home_user/address/controller/address_provider.dart';
import 'package:doan_tn/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../auth/login/model/login_response.dart';
import '../../../../auth/login/model/test_luu_user.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../base/controler/consumer_base.dart';
import '../../../../base/widget/dialog_base.dart';
import '../../../../values/apppalette.dart';
import '../../../../values/assets.dart';
import '../../../../values/pay_config.dart';
import '../../../controller/product_provider.dart';
import '../../../model/cart_response.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import '../../address/model/address_response.dart';
import '../../address/view/address_crud_screen.dart';
import '../../address/view/address_screen.dart';
import '../../pay/controller/pay_controller.dart';
import '../../pay/view/order_pay_screen.dart';

class BodyUserPay extends StatefulWidget {
  const BodyUserPay(
      {Key? key, required this.productProvider, required this.productPayList})
      : super(key: key);

  final ProductProvider productProvider;
  final List<CartResponse> productPayList;

  @override
  State<BodyUserPay> createState() => _BodyUserPayState();
}

class _BodyUserPayState extends State<BodyUserPay> {
  String formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }

  late AddressProvider addressProvider;
  late PaymentProvider payProvider;

  late LoginResponse user;
  AddressResponse? selectedAddress;
  String selectedPaymentMethod = 'Normal';

  List<PaymentItem> get paymentItems {
    return widget.productPayList.map((product) {
      return PaymentItem(
        label: product.product.name,
        amount: (product.product.price * product.quantity).toString(),
        status: PaymentItemStatus.final_price,
      );
    }).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressProvider = Provider.of<AddressProvider>(context, listen: false);
    payProvider = Provider.of<PaymentProvider>(context, listen: false);
    user = TempUserStorage.currentUser!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressProvider.getListAddress(user.user.id);
      print("lay id duoc khong ${user.user.id}");
    });
  }

  Future<void> _addPay() async {
    try {
        await payProvider.addOrder(
            user.user.id,
            0,
            widget.productProvider.totalAmountProvider,
            selectedAddress?.id ?? addressProvider.listAddress.first.id,
            widget.productPayList);
      if (payProvider.checkAddOrder == true) {
        // Xóa từng sản phẩm trong widget.productPayList bằng cách gọi hàm deleteCart
        for (var product in widget.productPayList) {
          await widget.productProvider.deleteCartPay(product.id);
        }
        if(widget.productPayList.isEmpty){
          showDialog(
              context: context,
              builder: (context) {
                return DialogBase(
                  title: 'Thông báo',
                  content: 'Đơn hàng này bạn đã đặt rồi',
                  icon:AppAssets.icoNotice,
                  button: false,
                );
              });
        }
        else{
          showDialog(
              context: context,
              builder: (context) {
                return DialogBase(
                  title: 'Thành công',
                  content: 'Bạn đã đặt hàng thành công',
                  icon: AppAssets.icoSuccess,
                  button: true,
                  function: () async {
                    final resul = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderPayScreen(isAdmin: false, initialTabIndex: 0),
                      ),
                    );
                    if (resul == true) {
                      setState(() {
                        setState(() {
                          widget.productPayList.clear();
                        });
                      });
                    }
                  },
                );

              });
          setState(() {
            setState(() {
              widget.productPayList.clear();
            });
          });
        }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to add product')),
        // );
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thất bại',
                content: 'Đặt hàng chưa thành công hãy quay lại sau',
                icon: AppAssets.icoFail,
                button: true,
              );
            });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đặt hàng thất bại')),
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

  void onGooglePayResult(paymentResult) {
    // Xử lý kết quả thanh toán Google Pay
    print('Payment Result: $paymentResult');
    _addPay();
  }

  void payPressed(String addressFromProvider) {
    _addPay();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonTab(
      title: "Thanh toán",
      bodyWidgets: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AppAssets.icoAddress),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Địa chỉ nhận hàng",
                  style: AppStyles.nuntio_18,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
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
              } else if (value == Status.noData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ProgressHUD.of(context)?.dismiss();
                });
                return ElevatedButton(
                  onPressed: () async {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AddressCRUDScreen(),
                    //   ),
                    // );
                    final resul = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddressCRUDScreen(),
                      ),
                    );
                    if (resul == true) {
                      addressProvider.getListAddress(user.user.id);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.green3Color,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      minimumSize: const Size(double.infinity, 40)),
                  child: const Text('Tạo mới địa chỉ'),
                );
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
                    } else {
                      addressProvider.getListAddress(user.user.id);
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        '${selectedAddress?.fullName ?? addressProvider.listAddress.first.fullName} | ${selectedAddress?.phone ?? addressProvider.listAddress.first.phone} \n '
                        '${selectedAddress?.street ?? addressProvider.listAddress.first.street} \n'
                        '${selectedAddress?.ward ?? addressProvider.listAddress.first.ward} , ${selectedAddress?.district ?? addressProvider.listAddress.first.district} ,  ${selectedAddress?.city ?? addressProvider.listAddress.first.city}',
                        style: AppStyles.nuntio_14_black,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                      const Spacer(),
                      const Icon(Icons.navigate_next_sharp)
                    ],
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
              height: 20,
              thickness: 5,
            ),
            Text(
              "Danh sách sản phẩm",
              style: AppStyles.nuntio_18,
            ),
            Column(
              children: List.generate(widget.productPayList.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // Placeholder for product image
                      Selector<ProductProvider, Status>(
                          builder: (context, value, child) {
                        if (value == Status.loading) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ProgressHUD.of(context)?.show();
                          });
                          print('Bat dau load');
                        } else if (value == Status.loaded) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            ProgressHUD.of(context)?.dismiss();
                          });
                          print("load thanh cong");
                        } else if (value == Status.error) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ProgressHUD.of(context)?.dismiss();
                            print('Load error r');
                          });
                        }
                        final images = widget.productProvider.images[
                            widget.productPayList[index].product.id.toString()];
                        if (images != null && images.isNotEmpty) {
                          return Container(
                            height: 90,
                            width: 100,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              // image: DecorationImage(
                              //     image: NetworkImage(product.imageUrl), fit: BoxFit.cover),
                            ),
                            child: Image.memory(
                              images.first,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return const SizedBox(
                            height: 90,
                            width: 100,
                          );
                        }
                      }, selector: (context, pro) {
                        return pro.statusListProduct;
                      }),
                      const SizedBox(width: 10),
                      Container(
                        width: 260,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productPayList[index].product.name,
                              style: AppStyles.nuntio_14_black,
                            ),
                            const SizedBox(height: 10),
                            Text(
                                "Màu : ${widget.productPayList[index].product.color}"),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  '${widget.productPayList[index].product.price} vnd',
                                  style: AppStyles.nuntio_14_black,
                                ),
                                Spacer(),
                                // SizedBox(width: 150,),
                                Text(
                                  'x ${widget.productPayList[index].quantity}',
                                  style: AppStyles.nuntio_14_black,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    "Tổng số tiền ( ${widget.productPayList[index].quantity} sp) :"),
                                const Spacer(),
                                Text(
                                  '${formatPrice(widget.productPayList[index].product.price * widget.productPayList[index].quantity)}vnd',
                                  style: AppStyles.nuntio_14_red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const Divider(
              height: 20,
              thickness: 5,
            ),
            Row(
              children: [
                const Icon(Icons.payment),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Chi tiết hóa đơn",
                  style: AppStyles.nuntio_18,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Tổng tiền hàng :',
                  style: AppStyles.nuntio_14_black,
                ),
                const Spacer(),
                // SizedBox(width: 150,),
                Text(
                  ' ${formatPrice(widget.productProvider.totalAmountProvider)}',
                  style: AppStyles.nuntio_14_black,
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Tổng tiền phí vận chuyển :',
                  style: AppStyles.nuntio_14_black,
                ),
                const Spacer(),
                // SizedBox(width: 150,),
                Text(
                  '0',
                  style: AppStyles.nuntio_14_black,
                )
              ],
            ),
            Row(
              children: [
                Text(
                  'Tổng thanh toán :',
                  style: AppStyles.nuntio_18,
                ),
                const Spacer(),
                // SizedBox(width: 150,),
                Text(
                  formatPrice(widget.productProvider.totalAmountProvider),
                  style: AppStyles.nuntio_18_red,
                )
              ],
            ),
            const Divider(
              height: 20,
              thickness: 5,
            ),
            Row(
              children: [
                const Icon(Icons.payments_rounded),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Thanh toán",
                  style: AppStyles.nuntio_18,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Phương thức thanh toán",
              style: AppStyles.nuntio_18,
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Normal',
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                const Text('Thanh khi nhận hàng'),
                Radio<String>(
                  value: 'GooglePay',
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  },
                ),
                const Text('Google Pay'),
              ],
            ),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
      isBack: true,
      bottomSheetWidgets: BottomSheetPay(
        productProvider: widget.productProvider,
        selectedPaymentMethod: selectedPaymentMethod,
        onGooglePayResult: onGooglePayResult,
        paymentItems: paymentItems,
        payPressed: payPressed,
        addressProvider: addressProvider,
        user: user,
      ),
    );
  }
}

class BottomSheetPay extends StatelessWidget {
  BottomSheetPay({
    Key? key,
    required this.productProvider,
    required this.selectedPaymentMethod,
    required this.payPressed,
    required this.onGooglePayResult,
    required this.paymentItems,
    required this.addressProvider,
    required this.user,
  }) : super(key: key);
  final ProductProvider productProvider;
  String selectedPaymentMethod;
  final Function(String) payPressed;
  final Function(dynamic) onGooglePayResult;
  final List<PaymentItem> paymentItems;
  final AddressProvider addressProvider;
  final LoginResponse user;

  String formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Row(
        children: [
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Tổng tiền thanh toán",
                style: AppStyles.nuntio_14_black,
              ),
              Text(
                '${formatPrice(productProvider.totalAmountProvider)} vnđ',
                style: AppStyles.nuntio_18_red,
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          if (selectedPaymentMethod == 'Normal')
            ElevatedButton(
              onPressed: () async {
                if (addressProvider.listAddress.isEmpty) {
                  await addressProvider.getListAddress(user.user.id);
                  if (addressProvider.listAddress.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Không có địa chỉ nào, vui lòng thêm địa chỉ')),
                    );
                  } else {
                    payPressed("");
                  }
                } else {
                  payPressed("");
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.green3Color,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0))),
                  minimumSize: const Size(170, 70)),
              child: const Text('Đặt hàng'),
            )
          else if (selectedPaymentMethod == 'GooglePay')
            GooglePayButton(
              paymentConfiguration:
                  PaymentConfiguration.fromJsonString(defaultGooglePay),
              onPaymentResult: (paymentResult) async {
                if (addressProvider.listAddress.isEmpty) {
                  await addressProvider.getListAddress(user.user.id);
                  if (addressProvider.listAddress.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Không có địa chỉ nào, vui lòng thêm địa chỉ')),
                    );
                  } else {
                    onGooglePayResult(paymentResult);
                  }
                } else {
                  onGooglePayResult(paymentResult);
                }
              },
              paymentItems: paymentItems,
              height: 70,
              type: GooglePayButtonType.buy,
              //margin: const EdgeInsets.only(top: 15),
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
