import 'dart:typed_data';
import 'package:photo_view/photo_view.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../base/services/dio_option.dart';
import '../../../../base/widget/SkeletonTab.dart';
import '../../../../base/widget/appbar_widget.dart';
import '../../../../values/apppalette.dart';
import '../../../../values/styles.dart';
import '../../../controller/product_provider.dart';
import '../../../service/product_services.dart';
import '../add_product_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key, required this.product, required this.productProvider, required this.isAdmin,
  });
  final ProductResponse product;
  final ProductProvider productProvider;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    // final productProvider = Provider.of<ProductProvider>(context);
    return
      SkeletonTab(
        title: 'Thông tin sản phẩm',
        bodyWidgets: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 350,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.images[product.id.toString()]!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(imageData:  productProvider.images[product.id.toString()]![index],),
                          ),
                        );
                      },
                      child: Image.memory(productProvider.images[product.id.toString()]![index],fit: BoxFit.cover),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),
              Text(
                product.name,
                style: const TextStyle(color: AppPalette.textColor, fontSize: 20),
              ),
              const SizedBox(height: 25),
              Text(
                product.description,
                style: const TextStyle(color: AppPalette.textColor, fontSize: 18),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Text(
                    '${product.price} vnd',
                    style: const TextStyle(
                        color: AppPalette.textColor, fontSize: 18),
                  ),
                  const Spacer(),
                  isAdmin
                      ? ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddProductScreen(productResponse: product),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.green3Color,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                    ),
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('Chỉnh sửa'),
                  )
                      : ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.green3Color,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                    ),
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: const Text('Thêm vào giỏ hàng'),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
        isBack: true,
        actionsWidgets: isAdmin
            ? Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        )
            : Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border_rounded),
          ),
        ),
      );
    //   AppBarWidget(
    //     tittle: Text(
    //       'Chi tiết sản phẩm',
    //       style: AppStyles.h5,
    //     ),
    //     haveBackButton: true,
    //     child:
    //     Scaffold(
    //       body: Container(
    //         padding: EdgeInsets.all(20),
    //         // Hiển thị thông tin chi tiết của sản phẩm
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             // SizedBox(
    //             //   height: 200,
    //             //   child: PageView.builder(
    //             //     scrollDirection: Axis.horizontal,
    //             //     itemCount: productProvider.images[product.id.toString()]!.length,
    //             //     itemBuilder: (context, index) {
    //             //       return Image.memory(productProvider.images[product.id.toString()]![index]);
    //             //     },
    //             //   ),
    //             // ),
    //             SizedBox(
    //               height: 200,
    //               child: PageView.builder(
    //                 scrollDirection: Axis.horizontal,
    //                 itemCount: productProvider.images[product.id.toString()]!.length,
    //                 itemBuilder: (context, index) {
    //                   return GestureDetector(
    //                     onTap: () {
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                           builder: (context) => FullScreenImage(imageData:  productProvider.images[product.id.toString()]![index],),
    //                         ),
    //                       );
    //                     },
    //                     child: Image.memory(productProvider.images[product.id.toString()]![index]),
    //                   );
    //                 },
    //               ),
    //             ),
    //             Text(
    //               product.name,
    //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //             ),
    //             SizedBox(height: 10),
    //             Text(
    //               product.color,
    //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //             ),
    //             Text(
    //               product.status,
    //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //             ),
    //             Text(
    //               product.chatLieuKhungVot,
    //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //             ),
    //             SizedBox(height: 10),
    //             Text('Giá: ${product.price}'),
    //             // Hiển thị các thông tin khác của sản phẩm
    //           ],
    //         ),
    //       ),
    //     )
    // );

  }
}

class FullScreenImage extends StatelessWidget {
  final Uint8List imageData;

  const FullScreenImage({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: PhotoView(
            imageProvider: MemoryImage(imageData),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}