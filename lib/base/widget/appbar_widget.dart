import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';


class AppBarWidget extends StatelessWidget {
  const AppBarWidget(
      {super.key,
        required this.child,
        this.tittle,
        this.haveNotiButton,
        this.haveBackButton, this.floatButton, this.bottomBar});

  final Widget child;
  final Widget? tittle;
  final bool? haveNotiButton;
  final bool? haveBackButton;
  final Widget? floatButton;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: tittle,
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 104, 133, 1),
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.02),
        actions: <Widget>[
          haveNotiButton == true
          ? SizedBox() :
          const SizedBox(),
        ],
        leading: haveBackButton == true
            ? BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        )
            : const SizedBox(),
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
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ProgressHUD(
            indicatorColor: Colors.lightBlue,
            backgroundColor: Colors.white,
            textStyle: const TextStyle(
              color: Color.fromRGBO(0, 49, 62, 1),
              fontSize: 14,
              fontFamily: "Open Sans",
            ),
            child: Builder(
              builder: (context) {
                return child;
              },
            ),
          )),
      floatingActionButton:(floatButton != null) ?floatButton : const SizedBox(),
      bottomNavigationBar: (bottomBar != null) ?bottomBar : const SizedBox(),
    );
  }
}
