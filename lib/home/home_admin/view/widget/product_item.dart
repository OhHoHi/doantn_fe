import 'dart:typed_data';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:doan_tn/home/home_admin/view/widget/product_detail.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../auth/login/model/login_response.dart';
import '../../../../auth/login/model/test_luu_user.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../values/apppalette.dart';
import '../../../controller/product_provider.dart';
import '../crud_product_tab.dart';


class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product, required this.isAdmin, required this.productProvider});
  final ProductProvider productProvider;
  final ProductResponse product;
  final bool isAdmin;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late LoginResponse user;
  late bool isInCart = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = TempUserStorage.currentUser!;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   widget.productProvider.getListCart(user.user.id);
    // });
  }
  Future<void> _addCart(int userId , int productId , int quantity) async {

    try {
      await widget.productProvider.addCart(
          userId ,
          productId,
          quantity
      );
      if (widget.productProvider.checkAddCart == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm sản phẩm vào giỏ hàng thành công')),
        );
        setState(() {
          // Cập nhật trạng thái khi thêm vào giỏ hàng thành công
          isInCart = true;
        });
      } else {
        setState(() {
          // Cập nhật trạng thái khi thêm vào giỏ hàng thành công
          isInCart = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add cart')),
        );

      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add cart')),
      );
    }
  }
  // void _navigatorToProductDetailPage(
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        onTap: ()async  {
          await widget.productProvider.getImagesForProduct(widget.product);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ProductDetailScreen(
              productProvider: widget.productProvider, product: widget.product, isAdmin: widget.isAdmin,
              )));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<ProductProvider, Status>(builder: (context, value, child) {
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
                List<Uint8List>? productImages = widget.productProvider.images[widget.product.id.toString()];
                  if (productImages != null && productImages.isNotEmpty) {
                    return Container(
                      height: 158,
                      width: 160,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        // image: DecorationImage(
                        //     image: NetworkImage(product.imageUrl), fit: BoxFit.cover),
                      ),
                      child: Image.memory(widget.productProvider.images[widget.product.id.toString()]!.first , fit: BoxFit.cover,),
                    );
                  }
                  else{
                    Container(
                      height: 158,
                      width: 160,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        // image: DecorationImage(
                        //     image: NetworkImage(product.imageUrl), fit: BoxFit.cover),
                      ),
                    );
                  }
                  return const SizedBox();
              }, selector: (context, pro) {
                return pro.statusListProduct;
              }),
              const SizedBox(height: 10,),
              Text(
                widget.product.name,maxLines: 1, overflow: TextOverflow.ellipsis,
                style:
                const TextStyle(color: AppPalette.textColor, fontSize: 14),
              ),
              const Spacer(),
              widget.isAdmin
                  ? Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    '${widget.product.price} vnd',
                    style: const TextStyle(
                      color: AppPalette.textColorRed, fontSize: 14 ,fontWeight: FontWeight.bold ,),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CrudProductScreen(productResponse: widget.product),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_rounded,
                          size: 20))
                ],
              )
                  : Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    '${widget.product.price} vnd',
                    style: const TextStyle(
                        color: AppPalette.textColorRed, fontSize: 14 ,fontWeight: FontWeight.bold ,),
                  ),
                  const Spacer(),
                  isInCart
                      ? IconButton(
                    onPressed: () {
                      // Xử lý khi người dùng nhấn vào icon khi sản phẩm đã có trong giỏ hàng
                    },
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                  )
                      : IconButton(
                    onPressed: () {
                      _addCart(user.user.id, widget.product.id, 1);
                      setState(() {
                        isInCart = true; // Cập nhật lại trạng thái khi thêm vào giỏ hàng thành công
                      });
                    },
                    icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
                  ),
                  // widget.productProvider.isInCart(widget.product) == false ?
                  // IconButton(
                  //     onPressed: () {
                  //       //addCart(user.user.id, widget.product.id, 1);
                  //       _addCart(user.user.id, widget.product.id, 1).then((_) {
                  //         setState(() {
                  //         });
                  //       });
                  //       // widget.productProvider.getListCart(user.user.id).then((_) {
                  //       //   setState(() {}); // Gọi setState để rebuild widget
                  //       // });
                  //     },
                  //     icon: const Icon(Icons.add_shopping_cart_rounded,
                  //         size: 20))
                  //     :
                  // IconButton(
                  //     onPressed: () {
                  //     },
                  //     icon: const Icon(Icons.delete,
                  //         size: 20))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
