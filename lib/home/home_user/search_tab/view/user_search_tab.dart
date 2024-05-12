import 'package:doan_tn/home/home_user/search_tab/controller/search_provider.dart';
import 'package:doan_tn/home/home_user/search_tab/view/widget/body_user_search_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../base/services/dio_option.dart';
import '../../../../base/widget/SkeletonTab.dart';
import '../../../controller/brand_controller.dart';
import '../../../controller/product_provider.dart';
import '../../../service/brand_service.dart';
import '../../../service/product_services.dart';
import '../service/search_service.dart';

class UserSearchTab extends StatelessWidget {
  const UserSearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) =>
                BrandProvider(BrandService(DioOption().createDio())),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                ProductProvider(ProductService(DioOption().createDio())),
          ),
          // ChangeNotifierProvider(
          //   create: (context) =>
          //       SearchProvider(SearchService(DioOption().createDio())),
          // ),
        ],
        child: const SkeletonTab(
          title: 'Tìm kiếm',
          // title: loginProvider.user!.token ?? '',
          bodyWidgets: BodyUserSearchTab(),
          isBack: false,
          //bottomSheetWidgets: ,
        ));
  }
}
