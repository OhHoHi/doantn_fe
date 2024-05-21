
import 'package:doan_tn/home/home_user/pay/view/widget/order_status_not_1and3.dart';
import 'package:doan_tn/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  late final TabController _tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialTabIndex);
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
          labelColor: Colors.black,
          // Màu của văn bản được chọn
          unselectedLabelColor: Colors.grey,
          // Màu của văn bản không được chọn
          labelStyle: AppStyles.nuntio_14_black,
          controller: _tabController,
          tabs: [
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
  }
}









