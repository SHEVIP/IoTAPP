
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class NetworkUtil {
  late final Dio _dio;
  String baseUrl = "http://159.138.20.163:10086/api/v1/";
  Map<String, String>? headers;

  // 单例模式
  static NetworkUtil? _instance = NetworkUtil._init();

  NetworkUtil._init() {
    BaseOptions options = BaseOptions(baseUrl: baseUrl, headers: headers);
    _dio = Dio(options);
  }

  static NetworkUtil getInstance() {
    _instance ??= NetworkUtil._init();
    return _instance!;
  }

  // GET方法
  Future<Response?> get(String url, {option, params}) async {
    Response response;
    try {
      response = await _dio.get(
          url,
          queryParameters: params,
          options: Options(
            responseType: ResponseType.json,
            validateStatus: (status) {
              return true; // 服务器错误（状态码>=500）时抛出异常
            },
            ));
      debugPrint(response.data['error']);
      return response;
    } on Exception catch (e) {
      debugPrint("GET方法出错:${e.toString()}");
      return null;
    }
  }

  // POST方法
  Future<Response?> post(api, {params}) async {
    Response response;
    try {
      response =  await _dio.post(
        api,
        queryParameters: params,
        options: Options(
        validateStatus: (status) {
          return true; // 服务器错误（状态码>=500）时抛出异常
        },
      ),
      );
      return response;
    } on Exception catch (e) {
      debugPrint("POST方法出错:${e.toString()}");
      return null;
    }
  }

  // PUT方法
  Future<Response?> put(api, {params}) async {
    try {
      return await _dio.put(
        api,
        queryParameters: params,
        options: Options(
        validateStatus: (status) {
          return true; // 服务器错误（状态码>=500）时抛出异常
        },
      ),
      );
    } on Exception catch (e) {
      debugPrint("PUT方法出错:${e.toString()}");
      return null;
    }
  }
}
