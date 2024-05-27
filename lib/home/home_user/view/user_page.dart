import 'package:doan_tn/home/home_user/notify_tab/view/user_notify_tab.dart';
import 'package:doan_tn/home/home_user/search_tab/view/user_search_tab.dart';
import 'package:doan_tn/home/home_user/view/user_cart_tab.dart';
import 'package:doan_tn/home/home_user/view/user_product_tab.dart';
import 'package:flutter/material.dart';

import '../../../values/apppalette.dart';
import '../../home_admin/view/profile_tab.dart';



class UserPage extends StatefulWidget {
  UserPage({super.key , required this.selectedIndex });
  int selectedIndex = 0;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  //int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const UserProductTab(),
    const UserSearchTab(),
    const UserCartTab(),
    const UserNotifyTab(),
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
      body: _widgetOptions[widget.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 30,
        selectedItemColor: AppPalette.buttonColor,
        unselectedItemColor: AppPalette.thinTextColor,
        currentIndex: widget.selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Giỏ hàng'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Người dùng'),
        ],
      ),
    );
  }
}
