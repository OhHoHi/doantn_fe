import 'package:doan_tn/home/home_user/pay/controller/pay_controller.dart';
import 'package:doan_tn/home/home_user/pay/model/pay_response.dart';
import 'package:doan_tn/home/home_user/pay/view/widget/order_status_not_1and3.dart';
import 'package:doan_tn/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../../../../auth/login/model/login_response.dart';
import '../../../../../auth/login/model/test_luu_user.dart';
import '../../../../../base/controler/base_provider.dart';
import '../../../../../values/apppalette.dart';
import '../../../../controller/product_provider.dart';
import 'package:intl/intl.dart';
import 'order_pay_detail.dart';
import 'order_status_0.dart';
import 'order_status_1and3.dart';

class BodyOrderPay extends StatefulWidget {
  BodyOrderPay({Key? key , required this.isAdmin , required this.initialTabIndex}) : super(key: key);
  bool isAdmin ;
  final int initialTabIndex;
  @override
  State<BodyOrderPay> createState() => _BodyOrderPayState();
}

class _BodyOrderPayState extends State<BodyOrderPay> with SingleTickerProviderStateMixin {

  late PaymentProvider paymentProvider;
  late ProductProvider productProvider;
  late LoginResponse user;
  late final TabController _tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this , initialIndex: widget.initialTabIndex);
    user = TempUserStorage.currentUser!;
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    // if(widget.isAdmin == true){
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     paymentProvider.getListOrderAllStatus0();
    //     print("lay id duoc khong ${user.user.id}");
    //   });
    // }
    // else{
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     paymentProvider.getListOrder(user.user.id);
    //     print("lay id duoc khong ${user.user.id}");
    //   });
    // }
  }
  String formatDateTime(DateTime dateTime) {
    String format = 'dd/MM/yyyy HH:mm:ss';
    return DateFormat(format).format(dateTime);
  }
  String formatPrice(double price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
              TabBar(
                labelColor: Colors.black, // Màu của văn bản được chọn
                unselectedLabelColor: Colors.grey, // Màu của văn bản không được chọn
                labelStyle : AppStyles.nuntio_14_black,
                controller: _tabController,
                tabs:  [
                  const Tab(text: 'Chưa xác nhận'),
                  const Tab(text: "Đã xác nhận",),
                  widget.isAdmin == true ?
                  const Tab(text: 'Đã bán') : const Tab(text: "Đã giao",),
                ],
              ),
        SizedBox(
          height: 569,
          child: TabBarView(
            controller: _tabController,
            children: [
              OrderStatus0(isAdmin: widget.isAdmin, initialTabIndex: 0),
              OrderStatus1end3(isAdmin: widget.isAdmin, initialTabIndex: 1),
              OrderStatusNot1end3(isAdmin: widget.isAdmin, initialTabIndex: 2),
            ],
          ),
        ),
      ],
    );


      // Selector<PaymentProvider, Status>(builder: (context, value, child) {
      //   if (value == Status.loading) {
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       ProgressHUD.of(context)?.show();
      //     });
      //     print('Bat dau load');
      //   } else if (value == Status.loaded) {
      //     WidgetsBinding.instance.addPostFrameCallback((_) async {
      //       ProgressHUD.of(context)?.dismiss();
      //     });
      //     print("load thanh cong");
      //   } else if (value == Status.error) {
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       ProgressHUD.of(context)?.dismiss();
      //       print('Load error r');
      //     });
      //   } else if (value == Status.noData) {
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       ProgressHUD.of(context)?.dismiss();
      //     });
      //     return const Text("Bạn không có đơn hàng nào");
      //   }
      //   return Column(
      //     children: [
      //       TabBar(
      //         labelColor: Colors.black, // Màu của văn bản được chọn
      //         unselectedLabelColor: Colors.grey, // Màu của văn bản không được chọn
      //         labelStyle : AppStyles.nuntio_14_black,
      //         controller: _tabController,
      //         tabs:  [
      //           const Tab(text: 'Đơn chờ xác nhận'),
      //           widget.isAdmin == false ?
      //           const Tab(text: 'Đơn hàng của bạn') : const Tab(text: "Đơn hàng đã xác nhận",),
      //         ],
      //       ),
      //       SizedBox(
      //         height: 569,
      //         child: TabBarView(
      //           controller: _tabController,
      //           children: [
      //             OrderStatus0(isAdmin: widget.isAdmin, initialTabIndex: widget.initialTabIndex),// Nội dung của tab 1
      //             OrderStatusNot0(isAdmin: widget.isAdmin, initialTabIndex:widget.initialTabIndex)
      //             // ListView.builder(
      //             //   physics: const AlwaysScrollableScrollPhysics(),
      //             //   shrinkWrap: true,
      //             //   itemCount: paymentProvider.listOrder.length,
      //             //   itemBuilder: (context, index) {
      //             //     final reversedIndex = paymentProvider.listOrder.length - 1 - index; // Lấy chỉ số ngược lại
      //             //
      //             //     return buildData1(paymentProvider,paymentProvider.listOrder[reversedIndex]);
      //             //   },
      //             // ), // Nội dung của tab 2
      //           ],
      //         ),
      //       ),
      //
      //     ]
      //   );
      // }, selector: (context, pro) {
      //   return pro.statusListOrder;
      // });
  }

  Widget buildData(PaymentProvider paymentProvider, PayResponse payResponse) {

    if (payResponse.status != 0) {
      // Trả về widget trống nếu status khác 0
      return const SizedBox.shrink();
    }
    return Selector<PaymentProvider, Status>(
        builder: (context, value, child) {
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
          final orderItems = paymentProvider.orderItemsMap[payResponse.id] ?? [];
          if (orderItems.isEmpty) {
            return Text("Không có mục đơn hàng nào");
          }
          final orderItem = orderItems.first; // Chỉ lấy item đầu tiên
          final images = paymentProvider.images[orderItem.product.id.toString()];

          return Column(
            children: [
              InkWell(
                // onTap: (){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => OrderPayDetailScreen( payResponse: payResponse , isAdmin: widget.isAdmin,),
                //     ),
                //   );
                // },
                onTap:() async{
                  final resul = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderPayDetailScreen( payResponse: payResponse , isAdmin: widget.isAdmin,),
                        ),
                  );
                  if(resul == true) {
                    paymentProvider.getListOrderAll();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey),
                      color: Colors.white

                  ),
                  child: Row(
                    children: [
                      if (images != null && images.isNotEmpty)
                        Image.memory(
                          images.first,
                          fit: BoxFit.cover,
                          height: 90,
                          width: 70,
                        ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(orderItem.product.name, style: AppStyles.nuntio_18),
                            SizedBox(
                              width: 265,
                              child: Row(
                                children: [
                                  Text("${orderItems.length} sản phẩm : ", style: AppStyles.nuntio1_14_black),
                                  const Spacer(),
                                  Text('Thành tiền: ${formatPrice(payResponse.totalAmount)}', style: AppStyles.nuntio1_14_black),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 265,
                              child: Row(
                                children: [
                                  Text("Chờ xác nhận", style: AppStyles.nuntio1_14_red),
                                  const Spacer(),
                                  if (widget.isAdmin == true)
                                    ElevatedButton(

                                      onPressed: () {
                                        paymentProvider.increaseStatus(payResponse.id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppPalette.green3Color,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                        minimumSize: Size(40, 30),
                                      ),
                                      child: const Text('xác nhận'),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
            ],
          );
        }, selector: (context, pro) {
      return pro.statusListProduct;
    });
  }
  Widget buildData1(PaymentProvider paymentProvider, PayResponse payResponse) {

    if (payResponse.status == 0) {
      // Trả về widget trống nếu status khác 0
      return const SizedBox.shrink();
    }
    return Selector<PaymentProvider, Status>(
        builder: (context, value, child) {
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
          final orderItems = paymentProvider.orderItemsMap[payResponse.id] ?? [];
          if (orderItems.isEmpty) {
            return Text("Không có mục đơn hàng nào");
          }
          final orderItem = orderItems.first; // Chỉ lấy item đầu tiên
          final images = paymentProvider.images[orderItem.product.id.toString()];

          return Column(
            children: [
              InkWell(
                onTap:() async{
                  final resul = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OrderPayDetailScreen( payResponse: payResponse , isAdmin: widget.isAdmin,),
                    ),
                  );
                  if(resul == true) {
                    paymentProvider.getListOrderAll();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey),
                    color: Colors.white
                  ),
                  child: Row(
                    children: [
                      if (images != null && images.isNotEmpty)
                        Image.memory(
                          images.first,
                          fit: BoxFit.cover,
                          height: 90,
                          width: 70,
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(orderItem.product.name, style: AppStyles.nuntio_18),
                            SizedBox(
                              width: 265,
                              child: Row(
                                children: [
                                  Text("${orderItems.length} sản phẩm : ", style: AppStyles.nuntio1_14_black),
                                  const Spacer(),
                                  Text('Thành tiền: ${formatPrice(payResponse.totalAmount)}', style: AppStyles.nuntio1_14_black),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 265,
                              child: Row(
                                children: [
                                  Text("Đã xác nhận", style: AppStyles.nuntio1_14_green),
                                  const Spacer(),
                                  Text('Theo dõi đơn hàng' ,style: AppStyles.nuntio_14_blue ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
            ],
          );
        }, selector: (context, pro) {
      return pro.statusListProduct;
    });
  }
}









