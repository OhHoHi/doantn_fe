
import 'package:doan_tn/auth/login/model/login_response.dart';
import 'package:doan_tn/home/model/cart_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../../../auth/login/model/test_luu_user.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../base/widget/SkeletonTab.dart';
import '../../../../base/widget/dialog_base.dart';
import '../../../../values/apppalette.dart';
import '../../../../values/assets.dart';
import '../../../controller/product_provider.dart';

class BodyUserCartTab extends StatefulWidget {
  const BodyUserCartTab({super.key});

  @override
  State<BodyUserCartTab> createState() => _UserCartTabState();
}

class _UserCartTabState extends State<BodyUserCartTab> {
  late ProductProvider productProvider;
  late LoginResponse user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    user = TempUserStorage.currentUser!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.getListCart(user.user.id);
      print("lay id duoc khong ${user.user.id}");
    });
    print("lay duoc khong ${productProvider.totalAmount}");

  }


  @override
  Widget build(BuildContext context) {
    return SkeletonTab(
      title: 'Giỏ hàng',
      // title: loginProvider.user!.token ?? '',
      bodyWidgets:    Selector<ProductProvider, Status>(builder: (context, value, child) {
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
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productProvider.listCart.length,
                itemBuilder: (context, index) {
                  return ProductCartWidget(
                    cartResponse: productProvider.listCart[index],
                    productProvider: productProvider,
                    context: context,
                  );
                },
              ),
              const SizedBox(height: 100)
            ],
          ),
        );
      }, selector: (context, pro) {
        return pro.statusListCart;
      }),
      isBack: false,
      bottomSheetWidgets: BottomSheetCart(productProvider: productProvider),
    );
  }

}


class BottomSheetCart extends StatelessWidget {
  const BottomSheetCart({
    super.key,
    required this.productProvider,
  });
  final ProductProvider productProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Tổng tiền:',
                  style: TextStyle(color: AppPalette.textColor, fontSize: 18),
                ),
                const Spacer(),
                Selector<ProductProvider, Status>(builder: (context, value, child) {
                  if (value == Status.loading) {
                    print('Bat dau load');
                  } else if (value == Status.loaded) {
                    print("load thanh cong");
                  } else if (value == Status.error) {
                  }
                  return Text(
                    '${productProvider.totalAmount}',
                    style: const TextStyle(color: AppPalette.textColor, fontSize: 18),
                  );
                }, selector: (context, pro) {
                  return pro.statusListCart;
                }),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.green3Color,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  minimumSize: const Size(double.infinity, 40)),
              child: const Text('Thanh toán'),
            ),
          ],
        ),
      ),
    );

  }
}

class ProductCartWidget extends StatelessWidget {
  const ProductCartWidget({
    super.key,
    required this.cartResponse,
    required this.productProvider,
    required this.context,
  });

  final CartResponse cartResponse;
  final ProductProvider productProvider;
  final BuildContext context;

  //final ProductModel productResponse;
  Future<void> _deleteCart(int id) async {
    try {
      await productProvider.deleteCart(id);
      if (productProvider.checkDeleteCart == true) {
        productProvider.getListCart(cartResponse.user.id);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Product added successfully')),
        // );
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content: 'Đã XÓA sản phẩm khỏi giỏ hàng thành công',
                icon: AppAssets.icoDefault,
                button: true,
              );
            });
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to add product')),
        // );
        showDialog(
            context: context,
            builder: (context) {
              return DialogBase(
                title: 'Thông báo',
                content: 'XÓA Thất bại',
                icon: AppAssets.icoDefault,
                button: true,
              );
            });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product')),
      );
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return DialogBase(
      //         title: 'Thông báo',
      //         content: 'Thêm sản phẩm thất bại',
      //         icon: AppAssets.icoDefault,
      //         button: true,
      //       );
      //     });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 120,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Selector<ProductProvider, Status>(
                  builder: (context, value, child) {
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
                final images =
                    productProvider.images[cartResponse.product.id.toString()];
                if (images != null && images.isNotEmpty) {
                  return Container(
                    height: 90,
                    width: 100,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      // image: DecorationImage(
                      //     image: NetworkImage(product.imageUrl), fit: BoxFit.cover),
                    ),
                    child: Image.memory(
                      images.first,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  return const SizedBox(
                    height: 90,
                    width:
                        100, // Placeholder hoặc widget khác để xử lý trường hợp không có ảnh
                  );
                }
              }, selector: (context, pro) {
                return pro.statusListProduct;
              }),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          //height: 90,
                          width: 175,
                          child: Text(
                            cartResponse.product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, color: AppPalette.textColor),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              _deleteCart(cartResponse.id);
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 25,
                              color: Colors.red,
                            ))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${cartResponse.product.price}",
                          style: const TextStyle(
                              fontSize: 16, color: AppPalette.textColor),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            productProvider.increaseQuantity(cartResponse.id , cartResponse.user.id);
                            //productProvider.getListCart(cartResponse.user.id);
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 15,
                            color: Colors.grey,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                          ),
                        ),
                        Selector<ProductProvider, Status>(
                            builder: (context, value, child) {
                          if (value == Status.loading) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ProgressHUD.of(context)?.show();
                            });
                            print('Bat dau load');
                          } else if (value == Status.loaded) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              ProgressHUD.of(context)?.dismiss();
                            });
                            print("load thanh cong");
                          } else if (value == Status.error) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ProgressHUD.of(context)?.dismiss();
                              print('Load error r');
                            });
                          }
                          return Text(
                            "${cartResponse.quantity}",
                            style: const TextStyle(
                                fontSize: 18, color: AppPalette.textColor),
                          );
                        }, selector: (context, pro) {
                          return pro.statusQuantity;
                        }),
                        IconButton(
                          onPressed: () {
                            productProvider.decreaseQuantity(cartResponse.id , cartResponse.user.id);
                          },
                          icon: const Icon(
                            Icons.remove,
                            size: 15,
                            color: Colors.grey,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
