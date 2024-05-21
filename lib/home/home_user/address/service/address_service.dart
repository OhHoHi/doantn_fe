import 'package:dio/dio.dart';
import 'package:doan_tn/home/home_user/address/model/address_requets.dart';
import 'package:doan_tn/home/home_user/notify_tab/model/notify_response.dart';
import '../../../../base/services/base_service.dart';
import '../../../../base/services/services_url.dart';
import '../model/address_response.dart';

class AddressService extends BaseService {
  AddressService(Dio client) : super(client);

  Future<bool> addAddress(AddressRequest request , int userId) async {
    try{
      await client.post(
          ServicesUrl.addAddress,
          data: {
            "city": request.city,
            "district": request.district,
            "ward": request.ward,
            "street": request.street,
            "fullName" : request.fullName,
            "phone" : request.phone,
            "userId": userId,
          }
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }


  Future<List<AddressResponse>> getListAddress(int userId ) async {
    Response response = await client.get("http://10.0.2.2:8080/api/addresses/user/$userId",);
    if (response.statusCode == 200) {
      if(response.data != null){
        List<dynamic> responseData = response.data;
        List<AddressResponse> addressList = responseData.map((json) {
          return AddressResponse.fromJson(json);
        }).toList();
        return addressList;
      }
      else{
        return [];
      }
    } else {
      throw Exception('Failed to load address data');
    }
  }

  Future<bool> editAddress(AddressRequest request , int addressId , int userId) async {
    try{
      await client.put(
          "http://10.0.2.2:8080/api/addresses/update/$addressId/$userId",
          data: {
            "city": request.city,
            "district": request.district,
            "ward": request.ward,
            "street": request.street,
            "fullName" : request.fullName,
            "phone" : request.phone,
          }
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }
  Future<bool> deleteAddress(int addressId ,int userId) async {
    try{
      await client.delete(
        "http://10.0.2.2:8080/api/addresses/delete/$addressId/$userId",
      );
      return true;
    }catch (e) {
      // Xử lý ngoại lệ ở đây, nếu cần
      return false;
    }
  }
}