// ignore_for_file: avoid_classes_with_only_static_members

import 'HttpStoreWriteWrapper.dart';

class HttpStoreContent {
  /// no_jwt/a_aa/b_bb -> /a_aa/b_bb
  static String parsePathToA(WriteStoreWrapper storeWriter) {
    // 链接是左斜杆。
    return '/' + ((storeWriter.path.split('/')..removeAt(0)).join('/'));
  }

  /// no_jwt/a_aa/b_bb -> ['a_aa', 'b_bb']
  static List<String> parsePathToList(WriteStoreWrapper storeWriter) {
    return parsePathToA(storeWriter).split('/')..removeAt(0);
  }

  /// no_jwt/a_aa/b_bb -> a_aa_b_bb
  static String parsePathToSnake(WriteStoreWrapper storeWriter) {
    return parsePathToList(storeWriter).join('_');
  }

  /// no_jwt/a_bc/d_ef -> ABDE
  static String parsePathToSimple(WriteStoreWrapper storeWriter) {
    String d = '';
    for (final String value in parsePathToSnake(storeWriter).split('_')) {
      d += value[0].toUpperCase();
    }
    return d;
  }

  /// no_jwt/a_aa/b_bb -> HttpStore_a_aa_b_bb
  static String parsePathToClassName(WriteStoreWrapper storeWriter) {
    // 去掉前缀的 jwt 或 no_jwt。
    return 'HttpStore_${parsePathToSnake(storeWriter)}';
  }

  /// 2010101 -> C2_01_01_01
  static String parseCode(WriteCodeWrapper codeWrapper) {
    final String codeStr = codeWrapper.code.toString();
    return 'C${codeStr[0]}_${codeStr[1]}${codeStr[2]}_${codeStr[3]}${codeStr[4]}_${codeStr[5]}${codeStr[6]}';
  }

