import 'package:doan_tn/base/widget/SkeletonTab.dart';
import 'package:doan_tn/home/home_user/pay/controller/pay_controller.dart';
import 'package:doan_tn/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../base/controler/base_provider.dart';
import '../../../../../base/services/dio_option.dart';
import '../../../../../base/widget/dialog_base.dart';
import '../../../../../values/apppalette.dart';
import '../../../../../values/assets.dart';
import '../../model/pay_response.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../servicer/pay_service.dart';
import '../order_pay_screen.dart';

class OrderPayDetailScreen extends StatelessWidget {
  const OrderPayDetailScreen({Key? key, required this.payResponse , required this.isAdmin})
      : super(key: key);
  final PayResponse payResponse;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (context)=>ProductProvider(ProductService(DioOption().createDio())),
        // ),
        // ChangeNotifierProvider(
        //   create: (context)=>AddressProvider(AddressService(DioOption().createDio())),
        // ),
        ChangeNotifierProvider(
          create: (context) =>
              PaymentProvider(PayService(DioOption().createDio())),
        ),
      ],
      child: OrderPayDetail(payResponse: payResponse , isAdmin: isAdmin),
    );
  }
}

class OrderPayDetail extends StatefulWidget {
  const OrderPayDetail({
    Key? key,
    required this.payResponse,
    required this.isAdmin
  }) : super(key: key);
  final PayResponse payResponse;
  final bool isAdmin;

// final PaymentProvider paymentProvider;
  @override
  State<OrderPayDetail> createState() => _OrderPayDetailState();
}

class _OrderPayDetailState extends State<OrderPayDetail> {
  String formatDateTime(DateTime dateTime) {
    String format = 'dd/MM/yyyy HH:mm:ss';
    return DateFormat(format).format(dateTime);
  }

  String formatPrice(double price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }

  String formatPrice1(int price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }

