import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_end_point.dart';

class DioClient{
  DioClient._private();
  static DioClient client = DioClient._private();

  BaseOptions baseUrl = BaseOptions(baseUrl: APIEndPoint.baseUrl);
  static Dio dio=Dio();

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