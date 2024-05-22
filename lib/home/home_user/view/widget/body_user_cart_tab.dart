
import 'package:doan_tn/auth/login/model/login_response.dart';
import 'package:doan_tn/home/home_user/view/user_page.dart';
import 'package:doan_tn/home/home_user/view/user_pay_screen.dart';
import 'package:doan_tn/home/model/cart_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../../../../auth/login/model/test_luu_user.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../base/controler/consumer_base.dart';
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
    productProvider.isAllSelected = false;
  }

  String formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }

  late bool isSelected = false;



  Future<void> _deleteCart(int id) async {
    try {
      await productProvider.deleteCart(id);
      if (productProvider.checkDeleteCart == true) {
       //productProvider.getListCart(user.user.id);
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
                function:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPage(selectedIndex: 2),
                    ),
                  );
                } ,
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
    return SkeletonTab(
      title: 'Giỏ hàng',
      // title: loginProvider.user!.token ?? '',
      bodyWidgets:Selector<ProductProvider, Status>(builder: (context, value, child) {
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
        else if (value == Status.noData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ProgressHUD.of(context)?.dismiss();
          });
          return  const Center(child: Text('Ban khong có sản phẩm nào trong giỏ hàng'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        productProvider.selectAll();
                      },
                      child: const Text(
                        'Tất cả',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Open Sans",
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 104, 133, 1)),
                      )),
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productProvider.listCart.length,
                itemBuilder: (context, index) {
                  return buildData(productProvider, productProvider.listCart[index] ,index);
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
      bottomSheetWidgets: BottomSheetCart(
        productProvider: productProvider,
        productPayList: productProvider.selectedProducts,
        user: user,
      ),
    );
  }

  Widget buildData(ProductProvider productProvider , CartResponse cartResponse , int index ){
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
              Selector<ProductProvider, bool>(
                selector: (context, provider) =>
                    provider.selectedProducts.contains(productProvider.listCart[index]),
                builder: (context, isSelected, child) {
                  return Checkbox(
                    checkColor: Colors.white,
                    value: isSelected,
                    onChanged: (value) {
                     // productProvider.toggleProductSelection(productProvider.listCart[index]);
                          setState(() {
                            productProvider.toggleProductSelection(productProvider.listCart[index]);
                          });
                    },
                  );
                },
              ),
              // Checkbox(
              //   checkColor: Colors.white,
              //   value: productProvider.selectedProducts.contains(productProvider.listCart[index]),
              //   onChanged: (value) {
              //     setState(() {
              //       productProvider.toggleProductSelection(productProvider.listCart[index]);
              //     });
              //   },
              // ),
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
                        width: 100,
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
                          width: 175-39,
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
                    Selector<ProductProvider, Status>(
                        builder: (context, value, child) {
                          if (value == Status.loading) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ProgressHUD.of(context)?.show();
                            });
                            print('Bat dau load $value' );
                          } else if (value == Status.loaded) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              ProgressHUD.of(context)?.dismiss();
                            });

                            print("load thanh cong $value");
                          } else if (value == Status.error) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ProgressHUD.of(context)?.dismiss();
                              print('Load error r $value');
                            });
                          }
                          return
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  formatPrice(cartResponse.product.price),
                                  style: const TextStyle(
                                      fontSize: 16, color: AppPalette.textColor),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    // if (productProvider.selectedProducts.contains(productProvider.listCart[index])) {
                                    //   productProvider.increaseQuantity(cartResponse.id, cartResponse.user.id);
                                    // }
                                    setState(() {
                                      if (productProvider.selectedProducts.contains(productProvider.listCart[index])) {
                                        productProvider.increaseQuantity(cartResponse.id, cartResponse.user.id);
                                      }
                                    });
                                  //  productProvider.increaseQuantity(cartResponse.id , cartResponse.user.id);
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    size: 15,
                                    color: productProvider.selectedProducts.contains(productProvider.listCart[index]) ? Colors.grey : Colors.grey.withOpacity(0.1),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color: productProvider.selectedProducts.contains(productProvider.listCart[index]) ? Colors.grey : Colors.grey.withOpacity(0.1),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "${productProvider.listCart[index].quantity}",
                                  style: const TextStyle(
                                      fontSize: 16, color: AppPalette.textColor),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // if (productProvider.selectedProducts.contains(productProvider.listCart[index])) {
                                    //   productProvider.decreaseQuantity(cartResponse.id, cartResponse.user.id);
                                    // }
                                    setState(() {
                                      if (productProvider.selectedProducts.contains(productProvider.listCart[index])) {
                                        productProvider.decreaseQuantity(cartResponse.id, cartResponse.user.id);
                                      }
                                    });
                                    //productProvider.decreaseQuantity(cartResponse.id , cartResponse.user.id);
                                 //   productProvider.updateTotalAmount();
                                  },
                                  icon:  Icon(
                                    Icons.remove,
                                    size: 15,
                                    color: productProvider.selectedProducts.contains(productProvider.listCart[index]) ? Colors.grey : Colors.grey.withOpacity(0.1),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color: productProvider.selectedProducts.contains(productProvider.listCart[index]) ? Colors.grey : Colors.grey.withOpacity(0.1),),
                                    ),
                                  ),
                                ),
                              ],
                            );
                        }, selector: (context, pro) {
                      return pro.statusListCart;
                    }),

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


class BottomSheetCart extends StatelessWidget {
  const BottomSheetCart({
    Key? key,
    required this.productProvider, required this.productPayList,required this.user
  }) : super(key: key);
  final ProductProvider productProvider;
  final List<CartResponse> productPayList;
  final LoginResponse user;


  String formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }

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
                // Selector<ProductProvider, Status>(builder: (context, value, child) {
                //   if (value == Status.loading) {
                //     print('Bat dau load');
                //   } else if (value == Status.loaded) {
                //     print("load thanh cong");
                //   } else if (value == Status.error) {
                //   }
                //   return Text(
                //     // '${productProvider.totalAmount}',
                //     '${productProvider.totalAmountProvider}',
                //     style: const TextStyle(color: AppPalette.textColor, fontSize: 18),
                //   );
                // }, selector: (context, pro) {
                //   return pro.statusListCart;
                // }),
                Selector<ProductProvider, int>(
                  builder: (context, totalAmount, child) {
                    return Text(
                      '${formatPrice(totalAmount)} vnd',
                      style: const TextStyle(color: AppPalette.textColor, fontSize: 18),
                    );
                  },
                  selector: (context, provider) => provider.totalAmountProvider,
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if(productProvider.totalAmountProvider == 0){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chưa có sản phẩm nào được chọn')),
                  );
                  return;
                }else{
                  final resul = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPayScreen(productPayList:productPayList, productProvider: productProvider),
                    ),
                  );
                  if(resul == true){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPage(selectedIndex: 2),
                      ),
                    );
                  }
                }

              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.green3Color,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  minimumSize: const Size(double.infinity, 40)),
              child: const Text('Mua hàng'),
            ),
          ],
        ),
      ),
    );

  }
}



