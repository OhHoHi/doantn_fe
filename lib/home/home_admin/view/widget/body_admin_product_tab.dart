import 'dart:typed_data';
import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:doan_tn/home/home_admin/view/widget/product_item.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../base/controler/consumer_base.dart';
import '../../../../values/colors.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class BodyAdminProductTab extends StatefulWidget {
  const BodyAdminProductTab({Key? key}) : super(key: key);

  @override
  State<BodyAdminProductTab> createState() => _BodyHomeViewState();
}

class _BodyHomeViewState extends State<BodyAdminProductTab> {
  late ProductProvider productProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.resetPage();
      productProvider.getListProduct();
    });
  }
  Future<void> _refresh() async{
    productProvider.refresh = true;
    productProvider.resetPage();
    productProvider.getListProduct();
  }
  Future<void> _scrollListener() async {
    productProvider.loadMore();
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
        return RefreshLoadmore(
          onRefresh: _refresh,
          onLoadmore: _scrollListener,
          isLastPage: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  mainAxisExtent: 260),
              itemCount: productProvider.listProductDisplay.length,
              itemBuilder: (context, index) {
                return ProductCard(product: productProvider.listProductDisplay[index], isAdmin: true, productProvider: productProvider,);
              },
            ),
          ),
        );
      }, selector: (context, pro) {
        return pro.statusListProduct;
      }),
    );
  }
}

