import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import '../../../../../auth/login/model/login_response.dart';
import '../../../../../auth/login/model/test_luu_user.dart';
import '../../../../../base/controler/base_provider.dart';
import '../../../../../base/services/dio_option.dart';
import '../../../../../values/styles.dart';
import '../../controller/pay_controller.dart';
import '../../model/pay_response.dart';
import '../../servicer/pay_service.dart';
import 'order_pay_detail.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class OrderStatusNot1end3 extends StatelessWidget {
  OrderStatusNot1end3({Key? key, required this.isAdmin , required this.initialTabIndex})
      : super(key: key);
  bool isAdmin ;
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
      child: BodyOrderStatusNot1end3(isAdmin: isAdmin, initialTabIndex: initialTabIndex),
    );
  }
}
class BodyOrderStatusNot1end3 extends StatefulWidget {
  BodyOrderStatusNot1end3({Key? key , required this.isAdmin , required this.initialTabIndex}) : super(key: key);
  bool isAdmin ;
  final int initialTabIndex;
  @override
  State<BodyOrderStatusNot1end3> createState() => _OrderStatusNot1end3State();
}

class _OrderStatusNot1end3State extends State<BodyOrderStatusNot1end3> {
  late PaymentProvider paymentProvider;
  late LoginResponse user;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = TempUserStorage.currentUser!;
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    if(widget.isAdmin == true){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        paymentProvider.resetPage();
        paymentProvider.getListOrderAllStatusNot1end3();
        print("lay id duoc khong ${user.user.id}");
      });
    }
    else{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        paymentProvider.resetPage();
        paymentProvider.getListOrderAllStatusNot1end3WithUser(user.user.id);
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

  Future<void> _refreshIsAdmin() async{
    paymentProvider.refresh = true;
    paymentProvider.resetPage();
    paymentProvider.getListOrderAllStatusNot1end3();
  }
  Future<void> _scrollListenerIsAdmin() async {
    paymentProvider.loadMoreOrderAllStatusNot1end3();
  }
  Future<void> _refreshIsUser() async{
    paymentProvider.refresh = true;
    paymentProvider.resetPage();
    paymentProvider.getListOrderAllStatusNot1end3WithUser(user.user.id);
  }
  Future<void> _scrollListenerIsUser() async {
    paymentProvider.loadMoreOrderAllStatusNot1end3WithUser(user.user.id);
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
        return const Center(child: Text("Bạn không có đơn hàng nào"));
      }
      return
        RefreshLoadmore(
        onRefresh: widget.isAdmin == true ? _refreshIsAdmin : _refreshIsUser ,
        onLoadmore: widget.isAdmin == true ? _scrollListenerIsAdmin : _scrollListenerIsUser ,
        isLastPage:!paymentProvider.canLoadMore,
        child:
        SingleChildScrollView(
          child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: paymentProvider.listOrderDisplay.length,
          itemBuilder: (context, index) {
            final reversedIndex = paymentProvider.listOrderStatusNot1and3.length - 1 - index; // Lấy chỉ số ngược lại

            return buildData(paymentProvider,paymentProvider.listOrderDisplay[index]);
          },
      ),
        )
        );
    }, selector: (context, pro) {
      return pro.statusListOrder;
    });
  }
  Widget buildData(PaymentProvider paymentProvider, PayResponse payResponse) {

    if (payResponse.status == 0) {
      // Trả về widget trống nếu status khác 0
      return const SizedBox.shrink();
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
                  if(resul == false) {
                    widget.isAdmin == true ?
                    paymentProvider.getListOrderAllStatus1end3() :paymentProvider.getListOrderAllStatusNot1end3WithUser(user.user.id);
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
  }

}
