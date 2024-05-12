import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:doan_tn/home/home_user/search_tab/model/serch_request.dart';
import 'package:doan_tn/home/model/product_reponse.dart';
import '../../../../base/services/base_service.dart';
import '../../../../base/services/services_url.dart';

class SearchService extends BaseService {
  SearchService(Dio client) : super(client);

  Future<List<ProductResponse>> getListSearch(SearchRequest request ) async {
    Response response = await Dio().get(ServicesUrl.listProductSearch ,
        data: {
          "brandId" : request.brandId,
          "page" : request.page,
          "size" : request.size,
          "sort" : request.sort,
          "productName" : request.productName,
          "minPrice" : request.minPrice,
          "maxPrice" : request.maxPrice,
          "diemCanBang" : request.diemCanBang
        }
    );
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<ProductResponse> productList = responseData.map((json) {
          return ProductResponse.fromJson(json);
        }).toList();
        return productList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<Uint8List?> getImageFromApi(String nameImgae) async {
    Response<Uint8List> results = await client.get<Uint8List>(
        "http://10.0.2.2:8080/products/images/$nameImgae",
        options: Options(responseType: ResponseType.bytes));
    return results.data;
  }

//   Future<bool> deleteNotify(int notifyId ,int userId) async {
//     try{
//       await client.delete(
//         "http://10.0.2.2:8080/api/notifications/$notifyId/user/$userId",
//       );
//       return true;
//     }catch (e) {
//       // Xử lý ngoại lệ ở đây, nếu cần
//       return false;
//     }
//   }
 }