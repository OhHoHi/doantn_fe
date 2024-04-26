import 'package:flutter/material.dart';

import '../../../values/apppalette.dart';



class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    // const UserProductsTab(),
    // const UserCartTab(),
    // const SizedBox(),
    // ProfileTab(
    //   userModel: user,
    // ),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 30,
        selectedItemColor: AppPalette.green3Color,
        unselectedItemColor: AppPalette.thinTextColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
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
