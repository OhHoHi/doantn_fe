import 'package:dio/dio.dart';
import 'package:doan_tn/home/home_admin/thongke_tab/model/monthly_response.dart';
import 'package:doan_tn/home/home_admin/thongke_tab/model/product_top_10_response.dart';
import '../../../../base/controler/base_provider.dart';
import '../servicer/thongke_service.dart';


class ThongKeProvider extends BaseProvider<ThongKeService> {
  ThongKeProvider(ThongKeService service) : super(service);

  Status statusMonthOrder= Status.none;
  Status statusTop10Product= Status.none;


  late List<MonthlyResponse> listMonthOrder = [];
  late List<ProductTop10Response> listProductTop10 = [];



  Future<void> getListOrderWithMonth() async {
    resetStatus();
    try {
      startLoading(() {
        statusMonthOrder = Status.loading;
      });
      listMonthOrder = await service.getListOrderWithMonth();
      finishLoading(() {
        statusMonthOrder = Status.loaded;
      });
      if(listMonthOrder.isEmpty){
        receivedNoData(() {
          statusMonthOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusMonthOrder = Status.loaded;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusMonthOrder = Status.error;
      });
    }
  }

  Future<void> getListOrderWithProductTop10() async {
    resetStatus();
    try {
      startLoading(() {
        statusTop10Product = Status.loading;
      });
      listProductTop10 = await service.getListOrderWithTopProduct();
      finishLoading(() {
        statusTop10Product = Status.loaded;
      });
      if(listProductTop10.isEmpty){
        receivedNoData(() {
          statusTop10Product = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusTop10Product = Status.loaded;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusTop10Product = Status.error;
      });
    }
  }

}