  static String contentAll(WriteStoreWrapper storeWriter) {
    return '''
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import '../handler/HttpRequest.dart';
import '../handler/HttpResponse.dart';
import '../handler/HttpStore.dart';

part '${parsePathToClassName(storeWriter)}.g.dart';

class ${parsePathToClassName(storeWriter)} extends HttpStore<RequestHeadersVO_${parsePathToSimple(storeWriter)}, RequestParamsVO_${parsePathToSimple(storeWriter)}, RequestDataVO_${parsePathToSimple(storeWriter)},
    ResponseHeadersVO_${parsePathToSimple(storeWriter)}, ResponseDataVO_${parsePathToSimple(storeWriter)}, ResponseCodeCollect_${parsePathToSimple(storeWriter)}> {
  ${parsePathToClassName(storeWriter)}({
    required RequestHeadersVO_${parsePathToSimple(storeWriter)} requestHeadersVO_${parsePathToSimple(storeWriter)},
    required RequestParamsVO_${parsePathToSimple(storeWriter)} requestParamsVO_${parsePathToSimple(storeWriter)},
    required RequestDataVO_${parsePathToSimple(storeWriter)} requestDataVO_${parsePathToSimple(storeWriter)},
  }) : super(
          putHttpRequest: () => HttpRequest<RequestHeadersVO_${parsePathToSimple(storeWriter)}, RequestParamsVO_${parsePathToSimple(storeWriter)}, RequestDataVO_${parsePathToSimple(storeWriter)}>(
            method: '${storeWriter.method}',
            path: r'${storeWriter.pathType}${parsePathToA(storeWriter)}',
            requestHeadersVO: requestHeadersVO_${parsePathToSimple(storeWriter)},
            requestParamsVO: requestParamsVO_${parsePathToSimple(storeWriter)},
            requestDataVO: requestDataVO_${parsePathToSimple(storeWriter)},
          ),
          responseCodeCollect: ResponseCodeCollect_${parsePathToSimple(storeWriter)}(),
        );

  ${parsePathToClassName(storeWriter)}.fromJson(Map<String, Object?> json) : super.fromJson(json);

  @override
  RequestHeadersVO_${parsePathToSimple(storeWriter)} toVOForRequestHeadersVO(Map<String, Object?> json) => RequestHeadersVO_${parsePathToSimple(storeWriter)}.fromJson(json);

  @override
  RequestParamsVO_${parsePathToSimple(storeWriter)} toVOForRequestParamsVO(Map<String, Object?> json) => RequestParamsVO_${parsePathToSimple(storeWriter)}.fromJson(json);

  @override
  RequestDataVO_${parsePathToSimple(storeWriter)} toVOForRequestDataVO(Map<String, Object?> json) => RequestDataVO_${parsePathToSimple(storeWriter)}.fromJson(json);

  @override
  ResponseCodeCollect_${parsePathToSimple(storeWriter)} toVOForResponseCodeCollect(Map<String, Object?> json) => ResponseCodeCollect_${parsePathToSimple(storeWriter)}.fromJson(json);

  @override
  ResponseDataVO_${parsePathToSimple(storeWriter)} toVOForResponseDataVO(Map<String, Object?> json) => ResponseDataVO_${parsePathToSimple(storeWriter)}.fromJson(json);

  @override
  ResponseHeadersVO_${parsePathToSimple(storeWriter)} toVOForResponseHeadersVO(Map<String, Object?> json) => ResponseHeadersVO_${parsePathToSimple(storeWriter)}.fromJson(json);
}

@JsonSerializable()
class RequestHeadersVO_${parsePathToSimple(storeWriter)} extends RequestHeadersVO {
  RequestHeadersVO_${parsePathToSimple(storeWriter)}(${() {
      if (storeWriter.requestHeadersVOKeys.isEmpty) {
        return '';
      }
      String content = '';
      for (final WriteVOWrapper value in storeWriter.requestHeadersVOKeys) {
        content += 'required this.${value.keyName},';
      }
      content = '{$content}';
      return content;
    }()});
    
  factory RequestHeadersVO_${parsePathToSimple(storeWriter)}.fromJson(Map<String, Object?> json) => _\$RequestHeadersVO_${parsePathToSimple(storeWriter)}FromJson(json);

  @override
  Map<String, Object?> toJson() => _\$RequestHeadersVO_${parsePathToSimple(storeWriter)}ToJson(this);
  
  ${() {
      String content = '';
      for (final WriteVOWrapper value in storeWriter.requestHeadersVOKeys) {
        content += 'final ${value.type.name} ${value.keyName};\n';
      }
      return content;
    }()}
}

@JsonSerializable()
class RequestParamsVO_${parsePathToSimple(storeWriter)} extends RequestParamsVO {
  RequestParamsVO_${parsePathToSimple(storeWriter)}(${() {
      if (storeWriter.requestParamsVOKeys.isEmpty) {
        return '';
      }
      String content = '';
      for (final WriteVOWrapper value in storeWriter.requestParamsVOKeys) {
        content += 'required this.${value.keyName},';
      }
      content = '{$content}';
      return content;
    }()});
    
  factory RequestParamsVO_${parsePathToSimple(storeWriter)}.fromJson(Map<String, Object?> json) => _\$RequestParamsVO_${parsePathToSimple(storeWriter)}FromJson(json);

  @override
  Map<String, Object?> toJson() => _\$RequestParamsVO_${parsePathToSimple(storeWriter)}ToJson(this);
    
  ${() {
      String content = '';
      for (final WriteVOWrapper value in storeWriter.requestParamsVOKeys) {
        content += 'final ${value.type.name} ${value.keyName};\n';
      }
      return content;
    }()}
}

@JsonSerializable()
class RequestDataVO_${parsePathToSimple(storeWriter)} extends RequestDataVO {
  RequestDataVO_${parsePathToSimple(storeWriter)}(${() {
      if (storeWriter.requestDataVOKeys.isEmpty) {
        return '';
      }
      String content = '';
      for (final WriteVOWrapper value in storeWriter.requestDataVOKeys) {
        content += 'required this.${value.keyName},';
      }
      content = '{$content}';
      return content;
    }()});
    
  factory RequestDataVO_${parsePathToSimple(storeWriter)}.fromJson(Map<String, Object?> json) => _\$RequestDataVO_${parsePathToSimple(storeWriter)}FromJson(json);

  @override
  Map<String, Object?> toJson() => _\$RequestDataVO_${parsePathToSimple(storeWriter)}ToJson(this);
    
  ${() {
      String content = '';
      for (final WriteVOWrapper value in storeWriter.requestDataVOKeys) {
        content += 'final ${value.type.name} ${value.keyName};\n';
      }
      return content;
    }()}
}

@JsonSerializable()
class ResponseHeadersVO_${parsePathToSimple(storeWriter)} extends ResponseHeadersVO {
  ResponseHeadersVO_${parsePathToSimple(storeWriter)}(${() {
      if (storeWriter.responseHeadersVOKeys.isEmpty) {
        return '';
      }
      String content = '';
      for (final WriteVOWrapper value in storeWriter.responseHeadersVOKeys) {
        content += 'required this.${value.keyName},';
      }
      content = '{$content}';
      return content;
    }()});
    
  factory ResponseHeadersVO_${parsePathToSimple(storeWriter)}.fromJson(Map<String, Object?> json) => _\$ResponseHeadersVO_${parsePathToSimple(storeWriter)}FromJson(json);

  @override
  Map<String, Object?> toJson() => _\$ResponseHeadersVO_${parsePathToSimple(storeWriter)}ToJson(this);
    
  ${() {
      String content = '';
      for (final WriteVOWrapper value in storeWriter.responseHeadersVOKeys) {
        content += 'final ${value.type.name} ${value.keyName};\n';
      }
      return content;
    }()}
}

@JsonSerializable()
class ResponseDataVO_${parsePathToSimple(storeWriter)} extends ResponseDataVO {
  ResponseDataVO_${parsePathToSimple(storeWriter)}(${() {
      if (storeWriter.responseDataVOKeys.isEmpty) {
        return '';
      }
      String content = '';
      for (final WriteVOWrapper value in storeWriter.responseDataVOKeys) {
        content += 'required this.${value.keyName},';
      }
      content = '{$content}';
      return content;
    }()});
    
  factory ResponseDataVO_${parsePathToSimple(storeWriter)}.fromJson(Map<String, Object?> json) => _\$ResponseDataVO_${parsePathToSimple(storeWriter)}FromJson(json);

  @override
  Map<String, Object?> toJson() => _\$ResponseDataVO_${parsePathToSimple(storeWriter)}ToJson(this);
    
  ${() {
      String content = '';
      for (final WriteVOWrapper value in storeWriter.responseDataVOKeys) {
        content += 'final ${value.type.name} ${value.keyName};\n';
      }
      return content;
    }()}
}

@JsonSerializable()
class ResponseCodeCollect_${parsePathToSimple(storeWriter)} extends ResponseCodeCollect {
  ResponseCodeCollect_${parsePathToSimple(storeWriter)}();

  factory ResponseCodeCollect_${parsePathToSimple(storeWriter)}.fromJson(Map<String, Object?> json) => _\$ResponseCodeCollect_${parsePathToSimple(storeWriter)}FromJson(json);

  @override
  Map<String, Object?> toJson() => _\$ResponseCodeCollect_${parsePathToSimple(storeWriter)}ToJson(this);

${() {
      String allContent = '';
      for (final WriteCodeWrapper value in storeWriter.responseCodeCollect) {
        allContent += """
  /// ${value.tip}
  ResponseCodeCollect_${parsePathToSimple(storeWriter)} ${parseCode(value)}() {
    if (httpStore.httpResponse.responseCode == ${value.code}) {
      isFinal = true;
    }
    return this;
  }
    
""";
      }
      return allContent;
    }()}
}    
''';
  }

  static String configContent(WriteConfigWrapper writeConfigWrapper) {
    return '''
class HttpStoreConfig {
  static const String baseUrl = '${writeConfigWrapper.baseUrl}';

  /// ms
  static const int connectTimeout = ${writeConfigWrapper.connectTimeout};

  /// ms
  static const int receiveTimeout = ${writeConfigWrapper.receiveTimeout};
}''';
  }
}
