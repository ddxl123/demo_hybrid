// ignore_for_file: avoid_classes_with_only_static_members
import 'package:dio/dio.dart';
import 'package:hybrid/data/mysql/httpstore/store/HttpStoreConfig.dart';

class Httper {
  static Dio? _dioInstance;

  static Dio get dio {
    if (_dioInstance == null) {
      _dioInstance = Dio(
        BaseOptions(
          baseUrl: HttpStoreConfig.baseUrl,
          connectTimeout: HttpStoreConfig.connectTimeout, //ms
          receiveTimeout: HttpStoreConfig.receiveTimeout, //ms
        ),
      );
      return _dioInstance!;
    } else {
      return _dioInstance!;
    }
  }
}
