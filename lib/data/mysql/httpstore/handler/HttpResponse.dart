import 'package:dio/dio.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:json_annotation/json_annotation.dart';

import 'HttpResponseIntercept.dart';

part 'HttpResponse.g.dart';

abstract class ResponseCodeCollect extends DoSerializable {}

abstract class ResponseDataVO extends DoSerializable {}

@JsonSerializable()
@StackTraceConverter()
class HttpResponse<RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO> extends DoSerializable {
  HttpResponse({
    this.responseCodeCollect,
    this.putResponseDataVO,
  });

  factory HttpResponse.fromJson(Map<String, Object?> json) {
    return _$HttpResponseFromJson(json)
      ..responseCodeCollect = json['responseCodeCollect'] as RESPCCOL?
      ..responseDataVO = json['responseDataVO'] as RESPDVO?;
  }

  @override
  Map<String, Object?> toJson() {
    return _$HttpResponseToJson(this)
      ..addAll(
        <String, Object?>{
          'responseCodeCollect': responseCodeCollect?.toJson(),
          'responseDataVO': responseDataVO?.toJson(),
        },
      );
  }

  /// 响应码集。
  @JsonKey(ignore: true)
  late final RESPCCOL? responseCodeCollect;

  /// 对 [responseDataVO] 进行预配置。
  @JsonKey(ignore: true)
  late final RESPDVO? Function(Map<String, Object?> json)? putResponseDataVO;

  /// 响应体 data VO 模型。
  @JsonKey(ignore: true)
  late final RESPDVO? responseDataVO;

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
    required bool isContinue,
    required int? code,
    required String? viewMessage,
    required Description? description,
    required Object? exception,
    required StackTrace? stackTrace,
  }) {
    this.responseHeaders = responseHeaders;
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
        exception: null,
        stackTrace: null,
      );
      final Map<String, Object?>? data = response.data!['data'] as Map<String, Object?>?;
      if (data != null) {
        responseDataVO = putResponseDataVO!(data);
      }
    } catch (e, st) {
      _setAll(
        isContinue: false,
        code: -1,
        viewMessage: null,
        description: Description('对响应的数据进行解析时发生了异常。'),
        responseHeaders: null,
        exception: e,
        stackTrace: st,
      );
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
