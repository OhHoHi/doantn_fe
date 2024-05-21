import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:doan_tn/home/home_admin/thongke_tab/model/monthly_response.dart';
import 'package:doan_tn/home/home_admin/thongke_tab/model/product_top_10_response.dart';
import 'package:doan_tn/home/home_user/pay/model/order_item_response.dart';
import 'package:doan_tn/home/home_user/pay/model/pay_request.dart';
import '../../../../base/services/base_service.dart';
import '../../../../base/services/services_url.dart';

class ThongKeService extends BaseService {
  ThongKeService(Dio client) : super(client);

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

  Future<List<ProductTop10Response>> getListOrderWithTopProduct() async {
    final response = await client.get('http://10.0.2.2:8080/api/orders/product-revenue/top-10'); // Replace with your API endpoint
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<ProductTop10Response> monthlyList = responseData.map((json) {
          return ProductTop10Response.fromJson(json);
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

}