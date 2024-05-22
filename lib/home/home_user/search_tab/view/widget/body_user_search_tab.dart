import 'package:doan_tn/home/controller/brand_controller.dart';
import 'package:doan_tn/home/controller/product_provider.dart';
import 'package:doan_tn/home/home_user/search_tab/controller/search_provider.dart';
import 'package:doan_tn/home/home_user/search_tab/view/widget/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../base/controler/base_provider.dart';
import '../../../../../values/colors.dart';
import '../../../../../values/styles.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

import '../../../../home_admin/view/widget/product_item.dart';

class BodyUserSearchTab extends StatefulWidget {
  const BodyUserSearchTab({Key? key}) : super(key: key);

  @override
  State<BodyUserSearchTab> createState() => _BodyUserSearchTabState();
}

class _BodyUserSearchTabState extends State<BodyUserSearchTab> {
  late BrandProvider brandProvider;
  late ProductProvider productProvider;
  // late SearchProvider searchProvider;
  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    brandProvider = Provider.of<BrandProvider>(context, listen: false);
    // searchProvider = Provider.of<SearchProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.resetPage();
      productProvider.resetPageSearch();
      brandProvider.getListBrand();
      productProvider.getListSearch();
    });
  }
  Future<void> _refresh() async{
    productProvider.refreshSearch = true;
    productProvider.resetPageSearch();
    // productProvider.refreshAllSearch();
    productProvider.getListSearch();
  }
  Future<void> _scrollListener() async {
    productProvider.loadMoreSearch();
  }
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarWidget(
            hintText: "Nhập tên sản phẩm",
            productProvider: productProvider,
            brandProvider: brandProvider,
          ),
          const SizedBox(height: 10,),
          Text("Thương hiệu" , style: AppStyles.nuntio_25),
          const SizedBox(height: 10,),
          Selector<BrandProvider, Status>(builder: (context, value, child) {
            if (value == Status.loading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressHUD.of(context)
                    ?.show();
              });
            } else if (value == Status.loaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressHUD.of(context)?.dismiss();
              });
            }  else if (value == Status.error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressHUD.of(context)?.dismiss();
              });
              return const Center(child: Text('Khong co du lieu'));
            }
            else if (value == Status.noData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressHUD.of(context)?.dismiss();
              });
              return const Center(child: Text('Khong co du lieu'));
            }
            return
              SizedBox(
                height: 53,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: brandProvider.listBrand.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150, // Độ rộng của mỗi item
                        child: InkWell(
                          onTap: (){
                            productProvider.resetPageSearch();
                            productProvider.selectedBrand = brandProvider.listBrand[index];
                            productProvider.getListSearch();
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0), // Đặt bán kính bo tròn
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(brandProvider.listBrand[index].name ,
                                    style: const TextStyle(color: Colors.black, fontSize: 16,
                                        fontFamily: "Nuntio")
                                ), // Hiển thị tên brand
                                // Thêm các thông tin khác về brand ở đây nếu cần
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );

          }, selector: (context, pro) {
            return pro.statusListBrand;
          }),
          const SizedBox(height: 10,),
          Text("Danh sách sản phẩm" , style: AppStyles.nuntio_25),
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
              return const Center(child: Text('Khong có kết quả nào'));
            }
            else if (value == Status.noData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressHUD.of(context)?.dismiss();
              });
              return const Center(child: Text('Khong có kết quả nào'));
            }
            return SizedBox(
              height: 395,
              child: RefreshLoadmore(
                onRefresh: _refresh,
                onLoadmore: _scrollListener,
                isLastPage: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(5),
                  child: Column(children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          mainAxisExtent: 260),
                      itemCount: productProvider.listSearchDisplay.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product:productProvider.listSearchDisplay[index],
                          isAdmin: false,
                          productProvider: productProvider,
                        );
                      },
                    ),
                  ]),
                ),
              ),
            );
          }, selector: (context, pro) {
            return pro.statusListSearch;
          }),

        ],
      ),
    );
  }
}
