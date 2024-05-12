import 'package:dio/dio.dart';
import 'package:doan_tn/home/home_user/notify_tab/model/notify_response.dart';
import '../../../../base/services/base_service.dart';

class NotifyService extends BaseService {
  NotifyService(Dio client) : super(client);

  Future<List<NotifyResponse>> getListNotify(int userId ) async {
    Response response = await Dio().get("http://10.0.2.2:8080/api/notifications/user/$userId",);
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<NotifyResponse> notifyList = responseData.map((json) {
          return NotifyResponse.fromJson(json);
        }).toList();
        return notifyList;
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