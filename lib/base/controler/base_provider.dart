import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/base_service.dart';

enum Status { none, loading, error, loaded, noData }

class BaseProvider<T extends BaseService> with ChangeNotifier {

  final BuildContext? context;
  final T service;
  Status? status;
  String messagesLoading = '';
  BaseProvider(this.service, [this.context]);

  bool get isLoading => status == Status.loading;

  bool get loadingFailed => status == Status.error;

  bool get isLoaded => status == Status.loaded;

  bool get noData => status == Status.noData;

  String messagesError='';



  void resetStatus() {
    status = Status.none;
  }

  // callback sử dụng lắng nghe response nhiều api trong cùng 1 widget
  void startLoading([Function()? callback]) {
    if (callback != null) {
      callback();
      notifyListeners();
    } else {
      status = Status.loading;
      notifyListeners();
    }
  }

  void finishLoading([Function()? callback]) {
    if (callback != null) {
      callback();
      notifyListeners();
    } else {
      status = Status.loaded;
      notifyListeners();
    }
  }

  void receivedNoData([Function()? callback]) {
    if (callback != null) {
      callback();
      notifyListeners();
    } else {
      status = Status.noData;
      notifyListeners();
    }
  }

  void receivedError([Function()? callback]) {
    if (callback != null) {
      callback();
      notifyListeners();
    } else {
      status = Status.error;
      notifyListeners();
    }
  }

  void update() {
    notifyListeners();
  }

}
