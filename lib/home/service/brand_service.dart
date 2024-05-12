import 'package:dio/dio.dart';
import 'package:doan_tn/home/home_user/notify_tab/model/notify_response.dart';
import '../../../../base/services/base_service.dart';
import '../model/brand_response.dart';

class BrandService extends BaseService {
  BrandService(Dio client) : super(client);

  Future<List<BrandResponse>> getListBrand() async {
    Response response = await client.get("http://10.0.2.2:8080/api/brands/getList",);
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<BrandResponse> brandList = responseData.map((json) {
          return BrandResponse.fromJson(json);
        }).toList();
        return brandList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }


  Future<bool> deleteNotify(int notifyId ,int userId) async {
    try{
      await client.delete(
        "http://10.0.2.2:8080/api/notifications/$notifyId/user/$userId",
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }
}