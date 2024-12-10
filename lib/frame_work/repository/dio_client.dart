import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../ui/utils/common_service/helper.dart';
import 'api_end_point.dart';

class DioClient{
  DioClient._private();
  static DioClient client = DioClient._private();

  BaseOptions baseUrl = BaseOptions(baseUrl: APIEndPoint.baseUrl);
  static Dio dio=Dio()..interceptors.add(Logging());

  Future postDataWithJson(String endpoint, Map<String, dynamic> requestBody) async{
  dio.options = baseUrl;
  return dio.post(endpoint, data: jsonEncode(requestBody));
  }

  ///-------json data ------///
  Future postDataWithJsonWithBearerToken(String endpoint, Map<String, dynamic> requestBody,Options options) async{
    dio.options = baseUrl;
    return dio.post(endpoint, data: jsonEncode(requestBody),options:options);
  }

  ///-----for file attachment ----///
  Future postDataWithForm(String endpoint, {required FormData formData}) async{
    dio.options = baseUrl;
    return dio.post(endpoint, data: formData);
  }
  Future postDataWithFormWithBearerToken(String endpoint, {required FormData formData,required Options options}) async{
    dio.options = baseUrl;
    return dio.post(endpoint, data: formData,options:options);
  }


  Future postDataWithBearerToken(String endpoint,Options options) async{
    dio.options = baseUrl;
    return dio.post(endpoint,options: options);
  }


  Future getData(String endpoint)async{
    dio.options = baseUrl;
    return dio.get(endpoint);
  }
  Future getDataWithBearerToken(String endpoint,Options options)async{
    dio.options = baseUrl;
    return dio.get(endpoint,options: options);
  }

}



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class Logging extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    kPrint("OnRequest Header : ${options.headers}");
    kPrint('\nREQUEST[${options.method}] => PATH: ${options.baseUrl + options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    kPrint('RESPONSE[${response.statusCode}] \n \n');
    kPrint('RESPONSE DATA[${response.data}] \n \n');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      kPrint("Connection Timeout Exception");
    }
    kPrint("ERROR : ${err.message}");
    kPrint('ERROR[${err.response?.statusCode ?? 100}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
