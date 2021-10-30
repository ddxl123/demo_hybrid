// ignore_for_file: camel_case_types

import 'package:dio/dio.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'HttpResponseIntercept.dart';

abstract class ResponseCodeCollect extends DoSerializable {}

abstract class ResponseDataVO extends DoSerializable {}

class HttpResponse<RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO> extends DoSerializable {
  HttpResponse({
    required this.responseCodeCollect,
    required this.putResponseDataVO,
  });

  factory HttpResponse.fromJson(
      Map<String, Object?> json, RESPDVO? respdvo(Map<String, Object?>? respdvoJson), RESPCCOL respccol(Map<String, Object?> respccolJson)) {
    return HttpResponse<RESPCCOL, RESPDVO>(
      putResponseDataVO: (Map<String, Object?>? newResponseDataVO) => respdvo(newResponseDataVO),
      responseCodeCollect: respccol((json['responseCodeCollect']! as Map<Object?, Object?>).cast<String, Object?>()),
    )
      ..responseHeaders = json['responseHeaders'] as Map<String, Object?>?
      ..responseDataVO = json['responseDataVO'] == null ? null : respdvo((json['responseDataVO']! as Map<Object?, Object?>).cast<String, Object?>())
      ..isContinue = json['isContinue']! as bool
      ..code = json['code'] as int?
      ..viewMessage = json['viewMessage'] as String?
      ..description = json['description'] == null ? null : Description.fromJson((json['description']! as Map<Object?, Object?>).cast<String, Object?>())
      ..exception = json['exception'] == null ? null : Exception(json['exception']!)
      ..stackTrace = json['stackTrace'] == null ? null : StackTrace.fromString(json['stackTrace']! as String);
  }

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'responseHeaders': responseHeaders,
        'responseCodeCollect': responseCodeCollect.toJson(),
        'responseDataVO': responseDataVO?.toJson(),
        'putResponseDataVO': null,
        'isContinue': isContinue,
        'code': code,
        'viewMessage': viewMessage,
        'description': description?.toJson(),
        'exception': exception?.toString(),
        'stackTrace': stackTrace?.toString(),
      };

  /// 响应码集。
  RESPCCOL responseCodeCollect;

  /// 对 [responseDataVO] 进行预配置。
  RESPDVO? Function(Map<String, Object?> json) putResponseDataVO;

  /// 响应体 data VO 模型。
  RESPDVO? responseDataVO;

  /// 响应头。
  Map<String, Object?>? responseHeaders;

  /// 不存在异常时为 true。
  bool isContinue = false;

  /// 真正的响应码。
  int? code;

  /// 响应消息。
  String? viewMessage;

  Description? description;

  Object? exception;

  StackTrace? stackTrace;

  void _setAll({
    required Map<String, Object?>? responseHeaders,
    required RESPDVO? responseDataVO,
    required bool isContinue,
    required int? code,
    required String? viewMessage,
    required Description? description,
    required Object? exception,
    required StackTrace? stackTrace,
  }) {
    this.responseHeaders = responseHeaders;
    this.responseDataVO = responseDataVO;
    this.isContinue = isContinue;
    this.code = code;
    this.viewMessage = viewMessage;
    this.description = description;
    this.exception = exception;
    this.stackTrace = stackTrace;
  }

  /// [code] 值为 -1 表示本地异常。
  void setCancel(String viewMessage, Description description, Object? exception, StackTrace? stackTrace) {
    _setAll(
      responseHeaders: null,
      responseDataVO: null,
      isContinue: false,
      code: -1,
      viewMessage: viewMessage,
      description: description,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  void setPass(Response<Map<String, Object?>> response) {
    try {
      // 若失败则直接抛异常，在异常里会进行捕获处理。
      _setAll(
        isContinue: true,
        // 云端响应的 code 不能为空。
        code: response.data!['code']! as int,
        // 云端响应的 viewMessage 不能为空。
        viewMessage: response.data!['message']! as String,
        description: Description('描述见云端日志。'),
        responseHeaders: response.headers.map,
        responseDataVO: response.data!['data'] == null ? null : putResponseDataVO(response.data!['data']! as Map<String, Object?>),
        exception: null,
        stackTrace: null,
      );
    } catch (e, st) {
      setCancel('解析响应数据发生异常！', Description('对响应的数据进行解析时发生了异常。'), e, st);
    }
  }

  /// [doContinue] 只处理正确的响应。
  ///   - 返回 ture 表示 ok；返回 false 则会转发给 [doCancel]
  ///   - 若内部存在异常，则直接 [doCancel]，而这里的 cancel 内容是格式化 [HttpResponse]。
  ///
  /// [doCancel] 处理除 [doContinue] 外的其他任何异常或响应。
  ///
  /// [doContinue] -> [HttpResponseIntercept] -> [doCancel]，执行 [HttpResponseIntercept] 必会执行 [doCancel]。
  Future<void> handle({
    required Future<bool> doContinue(HttpResponse<RESPCCOL, RESPDVO> hr),
    required Future<void> doCancel(HttpResponse<RESPCCOL, RESPDVO> hr),
  }) async {
    if (isContinue) {
      bool isOk = false;
      try {
        isOk = await doContinue(this);
      } catch (e, st) {
        setCancel('发生错误！', Description('doContinue err!'), e, st);
        await doCancel(this);
        return;
      }

      if (!isOk) {
        try {
          await HttpResponseIntercept<RESPCCOL, RESPDVO>(this).handle();
        } catch (e, st) {
          setCancel('发生错误！', Description('HttpIntercept err!'), e, st);
        }
        await doCancel(this);
      }
    } else {
      await doCancel(this);
    }
  }
}
