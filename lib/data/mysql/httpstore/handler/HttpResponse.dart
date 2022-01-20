// ignore_for_file: camel_case_types

import 'package:hybrid/data/mysql/httpstore/handler/HttpHandler.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class ResponseHeadersVO extends DoSerializable {}

abstract class ResponseDataVO extends DoSerializable {}

abstract class ResponseCodeCollect extends DoSerializable {
  /// 在 [HttpHandler.handle] 中获取。
  @JsonKey(ignore: true)
  late HttpStore httpStore;

  @JsonKey(ignore: true)
  bool isFinal = false;

  bool judge() {
    if (isFinal) {
      isFinal = false;
      return true;
    }
    return false;
  }
}

/// 属性完全为 json 类型。
class HttpResponse<RESPHVO extends ResponseHeadersVO, RESPDVO extends ResponseDataVO, RESPCCOL extends ResponseCodeCollect> implements DoSerializable {
  HttpResponse({required this.httpStore, required this.responseCodeCollect});

  factory HttpResponse.fromJson(HttpStore newHttpStore, Map<String, Object?> json) {
    return HttpResponse<RESPHVO, RESPDVO, RESPCCOL>(
      httpStore: newHttpStore,
      responseCodeCollect: newHttpStore.toVOForResponseCodeCollect(json['responseCodeCollect']!.quickCast()) as RESPCCOL,
    )
      ..responseCode = (json['code'] as int?) ?? -1
      ..viewMessage = (json['viewMessage'] as String?) ?? '异常消息(空)'
      ..responseHeadersVO = newHttpStore.toVOForResponseHeadersVO(json['responseHeadersVO']!.quickCast()) as RESPHVO
      ..responseDataVO = newHttpStore.toVOForResponseDataVO(json['responseDataVO']!.quickCast()) as RESPDVO;
  }

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'code': responseCode,
        'viewMessage': viewMessage,
        'responseHeadersVO': responseHeadersVO.toJson(),
        'responseDataVO': responseDataVO.toJson(),
        'responseCodeCollect': responseCodeCollect.toJson(),
      };

  /// 响应码。
  ///
  /// -1 表示赋值了 null；
  ///
  /// -2 表示未对其赋值。
  int responseCode = -2;

  /// 响应消息。
  String viewMessage = '异常消息（默认消息）！';

  final HttpStore httpStore;

  /// 响应头。
  late RESPHVO responseHeadersVO;

  /// 响应体 data VO 模型。
  late RESPDVO responseDataVO;

  /// 响应码集。
  late RESPCCOL responseCodeCollect;

  void setResponse({
    required int code,
    required String viewMessage,
    required Map<String, Object?> putResponseHeadersVO,
    required Map<String, Object?> putResponseDataVO,
  }) {
    responseCode = code;
    this.viewMessage = viewMessage;
    responseHeadersVO = httpStore.toVOForResponseHeadersVO(putResponseHeadersVO) as RESPHVO;
    responseDataVO = httpStore.toVOForResponseDataVO(putResponseDataVO) as RESPDVO;
  }

  void resetAll(HttpResponse newHttpResponse) {
    responseCode = newHttpResponse.responseCode;
    viewMessage = newHttpResponse.viewMessage;
    responseDataVO = newHttpResponse.responseDataVO as RESPDVO;
    responseHeadersVO = newHttpResponse.responseHeadersVO as RESPHVO;
    responseCodeCollect = newHttpResponse.responseCodeCollect as RESPCCOL;
  }
}
