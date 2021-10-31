// ignore_for_file: avoid_classes_with_only_static_members
import 'package:dio/dio.dart';
import 'package:hybrid/data/mysql/constant/HttpConstant.dart';

class Httper {
  /// 全局 [dio]
  static final Dio dio = Dio();

  static void init() {
    // dio.options.baseUrl = HttpPath.BASE_PATH_GLOBAL; // 内网穿透-测试
    dio.options.baseUrl = HttpConstant.BASE_PATH_LOCAL; // 仅本地
    dio.options.connectTimeout = 10000; // ms
    dio.options.receiveTimeout = 10000; // ms
  }
}
