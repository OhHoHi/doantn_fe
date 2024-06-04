import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import '../../../../../auth/login/model/login_response.dart';
import '../../../../../auth/login/model/test_luu_user.dart';
import '../../../../../base/controler/base_provider.dart';
import '../../../../../base/services/dio_option.dart';
import '../../../../../values/apppalette.dart';
import '../../../../../values/styles.dart';
import '../../controller/pay_controller.dart';
import '../../model/pay_response.dart';
import '../../servicer/pay_service.dart';
import '../order_pay_screen.dart';
import 'order_pay_detail.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class OrderStatus0 extends StatelessWidget {
  OrderStatus0({Key? key, required this.isAdmin, required this.initialTabIndex})
      : super(key: key);
  bool isAdmin;

  final int initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              PaymentProvider(PayService(DioOption().createDio())),
        ),
      ],
      child:
          BodyOrderStatus0(isAdmin: isAdmin, initialTabIndex: initialTabIndex),
    );
  }
}

class BodyOrderStatus0 extends StatefulWidget {
  BodyOrderStatus0(
      {Key? key, required this.isAdmin, required this.initialTabIndex})
      : super(key: key);
  bool isAdmin;

  final int initialTabIndex;

  @override
  State<BodyOrderStatus0> createState() => _OrderStatus0State();
}

class _OrderStatus0State extends State<BodyOrderStatus0> {
  late PaymentProvider paymentProvider;
  late LoginResponse user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = TempUserStorage.currentUser!;
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    if (widget.isAdmin == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // paymentProvider.resetPage();
        paymentProvider.getListOrderAllStatus0();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //  paymentProvider.resetPage();
        paymentProvider.getListOrderStatus0WithUser(user.user.id);
        print("lay id duoc khong ${user.user.id}");
      });
    }
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
  Widget build(BuildContext context) {
    return Selector<PaymentProvider, Status>(builder: (context, value, child) {
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
        return const Center(child: Text("Không có mục đơn hàng nào"));
      }
      return
          // RefreshLoadmore(
          // onRefresh: widget.isAdmin == true ? _refreshIsAdmin : _refreshIsUser ,
          // onLoadmore: widget.isAdmin == true ? _scrollListenerIsAdmin : _scrollListenerIsUser ,
          // isLastPage: false , //  !paymentProvider.canLoadMore,
          //child:
          SingleChildScrollView(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: paymentProvider.listOrderStatus0.length,
          itemBuilder: (context, index) {
            return buildData(
                paymentProvider, paymentProvider.listOrderStatus0[index]);
          },
        ),
        //  ),
      );
    }, selector: (context, pro) {
      return pro.statusListOrder;
    });
  }

  Widget buildData(PaymentProvider paymentProvider, PayResponse payResponse) {


    final orderItems = paymentProvider.orderItemsMap[payResponse.id] ?? [];
    if (orderItems.isEmpty) {
      return const SizedBox.shrink();
    }
    final orderItem = orderItems.first; // Chỉ lấy item đầu tiên
    final images = paymentProvider.images[orderItem.product.id.toString()];

    return Column(
      children: [
        InkWell(
          onTap: () async {
            final resul = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrderPayDetailScreen(
                  payResponse: payResponse,
                  isAdmin: widget.isAdmin,
                ),
              ),
            );
            if (resul == true) {
              widget.isAdmin == true
                  ? paymentProvider.getListOrderAllStatus0()
                  : paymentProvider.getListOrderStatus0WithUser(user.user.id);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey),
                color: Colors.white),
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
                            Text("${orderItems.length} sản phẩm : ",
                                style: AppStyles.nuntio1_14_black),
                            const Spacer(),
                            Text(
                                'Thành tiền: ${formatPrice(payResponse.totalAmount)}',
                                style: AppStyles.nuntio1_14_black),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 265,
                        child: Row(
                          children: [
                            Text("Chờ xác nhận",
                                style: AppStyles.nuntio1_14_red),
                            const Spacer(),
                            // if (widget.isAdmin == true)
                            //   ElevatedButton(
                            //     onPressed: () {
                            //       paymentProvider.increaseStatus(payResponse.id);
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: AppPalette.green3Color,
                            //       foregroundColor: Colors.white,
                            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            //       minimumSize: Size(40, 30),
                            //     ),
                            //     child: const Text('xác nhận'),
                            //   ),
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