  Future<void> _decreaseStatus(int id) async {
    try {
      await paymentProvider.decreaseStatus(id);
      if (paymentProvider.checkDecreaseStatus == true) {
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content: 'Bạn đã hủy đơn hàng thành công',
                icon: AppAssets.icoDefault,
                button: true,
                // function:(){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => OrderPayScreen(isAdmin: false , initialTabIndex: 0,),
                //     ),
                //   );
                // } ,
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
                content: 'Có lỗi gì đó sảy ra',
                icon: AppAssets.icoDefault,
                button: true,
              );
            });
      }
    } catch (e) {
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

  late PaymentProvider paymentProvider;

  int currentStep = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      paymentProvider.listOrderItem1 = [];
      paymentProvider.getListOrderItem1(widget.payResponse.id);
    });
    currentStep = widget.payResponse.status;
  }

  void changeOrderStatus(int status , int orderId) {
    paymentProvider.increaseStatus(orderId);
    setState(() {
      currentStep += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonTab(
      title: 'Chi tiết đơn hàng của bạn',
      bodyWidgets: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Địa chỉ nhận hàng ",
              style: AppStyles.nuntio_18,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: Text(
                '${widget.payResponse.address.fullName} \n ${widget.payResponse.address.phone} \n'
                '${widget.payResponse.address.street} \n'
                '${widget.payResponse.address.ward}, ${widget.payResponse.address.district}, ${widget.payResponse.address.city}',
                style: AppStyles.nuntio1_14_black,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Thông tin sản phẩm ",
              style: AppStyles.nuntio_18,
            ),
            const SizedBox(height: 10),
            Selector<PaymentProvider, Status>(builder: (context, value, child) {
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
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    ),
                    color: Colors.white),
                child: Column(
                  children: [
                    for (int i = 0;
                        i < paymentProvider.listOrderItem1.length;
                        i++)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(width: 5),
                              if (paymentProvider.images[paymentProvider
                                          .listOrderItem1[i].product.id
                                          .toString()] !=
                                      null &&
                                  paymentProvider
                                      .images[paymentProvider
                                          .listOrderItem1[i].product.id
                                          .toString()]!
                                      .isNotEmpty)
                                Image.memory(
                                  paymentProvider
                                      .images[paymentProvider
                                          .listOrderItem1[i].product.id
                                          .toString()]!
                                      .first,
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      paymentProvider
                                          .listOrderItem1[i].product.name,
                                      style: AppStyles.nuntio_18,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Màu : ${paymentProvider.listOrderItem1[i].product.color}',
                                              style: AppStyles.nuntio1_14_black,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Thương hiệu : ${paymentProvider.listOrderItem1[i].product.brands.name}',
                                              style: AppStyles.nuntio1_14_black,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'x ${paymentProvider.listOrderItem1[i].quantity}',
                                              style: AppStyles.nuntio1_14_black,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${formatPrice1((paymentProvider.listOrderItem1[i].product.price * paymentProvider.listOrderItem1[i].quantity))}',
                                              style: AppStyles.nuntio1_14_red,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Thành tiền : ",
                          style: AppStyles.nuntio1_20_black,
                        ),
                        const Spacer(),
                        Text(
                          "${formatPrice(widget.payResponse.totalAmount)} vnđ",
                          style: AppStyles.nuntio1_20_red,
                        )
                      ],
                    )
                  ],
                ),
              );
            }, selector: (context, pro) {
              return pro.statusListProduct;
            }),
            const SizedBox(height: 10),
            Text(
              "Thông tin đơn hàng ",
              style: AppStyles.nuntio_18,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Date:        ${formatDateTime(widget.payResponse.orderDate)}',
                    style: AppStyles.nuntio1_14_black,
                  ),
                  Text(
                    'Order ID:          ${widget.payResponse.id}',
                    style: AppStyles.nuntio1_14_black,
                  ),
                  Text(
                    'Order Total:       ${formatPrice(widget.payResponse.totalAmount)}',
                    style: AppStyles.nuntio1_14_black,
                  ),
                ],
              ),
            ),
            Text(
              "Thông tin vận chuyển ",
              style: AppStyles.nuntio_18,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: currentStep >= 0 ?
              Stepper(
                currentStep: currentStep,
                controlsBuilder: (context, detail) {
                  if(widget.isAdmin == true  && currentStep < 3){
                    return ElevatedButton(
                      onPressed: () => changeOrderStatus( detail.currentStep, widget.payResponse.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.green3Color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        minimumSize: Size(40, 30),
                      ),
                      child: const Text('Xong'),
                    );
                  }
                  return const SizedBox();
                },
                steps: [
                  Step(
                      title: const Text("Đặt hàng thành công"),
                      content: const Text("Đơn hàng chưa được xác nhận"),
                    isActive: currentStep > 0,
                    state: currentStep > 0 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                      title: const Text("Đang chuẩn bị thành công"),
                      content: const Text("Đơn hàng của bạn đang được đóng gói"),
                    isActive: currentStep > 1,
                    state: currentStep > 1 ? StepState.complete : StepState.indexed,
                  ),
                  Step(
                      title: const Text("Đang giao hàng"),
                      content: const Text("Đơn hàng đang được giao đến cho bạn"),
                    isActive: currentStep > 2,
                    state: currentStep > 2 ? StepState.complete : StepState.indexed,

                  ),
                  Step(
                    title: const Text("Đã giao"),
                    content: const Text("Đơn hàng đã được giao đến cho bạn"),
                    isActive: currentStep >= 3,
                    state: currentStep >= 3 ? StepState.complete : StepState.indexed,
                  ),
                  // Step(
                  //     title: const Text("Đã giao"),
                  //     content: const Text("Đơn hàng đã được giao đến cho bạn"),
                  //   isActive: currentStep >= 4,
                  //   state: currentStep >= 4 ? StepState.complete : StepState.indexed,
                  // ),
                ],
              ) :  const SizedBox(
                child: Text("Đơn hàng này đã bị hủy", ),
              ) , 
            ),
              const SizedBox(height: 30,),
              widget.isAdmin == false && widget.payResponse.status == 0 ?
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     ElevatedButton(
                      onPressed: () {
                        _decreaseStatus(widget.payResponse.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.green3Color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        minimumSize: Size(300, 50),
                      ),
                      child: const Text('Hủy đơn hàng'),
                ),
                   ],
                 ) :
              widget.payResponse.status == 0 ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _decreaseStatus(widget.payResponse.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.green3Color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      minimumSize: Size(300, 50),
                    ),
                    child: const Text('Từ chối đơn hàng'),
                  ),
                ],
              ) :
              const SizedBox.shrink() // Không hiển thị gì nếu status bằng 0
          ],
        ),
      ),
      isBack: true,
    );
  }
}
