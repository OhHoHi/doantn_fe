
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:doan_tn/home/home_admin/thongke_tab/model/monthly_response.dart';
import 'package:doan_tn/home/home_user/pay/model/pay_request.dart';
import 'package:doan_tn/home/home_user/pay/model/pay_response.dart';
import '../../../../base/controler/base_provider.dart';
import '../../../model/cart_response.dart';
import '../../../model/product_reponse.dart';
import '../model/order_item_response.dart';
import '../servicer/pay_service.dart';

class PaymentProvider extends BaseProvider<PayService> {
  PaymentProvider(PayService service) : super(service);

  Status statusAddPay = Status.none;
  Status statusListOrder = Status.none;
  Status statusListOrderItem = Status.none;
  Status statusListProduct= Status.none;
  Status statusMonthOrder= Status.none;


  late List<MonthlyResponse> listMonthOrder = [];
  late List<PayResponse> listOrder = [];
  late List<PayResponse> listOrderStatus0 = [];
  late List<PayResponse> listOrderStatusNot0 = [];
  late List<PayResponse> listOrderStatus1and3 = [];
  late List<PayResponse> listOrderStatusNot1and3 = [];

  late List<PayResponse> listOrderDisplay = [];
  late List<PayResponse> listOrderStatusLess0 = [];


  late List<OrderItemResponse> listOrderItem = [];
  late List<OrderItemResponse> listOrderItem1 = [];


  late Map<String, List<Uint8List>> images = {};
  Map<int, List<OrderItemResponse>> orderItemsMap = {};



  bool? checkAddOrder;
  bool? checkIncreaseStatus;
  bool? checkDecreaseStatus;


  late int page = 0;
  late String sort = "id_desc";
  late bool canLoadMore;
  bool refresh = false;

  void resetPage() {
    page = 0;
    canLoadMore = true;
    listOrderDisplay = [];
  }

