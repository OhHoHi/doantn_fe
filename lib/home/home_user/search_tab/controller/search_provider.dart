//
// import 'dart:typed_data';
//
// import 'package:doan_tn/home/home_user/notify_tab/model/notify_response.dart';
// import 'package:doan_tn/home/home_user/notify_tab/service/notify_service.dart';
// import 'package:dio/dio.dart';
// import 'package:doan_tn/home/home_user/search_tab/model/serch_request.dart';
// import 'package:doan_tn/home/model/product_reponse.dart';
// import '../../../../base/controler/base_provider.dart';
// import '../service/search_service.dart';
//
// class SearchProvider extends BaseProvider<SearchService> {
//   SearchProvider(SearchService service) : super(service);
//
//   Status statusListSearch = Status.none;
//
//   late List<ProductResponse> listSearch = [] ;
//
//   Future<void> getListSearch() async {
//     resetStatus();
//     try {
//       startLoading(() {
//         statusListSearch = Status.loading;
//       });
//       listSearch = await service.getListSearch(
//           SearchRequest(
//           brandId: 1,
//           sort: "id_desc",
//           productName: "",
//           minPrice: 0,
//           maxPrice: 10000000,
//           diemCanBang: 0,
//           page: 0,
//           size: 10)
//       );
//       for (var product in listSearch) {
//         await getFirstImageForProduct(product);
//       }
//       finishLoading(() {
//         statusListSearch = Status.loaded;
//       });
//       if(listSearch.isEmpty){
//         receivedNoData(() {
//           statusListSearch = Status.noData;
//         });
//       }
//       else{
//         finishLoading(() {
//           statusListSearch = Status.loaded;
//         });
//       }
//
//     } on DioException catch (e) {
//       messagesError = e.message ?? 'Co loi he thong';
//       receivedError(() {
//         statusListSearch = Status.error;
//       });
//     }
//   }
//
//   // Phương thức để lấy ảnh đầu tiên cho mỗi sản phẩm
//   Future<void> getFirstImageForProduct(ProductResponse product) async {
//     try{
//       startLoading((){
//         statusListSearch = Status.loading;
//       });
//       final image = await service.getImageFromApi(product.imageUrls.first);
//       images[product.id.toString()] = [image!]; // Lưu ảnh đầu tiên vào danh sách ảnh của sản phẩm
//       finishLoading((){
//         statusListSearch = Status.loaded;
//       });
//     } on DioException catch (e) {
//       messagesError = e.message ?? 'Co loi he thong';
//       receivedError((){
//         statusListSearch = Status.error;
//       });
//       //receivedError();
//       // showDialog(
//       //   context: context,
//       //   builder: (BuildContext context) {
//       //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
//       //   },
//       // );
//     }
//   }
//
//
// }
