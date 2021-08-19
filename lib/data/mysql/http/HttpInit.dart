import 'package:dio/dio.dart';
import 'package:hybrid/data/mysql/constant/HttpConstant.dart';

/// 全局 [dio]
final Dio dio = Dio();

class HttpInit {
  void init() {
    // dio.options.baseUrl = HttpPath.BASE_PATH_GLOBAL; // 内网穿透-测试
    dio.options.baseUrl = HttpConstant.BASE_PATH_LOCAL; // 仅本地
    dio.options.connectTimeout = 60000; // ms
    dio.options.receiveTimeout = 60000; // ms
  }
}