  void loadMoreOrderAllStatus0() {
    if (canLoadMore) {
      page += 1;
      getListOrderAllStatus0();
    }
  }
  void loadMoreOrderStatus0WithUser(int userId) {
    if (canLoadMore) {
      page += 1;
      getListOrderStatus0WithUser(userId);
    }
  }
  void loadMoreOrderAllStatus1end3() {
    if (canLoadMore) {
      page += 1;
      getListOrderAllStatus1end3();
    }
  }
  void loadMoreOrderStatus1end3WithUser(int userId) {
    if (canLoadMore) {
      page += 1;
      getListOrderStatus1end3WithUser(userId);
    }
  }
  void loadMoreOrderAllStatusNot1end3() {
    if (canLoadMore) {
      page += 1;
      getListOrderAllStatusNot1end3();
    }
  }
  void loadMoreOrderAllStatusNot1end3WithUser( int userId) {
    if (canLoadMore) {
      page += 1;
      getListOrderAllStatusNot1end3WithUser(userId);
    }
  }
  Future<void> addOrder(
      int userId,
      int status,
      int totalAmount,
      int addressId,
      List<CartResponse> productPayList,
      ) async {
    resetStatus();
    try {
      startLoading(() {
        statusAddPay = Status.loading;
      });
      // Tạo danh sách orderItems từ productPayList và thông tin từ các phần tử
      List<OrderItem> orderItems = productPayList.map((cartItem) {
        return OrderItem(
          productId: cartItem.product.id, // Sử dụng thông tin từ phần tử trong productPayList
          quantity: cartItem.quantity,
        );
      }).toList();
      checkAddOrder = await service.addOrder(PayRequest(userId: userId, status: status, totalAmount: totalAmount, addressId: addressId, orderItems: orderItems));
      if(checkAddOrder == true){
        finishLoading(() {
          statusAddPay = Status.loaded;
        });
      }
      else{
        receivedError(() {
          statusAddPay = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusAddPay = Status.error;
      });
    }
  }

  Future<void> getListOrderAllStatus0() async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      listOrderStatus0 = await service.getListOrderAllStatus0();
      if (listOrderStatus0.isNotEmpty) {
        for (var order in listOrderStatus0) {
          await getListOrderItem(order.id);
        }
        statusListOrder = Status.loaded;
      } else {
        statusListOrder = Status.noData;
      }
      finishLoading(() {
        statusListOrder = Status.loaded;
      });

      if(listOrderStatus0.isEmpty){
        receivedNoData(() {
          statusListOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      }

    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
    }
  }
  Future<void> getListOrderStatus0WithUser(int userId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      listOrderStatus0 = await service.getListOrderStatus0WithUser(userId);
      if (listOrderStatus0.isNotEmpty) {
        for (var order in listOrderStatus0) {
          await getListOrderItem(order.id);
        }
        statusListOrder = Status.loaded;
      } else {
        statusListOrder = Status.noData;
      }
      finishLoading(() {
        statusListOrder = Status.loaded;
      });
      if(listOrderStatus0.isEmpty){
        receivedNoData(() {
          statusListOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      }

    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
    }
  }

  Future<void> getListOrderAllStatus1end3() async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      listOrderStatus1and3 = await service.getOrdersWithStatusBetweenOneAndThree();
      if (listOrderStatus1and3.isNotEmpty) {
        for (var order in listOrderStatus1and3) {
          await getListOrderItem(order.id);
        }
        statusListOrder = Status.loaded;
      } else {
        statusListOrder = Status.noData;
      }
      finishLoading(() {
        statusListOrder = Status.loaded;
      });
      if(listOrderStatus1and3.isEmpty){
        receivedNoData(() {
          statusListOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
    }
  }
  Future<void> getListOrderStatus1end3WithUser(int userId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      listOrderStatus1and3 = await service.getOrdersWithStatusBetweenOneAndThreeWithUser(userId);
      if (listOrderStatus1and3.isNotEmpty) {
        for (var order in listOrderStatus1and3) {
          await getListOrderItem(order.id);
        }
        statusListOrder = Status.loaded;
      } else {
        statusListOrder = Status.noData;
      }
      finishLoading(() {
        statusListOrder = Status.loaded;
      });
      if(listOrderStatus1and3.isEmpty){
        receivedNoData(() {
          statusListOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      }

    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
    }
  }
  Future<void> getListOrderAllStatusNot1end3() async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      listOrderStatusNot1and3 = await service.getOrdersWithStatusOutsideOneToThree(page , 10);
      if (listOrderStatusNot1and3.isNotEmpty) {
        for (var order in listOrderStatusNot1and3) {
          await getListOrderItem(order.id);
        }
        statusListOrder = Status.loaded;
      } else {
        statusListOrder = Status.noData;
      }
      if (refresh == true) {
        listOrderDisplay = listOrderStatusNot1and3;
        refresh=false;
      } else {
        listOrderDisplay += listOrderStatusNot1and3;
      }
      if (listOrderStatusNot1and3.length <10) {
        canLoadMore = false;
      }
      finishLoading(() {
        statusListOrder = Status.loaded;
      });
      if(listOrderStatusNot1and3.isEmpty){
        receivedNoData(() {
          statusListOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      }

    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
    }
  }
  Future<void> getListOrderAllStatusNot1end3WithUser(int userId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      listOrderStatusNot1and3 = await service.getOrdersWithStatusOutsideOneToThreeWith(userId , page , 10);
      if (listOrderStatusNot1and3.isNotEmpty) {
        for (var order in listOrderStatusNot1and3) {
          await getListOrderItem(order.id);
        }
        statusListOrder = Status.loaded;
      } else {
        statusListOrder = Status.noData;
      }
      if (refresh == true) {
        listOrderDisplay = listOrderStatusNot1and3;
        refresh=false;
      } else {
        listOrderDisplay += listOrderStatusNot1and3;
      }
      if (listOrderStatusNot1and3.length <10) {
        canLoadMore = false;
      }
      finishLoading(() {
        statusListOrder = Status.loaded;
      });
      if(listOrderStatusNot1and3.isEmpty){
        receivedNoData(() {
          statusListOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      }

    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
    }
  }
  Future<void> getListOrderAll() async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      listOrder = await service.getListOrderAll();
      if (listOrder.isNotEmpty) {
        for (var order in listOrder) {
          await getListOrderItem(order.id);
        }
        statusListOrder = Status.loaded;
      } else {
        statusListOrder = Status.noData;
      }
      finishLoading(() {
        statusListOrder = Status.loaded;
      });


      if(listOrder.isEmpty){
        receivedNoData(() {
          statusListOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      }

    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
    }
  }
  Future<void> getListOrder(int userId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      listOrder = await service.getListOrder(userId);
      if (listOrder.isNotEmpty) {
        for (var order in listOrder) {
          await getListOrderItem(order.id);
        }
        statusListOrder = Status.loaded;
      } else {
        statusListOrder = Status.noData;
      }
      finishLoading(() {
        statusListOrder = Status.loaded;
      });


      if(listOrder.isEmpty){
        receivedNoData(() {
          statusListOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      }

    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
    }
  }

  Future<void> getListOrderItem(int orderId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrderItem = Status.loading;
      });
      var items = await service.getListOrderItem(orderId);
      if (items.isNotEmpty) {
        orderItemsMap[orderId] = items;
        listOrderItem.addAll(items);
        for (var item in items) {
          // Gọi hàm lấy ảnh cho mỗi sản phẩm trong đơn hàng
          await getFirstImageForProduct(item.product);
        }
        finishLoading(() {
          statusListOrderItem = Status.loaded;
        });
        if (listOrder.isEmpty) {
          receivedNoData(() {
            statusListOrderItem = Status.noData;
          });
        }
        else {
          finishLoading(() {
            statusListOrderItem = Status.loaded;
          });
        }
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrderItem = Status.error;
      });
    }
  }
  Future<void> getListOrderItem1(int orderId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrderItem = Status.loading;
      });
      var items1 = await service.getListOrderItem(orderId);
      if (items1.isNotEmpty) {
        orderItemsMap[orderId] = items1;
        listOrderItem1.addAll(items1);
        for (var item in items1) {
          // Gọi hàm lấy ảnh cho mỗi sản phẩm trong đơn hàng
          await getFirstImageForProduct(item.product);
        }
        finishLoading(() {
          statusListOrderItem = Status.loaded;
        });
        if (listOrder.isEmpty) {
          receivedNoData(() {
            statusListOrderItem = Status.noData;
          });
        }
        else {
          finishLoading(() {
            statusListOrderItem = Status.loaded;
          });
        }
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrderItem = Status.error;
      });
    }
  }

  Future<void> getFirstImageForProduct(ProductResponse product) async {
    try{
      startLoading((){
        statusListProduct = Status.loading;
      });
      final image = await service.getImageFromApi(product.imageUrls.first);
      images[product.id.toString()] = [image!]; // Lưu ảnh đầu tiên vào danh sách ảnh của sản phẩm
      finishLoading((){
        statusListProduct = Status.loaded;
      });
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError((){
        statusListProduct = Status.error;
      });
    }
  }
  Future<void> getListOrderAllStatusLess0() async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      listOrderStatusLess0 = await service.getOrdersWithStatusLess0();
      if (listOrderStatusLess0.isNotEmpty) {
        for (var order in listOrderStatusLess0) {
          await getListOrderItem(order.id);
        }
        statusListOrder = Status.loaded;
      } else {
        statusListOrder = Status.noData;
      }
      finishLoading(() {
        statusListOrder = Status.loaded;
      });
      if(listOrderStatusLess0.isEmpty){
        receivedNoData(() {
          statusListOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
    }
  }
  Future<void> getListOrderStatusLess0WithUser(int userId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      listOrderStatusLess0 = await service.getOrdersWithStatusLess0WithUser(userId);
      if (listOrderStatusLess0.isNotEmpty) {
        for (var order in listOrderStatusLess0) {
          await getListOrderItem(order.id);
        }
        statusListOrder = Status.loaded;
      } else {
        statusListOrder = Status.noData;
      }
      finishLoading(() {
        statusListOrder = Status.loaded;
      });
      if(listOrderStatusLess0.isEmpty){
        receivedNoData(() {
          statusListOrder = Status.noData;
        });
      }
      else{
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      }

    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
    }
  }
  Future<void> increaseStatus(int orderId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      //startLoading();
      checkIncreaseStatus = await service.increaseStatus(orderId);
      if (checkIncreaseStatus == true) {
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
      //  getListOrderAll();
      }
      else{
        receivedError(() {
          statusListOrder = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
      //receivedError();
    }
  }
  Future<void> decreaseStatus(int orderId) async {
    resetStatus();
    try {
      startLoading(() {
        statusListOrder = Status.loading;
      });
      //startLoading();
      checkDecreaseStatus = await service.decreaseStatus(orderId);
      if (checkIncreaseStatus == true) {
        finishLoading(() {
          statusListOrder = Status.loaded;
        });
        //  getListOrderAll();
      }
      else{
        receivedError(() {
          statusListOrder = Status.error;
        });
      }
    } on DioException catch (e) {
      messagesError = e.message ?? 'Co loi he thong';
      receivedError(() {
        statusListOrder = Status.error;
      });
      //receivedError();
    }
  }
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

}
