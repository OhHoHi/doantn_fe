import 'dart:typed_data';

import 'package:doan_tn/auth/login/view/login_screen.dart';
import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:doan_tn/home/home_admin/view/widget/product_detail.dart';
import 'package:doan_tn/home/home_admin/view/widget/product_item.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../base/controler/consumer_base.dart';
import '../../../../values/colors.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../add_product_screen.dart';


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
      productProvider.getListProduct();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorApp.backgroundColor,
      child: ConsumerBase<ProductProvider>(
          contextData: context,
          onRepository: (rep) {
            print('================-----');
            ProductProvider pro = rep;
            if (pro.isLoading) {
              print('bat dau load');
              pro.messagesLoading = 'Đang lấy dữ liệu .....';
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   ProgressHUD.of(context)
              //       ?.showWithText(pro.messagesLoading);
              //   Future.delayed(const Duration(seconds: 1), () {
              //     ProgressHUD.of(context)
              //         ?.showWithText(pro.messagesLoading);
              //   });
              // });
            }
            return const SizedBox();
          },
          onRepositoryError: (rep) {
            print('load loi');
            return Center(
                child: Text(
                  rep.messagesError ?? '',
                  style:
                  const TextStyle(fontSize: 14, color: Colors.black),
                ));
          },
          onRepositoryNoData: (rep) {
            return const Center(
              child: Text(
                'Khong co du lieu',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            );
          },
          onRepositorySuccess: (rep) {
            print('load thanh cong');
            ProductProvider pro = rep;
            if (pro.isLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressHUD.of(context)?.dismiss();
              });
            }
            // return Expanded(
            //   child: GridView.builder(
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2, // Số cột trong lưới
            //       crossAxisSpacing: 5, // Khoảng cách giữa các cột
            //       mainAxisSpacing: 5, // Khoảng cách giữa các dòng
            //     ),
            //     itemCount: pro.listProduct.length,
            //     itemBuilder: (context, index) {
            //       return productGridItem(pro.listProduct[index]);
            //     },
            //   ),
            // );
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
                itemCount: pro.listProduct.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: pro.listProduct[index], isAdmin: true, productProvider: productProvider,);
                },
              ),
            );
            // return Expanded(
            //   child: ListView.builder(
            //     itemCount: pro.listProduct.length,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 10), // Khoảng cách giữa các item
            //         child: productGridItem(pro.listProduct[index]),
            //       );
            //     },
            //   ),
            // );

          })
    );
  }
  Widget productGridItem(ProductResponse product) {
    return
      Container(
         //padding: EdgeInsets.symmetric(horizontal: 10),
        height: 400,
        decoration:  const BoxDecoration(
          color: Colors.white ,
          shape: BoxShape.rectangle ,
          borderRadius: BorderRadius.all(Radius.circular(20)), // bo góc
          //border: Border.all(width: 4  , color: Colors.red), // viền hình
        ),
        child:
            GestureDetector(
              onTap: () {
                // Khi người dùng chọn một sản phẩm, chuyển sang trang chi tiết hoặc hiển thị widget chi tiết
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ProductDetailScreen(product: product , productProvider: productProvider, isAdmin: true,),
                //   ),
                // );
              },
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
                        return SizedBox(
                          //width: 500,
                          height: 110,
                          child: Image.memory(productProvider.images[product.id.toString()]!.first),
                        );
                      } else {
                        // Hiển thị một widget placeholder hoặc loading
                        return SizedBox(
                          width: 100,
                          height: 100,
                          child: Text('loi anh' , style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  Text('Vợt cầu lông ${product.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                  //Text('Giá: ${product.price}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold , color: Colors.red),), // Ví dụ: Hiển thị giá sản phẩm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 60,),
                      Text('Giá: ${product.price}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold , color: Colors.red),),
                       const Spacer(),
                      IconButton(
                        onPressed: () {
                          // Xử lý sự kiện khi người dùng nhấn vào nút chỉnh sửa sản phẩm
                          // Chẳng hạn, bạn có thể chuyển hướng sang màn hình chỉnh sửa sản phẩm
                        },
                        iconSize: 21,
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      );
  }
}

