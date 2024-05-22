import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import '../../../values/assets.dart';
import '../../../values/colors.dart';

class DialogBase extends StatelessWidget {
  DialogBase({this.title, this.icon, this.button, this.content,this.function, super.key});
  String? title ;
  String? content;
  String? icon;
  bool? button;
  Function()? function;
  @override
  Widget build(BuildContext context) {
    List<Widget> actionsWidget = [];
    if(button == true){
      actionsWidget.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(129, 40),
                foregroundColor: ColorApp.buttonColor,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  // bo góc của button
                ),
              ),
              child: const Text(
                "Xong",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w700),
              )),
          //SizedBox(width:10 ,),
          ElevatedButton(
              onPressed: function ?? (){Navigator.pop(context);},
              style: ElevatedButton.styleFrom(
                //padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                minimumSize: const Size(129, 40),
                foregroundColor: Colors.white,
                backgroundColor: ColorApp.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // bo góc của button
                ),
              ),
              child: const Text(
                "Xác nhận",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w700),
              )),
        ],
      ));
    }
    else{
      actionsWidget.add(
        Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 40),
                foregroundColor: Colors.white,
                backgroundColor: ColorApp.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // bo góc của button
                ),
              ),
              child: const Text(
                "Đóng",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w700),
              )),
        ),);
    }
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      icon: SvgPicture.asset(icon ?? AppAssets.iconPath),
      title:  Text(
        title ?? 'Thông báo',
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 18,
            color: ColorApp.textColorPrimary,
            fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 335,
        child: Text(
          content ?? '',
          style: const TextStyle(color: ColorApp.subTextColor, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
      actions: actionsWidget,
    );
  }
}
