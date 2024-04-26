import 'dart:typed_data';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:doan_tn/home/home_admin/view/widget/product_detail.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:flutter/material.dart';

import '../../../../base/controler/consumer_base.dart';
import '../../../../values/apppalette.dart';
import '../../../controller/product_provider.dart';


class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.isAdmin, required this.productProvider});
  final ProductProvider productProvider;
  final ProductResponse product;
  final bool isAdmin;

  // void _navigatorToProductDetailPage(
  //     BuildContext context, ProductResponse productResponse, bool isAdmin) {
  //   Navigator.pushNamed(context, '/Product',
  //       arguments:
  //       ProductDetailArguments(product: product , isAdmin: isAdmin, productProvider: productProvider,));
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ProductDetailScreen(
              productProvider: productProvider, product: product, isAdmin: isAdmin,
              )));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            children: [
              ConsumerBase<ProductProvider>(
                contextData: context,
                onRepository: (rep) {
                  print('================-----');
                  ProductProvider pro = rep;
                  if (pro.isLoading) {
                    print('bat dau load');
                    pro.messagesLoading = 'Đang lấy dữ liệu hình ảnh .....';
                  }
                  return const SizedBox();
                },
                onRepositoryError: (rep) {
                  print('load loi');
                  return Center(
                    child: Text(
                      rep.messagesError ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  );
                },
                onRepositoryNoData: (rep) {
                  return Center(
                    child: Text(
                      'Khong co du lieu',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  );
                },
                onRepositorySuccess: (rep) {
                  // final image = productProvider.images[product.imageUrls.first];
                  print('load thanh cong');
                  ProductProvider pro = rep;
                  List<Uint8List>? productImages = pro.images[product.id.toString()];
                  if (pro.isLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ProgressHUD.of(context)?.dismiss();
                    });
                  }
                  if (productImages != null && productImages.isNotEmpty) {
                    // Hiển thị các ảnh của sản phẩm
                    return
                      Container(
                        height: 190,
                        width: 160,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          // image: DecorationImage(
                          //     image: NetworkImage(product.imageUrl), fit: BoxFit.cover),
                        ),
                        child: Image.memory(productProvider.images[product.id.toString()]!.first , fit: BoxFit.cover,),
                      );
                  } else {
                    // Hiển thị một widget placeholder hoặc loading
                    return const SizedBox(
                      width: 100,
                      height: 100,
                      child: Text('loi anh' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    );
                  }
                },
              ),
              const SizedBox(height: 10,),
              Text(
                product.name,maxLines: 1, overflow: TextOverflow.ellipsis,
                style:
                const TextStyle(color: AppPalette.textColor, fontSize: 14),
              ),
              const Spacer(),
              isAdmin
                  ? Text(
                '${product.price} vnd',
                style: const TextStyle(
                    color: AppPalette.textColorRed, fontSize: 14 , fontWeight: FontWeight.bold ,),
              )
                  : Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${product.price} vnd',
                    style: const TextStyle(
                        color: AppPalette.textColor, fontSize: 14),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_shopping_cart_rounded,
                          size: 20))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
