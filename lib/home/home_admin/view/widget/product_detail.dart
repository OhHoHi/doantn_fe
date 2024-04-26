import 'dart:typed_data';
import 'package:photo_view/photo_view.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../base/services/dio_option.dart';
import '../../../../base/widget/appbar_widget.dart';
import '../../../../values/styles.dart';
import '../../../controller/product_provider.dart';
import '../../../service/product_services.dart';

class ProductDetailArguments {
  final ProductResponse product;
  final ProductProvider productProvider;
  final bool isAdmin;

  ProductDetailArguments({ required this.productProvider, required this.product, required this.isAdmin});
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.arguments,
  });

  final ProductDetailArguments arguments;

  @override
  Widget build(BuildContext context) {
    // final productProvider = Provider.of<ProductProvider>(context);
    return AppBarWidget(
        tittle: Text(
          'Chi tiết sản phẩm',
          style: AppStyles.h5,
        ),
        haveBackButton: true,
        child:
        Scaffold(
          body: Container(
            padding: EdgeInsets.all(20),
            // Hiển thị thông tin chi tiết của sản phẩm
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 200,
                //   child: PageView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: productProvider.images[product.id.toString()]!.length,
                //     itemBuilder: (context, index) {
                //       return Image.memory(productProvider.images[product.id.toString()]![index]);
                //     },
                //   ),
                // ),
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: arguments.productProvider.images[arguments.product.id.toString()]!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(imageData:  arguments.productProvider.images[arguments.product.id.toString()]![index],),
                            ),
                          );
                        },
                        child: Image.memory(arguments.productProvider.images[arguments.product.id.toString()]![index]),
                      );
                    },
                  ),
                ),
                Text(
                  arguments.product.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  arguments.product.color,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  arguments.product.status,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  arguments.product.chatLieuKhungVot,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Giá: ${arguments.product.price}'),
                // Hiển thị các thông tin khác của sản phẩm
              ],
            ),
          ),
        )
    );

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