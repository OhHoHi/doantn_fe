import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:doan_tn/home/home_user/notify_tab/model/notify_response.dart';
import 'package:doan_tn/home/home_admin/thongke_tab/model/monthly_response.dart';
import 'package:doan_tn/home/home_user/pay/model/order_item_response.dart';
import 'package:doan_tn/home/home_user/pay/model/pay_request.dart';
import '../../../../base/services/base_service.dart';
import '../../../../base/services/services_url.dart';
import '../model/pay_response.dart';

class PayService extends BaseService {
  PayService(Dio client) : super(client);

  Future<bool> addOrder(PayRequest request) async {
    try{
      await client.post(
          ServicesUrl.addOrder,
          data: {
            "userId": request.userId,
            "status": request.status,
            "totalAmount": request.totalAmount,
            "addressId" : request.addressId,
            "orderItems": request.orderItems.map((item) => {
              "productId": item.productId,
              "quantity": item.quantity
            }).toList(), // Chuyển đổi danh sách orderItems thành định dạng phù hợp
          }
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }

  Future<List<PayResponse>> getListOrder(int userId ) async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/listOrder/$userId') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }

  Future<List<OrderItemResponse>> getListOrderItem(int orderId ) async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/byOrder/$orderId') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<OrderItemResponse> orderItemList = responseData.map((json) {
          return OrderItemResponse.fromJson(json);
        }).toList();
        return orderItemList;
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

  Future<List<PayResponse>> getListOrderAll() async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/all') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<List<PayResponse>> getListOrderAllStatus0() async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/status/0') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<List<PayResponse>> getListOrderStatus0WithUser(int userId) async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/user/$userId/status/0') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<List<PayResponse>> getListOrderAllStatusNot0() async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/status/not-0') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<List<PayResponse>> getOrdersWithStatusBetweenOneAndThree() async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/status/between-1-and-3') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<List<PayResponse>> getOrdersWithStatusBetweenOneAndThreeWithUser(int userId) async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/user/$userId/status/between-1-and-3') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<List<PayResponse>> getOrdersWithStatusLess0() async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/status/less-than-zero') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<List<PayResponse>> getOrdersWithStatusLess0WithUser(int userId) async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/user/$userId/status/less-than-zero') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<List<PayResponse>> getOrdersWithStatusOutsideOneToThree(int page , int size) async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/status/outside-1-to-3?page=$page&size=$size') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<List<PayResponse>> getOrdersWithStatusOutsideOneToThreeWith(int userId , int page , int size) async {
    Response response = await client.get('http://10.0.2.2:8080/api/orders/user/$userId/status/outside-1-to-3?page=$page&size=$size') ;
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<PayResponse> orderList = responseData.map((json) {
          return PayResponse.fromJson(json);
        }).toList();
        return orderList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }
  Future<bool> increaseStatus(int orderId) async {
    try{
      await client.put(
        "http://10.0.2.2:8080/api/orders/increaseStatus/$orderId",
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }
  Future<bool> decreaseStatus(int orderId) async {
    try{
      await client.put(
        "http://10.0.2.2:8080/api/orders/decreaseStatus/$orderId",
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }


  Future<List<MonthlyResponse>> getListOrderWithMonth() async {
    final response = await client.get('http://10.0.2.2:8080/api/orders/monthly-revenue'); // Replace with your API endpoint
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<MonthlyResponse> monthlyList = responseData.map((json) {
          return MonthlyResponse.fromJson(json);
        }).toList();
        return monthlyList;
      }
      else{
        return[];
      }
    } else {
      throw Exception('Failed to load revenue data');
    }
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