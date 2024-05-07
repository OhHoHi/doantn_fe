import 'package:doan_tn/auth/login/controller/login_provider.dart';
import 'package:flutter/material.dart';
import '../../../../auth/login/model/login_response.dart';
import '../../../../auth/login/model/test_luu_user.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../base/controler/consumer_base.dart';
import '../../../../values/colors.dart';
import '../../../controller/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../../../home_admin/view/widget/product_item.dart';

class BodyUserProductTab extends StatefulWidget {
  const BodyUserProductTab({Key? key}) : super(key: key);

  @override
  State<BodyUserProductTab> createState() => _BodyHomeViewState();
}

class _BodyHomeViewState extends State<BodyUserProductTab> {
  late ProductProvider productProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.getListProduct();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: ColorApp.backgroundColor,
      child: Selector<ProductProvider, Status>(builder: (context, value, child) {
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
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(5),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                mainAxisExtent: 260),
            itemCount: productProvider.listProduct.length,
            itemBuilder: (context, index) {
              return ProductCard(product: productProvider.listProduct[index], isAdmin: false, productProvider: productProvider,);
            },
          ),
        );
      }, selector: (context, pro) {
        return pro.statusListProduct;
      }),
    );
  }
}
