// ignore_for_file: camel_case_types

import 'package:hybrid/util/SbHelper.dart';

abstract class ResponseCodeCollect extends DoSerializable {}

abstract class ResponseDataVO extends DoSerializable {}

class HttpResponse<RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO> {
  HttpResponse({
    required Map<String, Object?> putResponseCodeCollect,
  }) {
    if (responseCodeCollect.isNotEmpty) {
      throw '_responseCodeCollect 已被添加过！';
    }
    responseCodeCollect.addAll(putResponseCodeCollect);
  }

  // factory HttpResponse.fromJson(
  //     Map<String, Object?> json, RESPDVO? respdvo(Map<String, Object?>? respdvoJson), RESPCCOL respccol(Map<String, Object?> respccolJson)) {
  //   return HttpResponse<RESPCCOL, RESPDVO>(
  //     putResponseDataVO: (Map<String, Object?>? newResponseDataVO) => respdvo(newResponseDataVO),
  //     responseCodeCollect: respccol((json['responseCodeCollect']! as Map<Object?, Object?>).cast<String, Object?>()),
  //   )
  //     ..responseHeaders = json['responseHeaders'] as Map<String, Object?>?
  //     ..responseDataVO = json['responseDataVO'] == null ? null : respdvo((json['responseDataVO']! as Map<Object?, Object?>).cast<String, Object?>())
  //     ..isContinue = json['isContinue']! as bool
  //     ..code = json['code'] as int?
  //     ..viewMessage = json['viewMessage'] as String?
  //     ..description = json['description'] == null ? null : Description.fromJson((json['description']! as Map<Object?, Object?>).cast<String, Object?>())
  //     ..exception = json['exception'] == null ? null : Exception(json['exception']!)
  //     ..stackTrace = json['stackTrace'] == null ? null : StackTrace.fromString(json['stackTrace']! as String);
  // }
  //
  // @override
  // Map<String, Object?> toJson() => <String, Object?>{
  //       'responseHeaders': responseHeaders,
  //       'responseCodeCollect': responseCodeCollect.toJson(),
  //       'responseDataVO': responseDataVO?.toJson(),
  //       'putResponseDataVO': null,
  //       'isContinue': isContinue,
  //       'code': code,
  //       'viewMessage': viewMessage,
  //       'description': description?.toJson(),
  //       'exception': exception?.toString(),
  //       'stackTrace': stackTrace?.toString(),
  //     };

  /// 响应码集。
  final Map<String, Object?> responseCodeCollect = <String, Object?>{};

  /// 响应码。
  int code = -2;

  /// 响应消息。
  String viewMessage = '异常消息（默认消息）！';

  /// 响应体 data VO 模型。
  final Map<String, Object?> responseDataVO = <String, Object?>{};

  /// 响应头。
  final Map<String, Object?> responseHeaders = <String, Object?>{};

  void setAll({
    required int code,
    required String viewMessage,
    required Map<String, Object?> responseDataVO,
    required Map<String, Object?> responseHeaders,
  }) {
    this.code = code;
    this.viewMessage = viewMessage;

    if (responseDataVO.isNotEmpty) {
      throw '_responseDataVO 已被添加过！';
    }
    responseDataVO.addAll(responseDataVO);

    if (responseHeaders.isNotEmpty) {
      throw 'responseHeaders 已被添加过！';
    }
    responseHeaders.addAll(responseHeaders);
  }

  RESPCCOL toVOForResponseCodeCollect(RESPCCOL respccol(Map<String, Object?> json)) {
    return respccol(responseCodeCollect);
  }

  RESPDVO toVOForResponseDataVO(RESPDVO respdvo(Map<String, Object?> json)) {
    return respdvo(responseDataVO);
  }
}
