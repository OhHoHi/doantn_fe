// ignore_for_file: constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doan_tn/base/services/services_url.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/io.dart';
import 'package:shared_preferences/shared_preferences.dart';


const HANDLE401 = "HANDLE401";

class DioOption {
  Dio? client;
  int refreshTokenNumber = 0;

  HttpClientAdapter createHttpClientAdapter() {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return true; // Verify the certificate.
    };
    return IOHttpClientAdapter(
      createHttpClient: () => client,
    );
  }

  Dio createDio({xFormUrl = false, addToken = true}) {
    refreshTokenNumber = 0;
    client = Dio();
    client!.httpClientAdapter = createHttpClientAdapter();
    client!.options.connectTimeout = const Duration(
        milliseconds: 10000); // Đặt thời gian kết nối tối đa là 10 giây
    client!.options.receiveTimeout = const Duration(
        milliseconds:
        10000); // Đặt thời gian chờ nhận dữ liệu tối đa là 10 giây
    client!.interceptors
        .add(QueuedInterceptorsWrapper( //cung cấp cơ chế truy cập tuần tự
        onRequest: (RequestOptions options, handler) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          //options.headers.addAll({'Accept': '*/*'});
          if (xFormUrl == true) {
            options.headers
                .addAll({'content-type': 'application/x-www-form-urlencoded'});
          } else {
            // options.headers.addAll({'Content-Type': 'application/json'});
            options.headers['content-Type'] = 'application/json';
          }
          if (addToken) {
            getAccessToken(options);
            //options.headers.addAll({'x-authentication-token': '7e47a8bb93fde04eb03ea91ee0e93c28'});
          }
          // setXAppData(options);
          return handler.next(options);
        }, onResponse: (Response response, handler) async {
      print(
          'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions
              .path}');
      // Do something with response data
      // return response; // continue
      return handler.next(response);
    }, onError: (DioException error, handler) async {
      print(
          'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions
              .path}');
      final requestPath = error.requestOptions.path;
      //   final connectivityResult = await Connectivity().checkConnectivity();

      if (false) {
        // error.error = AppStrings.noInternet;
      } else {
        // if (!kReleaseMode) {
        try {
          if (error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionTimeout) {
            print("het thoi gian nhan data");
          }
          //else if (error.type == DioErrorType.response)
              {
            switch (error.response!.statusCode) {
              case 400:
                print("loi 400");
              case 500:
                print('Loi 500');
                return handler
                    .next(CustomDioError(error, error.requestOptions));
              case 401:
                if (error.requestOptions.path == ServicesUrl.postLogin) {
                  //error.error = error.response?.data['message'] ?? '';
                  return handler
                      .next(CustomDioError(error, error.requestOptions));
                } else {
                  //  error.error = error.response?.data['status']['message'] ?? '';
                  if (addToken) {
                    if (refreshTokenNumber >= 1) {
                      //error.error= HANDLE401;
                      return handler
                          .next(CustomDioError(error, error.requestOptions));
                    } else {
                      //print('refreshToken-----------------------');
                      //return refreshToken(addToken, error, handler);
                    }
                  }
                }
                break;
              case 404:
                print('loi 404');
                //error.error = 'Trang truy cập không tồn tại.';
                return handler
                    .next(CustomDioError(error, error.requestOptions));
            // break;
              case 403:
                print('loi 403');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      return handler.next(CustomDioError(error, error.requestOptions));
      // CustomDioError(error, error.requestOptions);
    }));
    client!.interceptors.add(
      LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          request: false,
          requestBody: true,
          logPrint: printWrapped),
    );
    // if (Platform.isAndroid) {
    //   (client!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client)
    //   {
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //     return client;
    //   };
    // }
    return client!;
  }

  Future<void> getAccessToken(RequestOptions options) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(('token') ?? "");
      // print('-----------token: $token');
      if (prefs != null) {
        options.headers.addAll({'x-authentication-token': '$token'});
        // options.headers.addAll({'x-authentication-token': '0591b341c666f4d765b5d9f75995326a'});
        // // options.headers["x-authentication-token"] = await getAccessToken();
      } else {}
    } catch (e) {}
  }


  // Future<void> setXAppData(RequestOptions options) async {
  //   List<Map<String, dynamic>> xdata = [];
  //
  //   var office = await SharedPrefSaveDataUtil.getUserConfigEOffice();
  //   final ecabinet = await SharedPrefSaveDataUtil.getUserConfigECabinet();
  //   try {
  //     if (office.username != null) {
  //       xdata.add({'app': 'office', 'user': office.username});
  //     }
  //     if (ecabinet != null && ecabinet.taiKhoan != null) {
  //       xdata.add({'app': 'ecabinet', 'user': ecabinet.taiKhoan});
  //     }
  //     if (xdata.isNotEmpty) {
  //       options.headers.addAll({'x-app': json.encode(xdata)});
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("ERROR: $e");
  //     }
  //   }
  // }

  void printWrapped(Object object) {
    String text = object.toString();
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    //pattern.allMatches(text).forEach((match) => log(match.group(0) ?? ''));
  }

  // Future<void> refreshToken(bool isLogin, DioException error,
  //     ErrorInterceptorHandler handler) async {
  //   //bool saveMember = await SharedPrefSaveDataUtil.getRemember();
  //   bool saveMember = true;
  //   if (saveMember) {
  //     //String rawJson = await SecureStorage().read('password');
  //     var userName = "";
  //     var passWord = "";
  //     try {
  //       //Map<String, dynamic> result = jsonDecode(rawJson);
  //       userName = await SecureStorage().read('name');
  //       passWord = await SecureStorage().read('password');
  //     } catch (e) {
  //       debugPrint("jsonDecode");
  //     }
  //     refreshTokenNumber++;
  //     try {
  //       //final firebaseToken = await ManagerPushNotify.getToken();
  //       final responseOffice = await client!.fetch<Map<String, dynamic>>(
  //           _setStreamType<LoginResponse>(Options(
  //             // headers: {'Authorization': 'Bearer ${loginResponse.accessToken}'},
  //             method: 'POST',
  //           ).compose(client!.options, ServicesUrl.postLogin,
  //               data: LoginRequest(
  //                   username: userName,
  //                   password: passWord,
  //                   tokenFireBase: "")
  //                   .toJson())));
  //       refreshTokenNumber = 0;
  //       LoginResponse loginOfficeResponse =
  //       LoginResponse.fromJson(responseOffice.data!);
  //       // print('-----------token success---------------');
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setString('token', loginOfficeResponse.data.token ?? '');
  //
  //       // String? token = prefs.getString(('token') ?? "");
  //       //print('-------token after:${loginOfficeResponse.data.token}');
  //       // await AppPreferencesUtil.saveAccessToken(
  //       //     loginOfficeResponse.data.token ?? '');
  //       // await AppPreferencesUtil.saveLoginModel(loginOfficeResponse.data);
  //       return _retry(error.requestOptions, handler, '');
  //     } on DioException catch (error) {
  //       //error.error = HANDLE401;
  //       //print('lỗi token -----------------------');
  //       return handler.next(CustomDioError(error, error.requestOptions));
  //     }
  //   }
  //   // else {
  //   //   //error.error = HANDLE401;
  //   //   return handler.next(CustomDioError(error, error.requestOptions));
  //   // }
  // }

  Future<void> _retry(RequestOptions requestOptions,
      ErrorInterceptorHandler handler, String accessToken) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    try {
      final cloneReq = await client!.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
      return handler.resolve(cloneReq);
    } on DioException catch (error) {
      // error.error = HANDLE401;
      return handler.next(CustomDioError(error, error.requestOptions));
    }
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}

class CustomDioError extends DioException {
  CustomDioError(DioException dioError, RequestOptions requestOptions)
      : super(
    requestOptions: dioError.requestOptions,
  ) {
    // response = dioError.response;
    // type = dioError.type;
    requestOptions = dioError.requestOptions;
    // error = dioError.error;
  }

  @override
  String toString() {
    return error.toString();
  }
}
