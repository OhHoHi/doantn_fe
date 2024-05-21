import 'package:doan_tn/home/home_admin/thongke_tab/view/widget/top_product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../values/styles.dart';
import 'order_month.dart';


class BodyThongKe extends StatefulWidget {
  const BodyThongKe({Key? key}) : super(key: key);

  @override
  State<BodyThongKe> createState() => _BodyThongKeState();
}

class _BodyThongKeState extends State<BodyThongKe>with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  String formatPrice(double price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
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
          tabs:  const [
            Tab(text: 'Theo tháng'),
            Tab(text: "Theo sản phẩm bán chạy",),
          ],
        ),
        SizedBox(
          height: 569,
          child: TabBarView(
            controller: _tabController,
            children: [
              OrderMonth(),
              OrderTopProduct(),
            ],
          ),
        ),
      ],
    );
  }
}


