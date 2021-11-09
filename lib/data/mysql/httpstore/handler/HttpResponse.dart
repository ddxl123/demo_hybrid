// ignore_for_file: camel_case_types

import 'package:hybrid/util/SbHelper.dart';

abstract class ResponseHeadersVO extends DoSerializable {}

abstract class ResponseDataVO extends DoSerializable {}

abstract class ResponseCodeCollect extends DoSerializable {}

class HttpResponse<RESPHVO extends ResponseHeadersVO, RESPDVO extends ResponseDataVO, RESPCCOL extends ResponseCodeCollect> implements DoSerializable {
  HttpResponse({
    required Map<String, Object?> putResponseCodeCollect,
  }) {
    if (responseCodeCollect.isNotEmpty) {
      throw '_responseCodeCollect 已被添加过！';
    }
    responseCodeCollect.addAll(putResponseCodeCollect);
  }

  factory HttpResponse.fromJson(Map<String, Object?> json) {
    return HttpResponse<RESPHVO, RESPDVO, RESPCCOL>(
      putResponseCodeCollect: (json['responseCodeCollect'] as Map<String, Object?>?) ?? <String, Object?>{},
    )
      ..code = (json['code'] as int?) ?? -1
      ..viewMessage = (json['viewMessage'] as String?) ?? '异常消息(空)'
      ..responseDataVO.addAll((json['responseDataVO'] as Map<String, Object?>?) ?? <String, Object?>{})
      ..responseHeadersVO.addAll((json['responseHeadersVO'] as Map<String, Object?>?) ?? <String, Object?>{});
  }

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'responseCodeCollect': responseCodeCollect,
        'code': code,
        'viewMessage': viewMessage,
        'responseDataVO': responseDataVO,
        'responseHeadersVO': responseHeadersVO,
      };

  /// 响应码集。
  final Map<String, Object?> responseCodeCollect = <String, Object?>{};

  /// 响应码。
  ///
  /// -1 表示赋值了 null；
  ///
  /// -2 表示未对其赋值。
  int code = -2;

  /// 响应消息。
  String viewMessage = '异常消息（默认消息）！';

  /// 响应体 data VO 模型。
  final Map<String, Object?> responseDataVO = <String, Object?>{};

  /// 响应头。
  final Map<String, Object?> responseHeadersVO = <String, Object?>{};

  void setAll({
    required int code,
    required String viewMessage,
    required Map<String, Object?> responseDataVO,
    required Map<String, Object?> responseHeadersVO,
  }) {
    this.code = code;
    this.viewMessage = viewMessage;

    if (responseDataVO.isNotEmpty) {
      throw '_responseDataVO 已被添加过！';
    }
    this.responseDataVO.addAll(responseDataVO);

    if (responseHeadersVO.isNotEmpty) {
      throw 'responseHeadersVO 已被添加过！';
    }
    this.responseHeadersVO.addAll(responseHeadersVO);
  }

  RESPCCOL toVOForResponseCodeCollect(RESPCCOL respccol(Map<String, Object?> json)) {
    return respccol(responseCodeCollect);
  }

  RESPDVO toVOForResponseDataVO(RESPDVO respdvo(Map<String, Object?> json)) {
    return respdvo(responseDataVO);
  }
}
