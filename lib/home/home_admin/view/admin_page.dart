import 'package:doan_tn/home/home_admin/thongke_tab/view/thongke_screen.dart';
import 'package:doan_tn/home/home_admin/view/profile_tab.dart';
import 'package:flutter/material.dart';
import '../../../values/apppalette.dart';
import '../../home_user/pay/view/order_pay_screen.dart';
import '../../home_user/search_tab/view/user_search_tab.dart';
import 'admin_product_tab.dart';

class AdminPage extends StatefulWidget {
  AdminPage({super.key , required this.selectedIndex});
  int selectedIndex = 0;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {


  static final List<Widget> _widgetOptions = <Widget>[
    const AdminProductTab(),
    const UserSearchTab(),
    const ThongKeScreen(),
    // OrderPayScreen(initialTabIndex: 0 , isAdmin: true),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[ widget.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 30,
        selectedItemColor: AppPalette.buttonColor,
        unselectedItemColor: AppPalette.thinTextColor,
        currentIndex:  widget.selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(
              icon: Icon(Icons.area_chart), label: 'Thống kê'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.payment), label: 'Các đơn cần xác nhận'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Người dùng'),
        ],
      ),
    );
  }
}
