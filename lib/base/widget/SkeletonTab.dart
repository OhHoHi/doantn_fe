import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../../values/apppalette.dart';

class SkeletonTab extends StatelessWidget {
  const SkeletonTab({
    super.key,
    required this.title,
    this.actionsWidgets,
    required this.bodyWidgets,
    required this.isBack,
    this.floatingButton,
    this.bottomSheetWidgets, this.isbg,
  });

  final String title;
  final Widget? actionsWidgets;
  final Widget bodyWidgets;
  final Widget? floatingButton;
  final Widget? bottomSheetWidgets;
  final bool isBack;
  final bool? isbg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppPalette.backgroundColor,
      backgroundColor: isbg == null ? const Color(0xffCDF8C5) : Colors.white,
      appBar: AppBar(
        backgroundColor: AppPalette.backgroundAppbarColor,
        surfaceTintColor: AppPalette.backgroundAppbarColor,
        title: Text(title,
            style: const TextStyle(
              color: AppPalette.textColor,
              fontSize: 22,
            )
        ),
        centerTitle: true,
        toolbarHeight: 100,
        automaticallyImplyLeading: isBack ? true : false,
        leading: isBack == true
            ? BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ) : const SizedBox(),
        actions: [
          actionsWidgets != null ? actionsWidgets! : const SizedBox(),
        ],
        flexibleSpace: Stack(
          children: [
            Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.centerRight,
                      colors: [Color(0xff10B77B), Color(0xff65C952), Color(0xff5EF940)],
                    ))),
            Container(
                margin: const EdgeInsets.only(top: 15),
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Image.asset('assets/images/logocaulong.png'),
                )),
          ],
        ),
      ),

      body:
      ProgressHUD(
        // indicatorColor: Colors.lightBlue,
        // backgroundColor: Colors.white,
        // textStyle: const TextStyle(
        //   color: Color.fromRGBO(0, 49, 62, 1),
        //   fontSize: 14,
        //   fontFamily: "Open Sans",
        // ),
        child: Builder(
          builder: (context) {
            return bodyWidgets;
          },
        ),
      ),
      floatingActionButton:
      floatingButton != null ? floatingButton! : const SizedBox(),
      bottomSheet: bottomSheetWidgets,
    );
  }
}