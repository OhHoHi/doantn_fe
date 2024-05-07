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
      // child: ConsumerBase<ProductProvider>(
      //     contextData: context,
      //     onRepository: (rep) {
      //       print('================-----');
      //       ProductProvider pro = rep;
      //       if (pro.isLoading) {
      //         print('bat dau load');
      //         pro.messagesLoading = 'Đang lấy dữ liệu .....';
      //       }
      //       return const SizedBox();
      //     },
      //     onRepositoryError: (rep) {
      //       print('load loi');
      //       return Center(
      //           child: Text(
      //             rep.messagesError ?? '',
      //             style:
      //             const TextStyle(fontSize: 14, color: Colors.black),
      //           ));
      //     },
      //     onRepositoryNoData: (rep) {
      //       return const Center(
      //         child: Text(
      //           'Khong co du lieu',
      //           style: TextStyle(fontSize: 14, color: Colors.black),
      //         ),
      //       );
      //     },
      //     onRepositorySuccess: (rep) {
      //       print('load thanh cong');
      //       ProductProvider pro = rep;
      //       if (pro.isLoaded) {
      //         WidgetsBinding.instance.addPostFrameCallback((_) {
      //           ProgressHUD.of(context)?.dismiss();
      //         });
      //       }
      //       return SingleChildScrollView(
      //         padding: const EdgeInsets.all(5),
      //         child: GridView.builder(
      //           physics: const NeverScrollableScrollPhysics(),
      //           shrinkWrap: true,
      //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //               crossAxisCount: 2,
      //               mainAxisSpacing: 5,
      //               crossAxisSpacing: 5,
      //               mainAxisExtent: 260),
      //           itemCount: pro.listProduct.length,
      //           itemBuilder: (context, index) {
      //             return ProductCard(product: pro.listProduct[index], isAdmin: true, productProvider: productProvider,);
      //           },
      //         ),
      //       );
      //     })
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
              return ProductCard(product: productProvider.listProduct[index], isAdmin: true, productProvider: productProvider,);
            },
          ),
        );
      }, selector: (context, pro) {
        return pro.statusListProduct;
      }),
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
                      return const Center(
                        child: Text(
                          'Khong co du lieu',
                          style: TextStyle(fontSize: 14, color: Colors.black),
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
                        return const SizedBox(
                          width: 100,
                          height: 100,
                          child: Text('loi anh' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10,),
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

