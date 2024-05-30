import 'package:flutter/material.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../../values/colors.dart';
import '../../../controller/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../../../home_admin/view/widget/product_item.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class BodyUserProductTab extends StatefulWidget {
  const BodyUserProductTab({Key? key}) : super(key: key);

  @override
  State<BodyUserProductTab> createState() => _BodyHomeViewState();
}

class _BodyHomeViewState extends State<BodyUserProductTab> {
  late ProductProvider productProvider;
  String currentSortOption = "Mặc định";
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(_scrollListener);
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
      //color: ColorApp.backgroundColor,
      child:
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
        return RefreshLoadmore(
          onRefresh: _refresh,
          onLoadmore: _scrollListener,
          isLastPage: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(5),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Sắp xếp : "),
                  Text(currentSortOption),
                  PopupMenuButton(
                    icon: const Icon(Icons.sort),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        onTap: () {
                          productProvider.sort = "id_asc";
                          productProvider.resetPage();
                          productProvider.getListProduct();
                          setState(() {
                            currentSortOption = 'Hàng cũ nhất';
                          });
                        },
                        child: const Text('Hàng cũ nhất'),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          productProvider.sort = "id_desc";
                          productProvider.resetPage();
                          productProvider.getListProduct();
                          setState(() {
                            currentSortOption = 'Hàng mới nhất';
                          });
                        },
                        child: const Text('Hàng mới nhất'),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          productProvider.sort = "price_asc";
                          productProvider.resetPage();
                          productProvider.getListProduct();
                          setState(() {
                            currentSortOption = 'Gía tăng dần';
                          });
                        },
                        child: const Text('Gía tăng dân'),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          productProvider.sort ="price_desc";
                          productProvider.resetPage();
                          productProvider.getListProduct();
                          setState(() {
                            currentSortOption = 'Gía giảm dần';
                          });
                        },
                        child: const Text('Gía giảm dân'),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          productProvider.sort ="name_asc";
                          productProvider.resetPage();
                          productProvider.getListProduct();
                          setState(() {
                            currentSortOption = 'A -> Z';
                          });
                        },
                        child: const Text('A -> Z'),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          productProvider.sort ="name_desc";
                          productProvider.resetPage();
                          productProvider.getListProduct();
                          setState(() {
                            currentSortOption = 'Z -> A';
                          });
                        },
                        child: const Text('Z -> A'),
                      ),
                      // Thêm các tùy chọn sắp xếp khác tại đây
                    ],
                  ),
                ],
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    mainAxisExtent: 260),
                itemCount: productProvider.listProductDisplay.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: productProvider.listProductDisplay[index],
                    isAdmin: false,
                    productProvider: productProvider,
                  );
                },
              ),
            ]),
          ),
        );
      }, selector: (context, pro) {
        return pro.statusListProduct;
      }),
    );
  }
}
