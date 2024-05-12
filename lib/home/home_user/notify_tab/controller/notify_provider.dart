
import 'package:doan_tn/home/home_user/notify_tab/model/notify_response.dart';
import 'package:doan_tn/home/home_user/notify_tab/service/notify_service.dart';
import 'package:dio/dio.dart';
import '../../../../base/controler/base_provider.dart';

class NotifyProvider extends BaseProvider<NotifyService> {
  NotifyProvider(NotifyService service) : super(service);

  Status statusListNotify = Status.none;
  Status statusDelete = Status.none;

  late List<NotifyResponse> listNotify ;
  bool? checkDelete;


  Future<void> getListNotify(int userId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListNotify = Status.loading;
      });
      listNotify = await service.getListNotify(userId);
      finishLoading(() {
        statusListNotify = Status.loaded;
      });
      if(listNotify.isEmpty){
        receivedNoData(() {
          statusListNotify = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListNotify = Status.loaded;
        });
      }

    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListNotify = Status.error;
      });
    }
  }

  Future<void> deleteNotify(int notifyId , int userId)async {
    resetStatus();
    try {
      startLoading((){
        statusDelete = Status.loading;
      });
      // startLoading();
      checkDelete = await service.deleteNotify(notifyId, userId);
      if(checkDelete == true){
        finishLoading(() {
          statusDelete = Status.loaded;
        });
      }
      else{
        receivedError(() {
          statusDelete = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusDelete = Status.error;
      });
      // receivedError();
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogBase(title:"Thất bại", icon: AppAssets.iconFail,content: "Có lỗi hệ thống",);
      //   },
      // );
    }
  }

}
