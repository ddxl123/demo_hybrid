import 'HttpStoreWriter.dart';

class HttpStoreContent {
  /// no_jwt/a_aa/b_bb -> /a_aa/b_bb
  static String parsePathToA(StoreWrapper storeWriter) {
    // 链接是左斜杆。
    return '/' + ((storeWriter.path.split('/')..removeAt(0)).join('/'));
  }

  /// no_jwt/a_aa/b_bb -> ['a_aa', 'b_bb']
  static List<String> parsePathToList(StoreWrapper storeWriter) {
    return parsePathToA(storeWriter).split('/')..removeAt(0);
  }

  /// no_jwt/a_aa/b_bb -> a_aa_b_bb
  static String parsePathToSnake(StoreWrapper storeWriter) {
    return parsePathToList(storeWriter).join('_');
  }

  /// no_jwt/a_bc/d_ef -> ABDE
  static String parsePathToSimple(StoreWrapper storeWriter) {
    String d = '';
    for (final String value in parsePathToSnake(storeWriter).split('_')) {
      d += value[0].toUpperCase();
    }
    return d;
  }

  /// no_jwt/a_aa/b_bb -> HttpStore_a_aa_b_bb
  static String parsePathToClassName(StoreWrapper storeWriter) {
    // 去掉前缀的 jwt 或 no_jwt。
    return 'HttpStore_${parsePathToSnake(storeWriter)}';
  }

  static String contentAll(StoreWrapper storeWriter) {
    return '''
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import '../handler/HttpRequest.dart';
import '../handler/HttpResponse.dart';
import '../handler/HttpStore.dart';

part '${parsePathToClassName(storeWriter)}.g.dart';

class ${parsePathToClassName(storeWriter)} extends HttpStore_${storeWriter.method}<RequestDataVO_${parsePathToSimple(storeWriter)}, ResponseCodeCollect_${parsePathToSimple(storeWriter)}, ResponseDataVO_${parsePathToSimple(storeWriter)}> {
  ${parsePathToClassName(storeWriter)}({
    required RequestDataVO_${parsePathToSimple(storeWriter)}? putRequestDataVO_${parsePathToSimple(storeWriter)}(),
  }) : super(
          r'${storeWriter.path}',
          putRequestDataVO_${parsePathToSimple(storeWriter)},
          ResponseCodeCollect_${parsePathToSimple(storeWriter)}(),
          (Map<String, Object?>? json) => json == null ? null : ResponseDataVO_${parsePathToSimple(storeWriter)}.fromJson(json),
        );
  
  factory ${parsePathToClassName(storeWriter)}.fromJson(Map<String, Object?> json) =>
      ${parsePathToClassName(storeWriter)}(putRequestDataVO_${parsePathToSimple(storeWriter)}: () => null)
        ..httpRequest = HttpRequest<RequestDataVO_${parsePathToSimple(storeWriter)}, RequestParamsVO>.fromJson(
          json['httpRequest']! as Map<String, Object?>,
          (Map<String, Object?>? reqvoJson) => reqvoJson == null ? null : RequestDataVO_${parsePathToSimple(storeWriter)}.fromJson(reqvoJson),
          (Map<String, Object?>? reqpvoJson) => null,
        )
        ..httpResponse = HttpResponse<ResponseCodeCollect_${parsePathToSimple(storeWriter)}, ResponseDataVO_${parsePathToSimple(storeWriter)}>.fromJson(
          json['httpResponse']! as Map<String, Object?>,
          (Map<String, Object?>? respdvoJson) => respdvoJson == null ? null : ResponseDataVO_${parsePathToSimple(storeWriter)}.fromJson(respdvoJson),
          (Map<String, Object?> respccolJson) => ResponseCodeCollect_${parsePathToSimple(storeWriter)}.fromJson(respccolJson),
        );


  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'httpRequest': httpRequest.toJson(),
        'httpResponse': httpResponse.toJson(),
      };
}

@JsonSerializable()
class RequestDataVO_${parsePathToSimple(storeWriter)} extends RequestDataVO {
  RequestDataVO_${parsePathToSimple(storeWriter)}(
    ${() {
      if (storeWriter.requestDataVOKeys == null || storeWriter.requestDataVOKeys!.isEmpty) {
        return '';
      }
      String keyNames = '';
      for (final DataVOWrapper dataVOKT in storeWriter.requestDataVOKeys!) {
        keyNames += 'required this.${dataVOKT.keyName},';
      }
      return '{$keyNames}';
    }()});

  factory RequestDataVO_${parsePathToSimple(storeWriter)}.fromJson(Map<String, Object?> json) => _\$RequestDataVO_${parsePathToSimple(storeWriter)}FromJson(json);

  @override
  Map<String, Object?> toJson() => _\$RequestDataVO_${parsePathToSimple(storeWriter)}ToJson(this);

  ${() {
      String members = '';
      for (final DataVOWrapper dataVOKT in storeWriter.requestDataVOKeys!) {
        members += 'final ${dataVOKT.type.name} ${dataVOKT.keyName};';
      }
      return members;
    }()}
}

@JsonSerializable()
class ResponseDataVO_${parsePathToSimple(storeWriter)} extends ResponseDataVO {
  ResponseDataVO_${parsePathToSimple(storeWriter)}(
    ${() {
      if (storeWriter.responseDataVOKeys.isEmpty) {
        return '';
      }
      String keyNames = '';
      for (final DataVOWrapper dataVOKT in storeWriter.responseDataVOKeys) {
        keyNames += 'required this.${dataVOKT.keyName},';
      }
      return '{$keyNames}';
    }()}
  );

  factory ResponseDataVO_${parsePathToSimple(storeWriter)}.fromJson(Map<String, Object?> json) => _\$ResponseDataVO_${parsePathToSimple(storeWriter)}FromJson(json);

  @override
  Map<String, Object?> toJson() => _\$ResponseDataVO_${parsePathToSimple(storeWriter)}ToJson(this);

  ${() {
      String members = '';
      for (final DataVOWrapper dataVOKT in storeWriter.responseDataVOKeys) {
        members += 'late ${dataVOKT.type.name} ${dataVOKT.keyName};';
      }
      return members;
    }()}
}

@JsonSerializable()
class ResponseCodeCollect_${parsePathToSimple(storeWriter)} extends ResponseCodeCollect {
  ResponseCodeCollect_${parsePathToSimple(storeWriter)}();

  factory ResponseCodeCollect_${parsePathToSimple(storeWriter)}.fromJson(Map<String, Object?> json) => _\$ResponseCodeCollect_${parsePathToSimple(storeWriter)}FromJson(json);

  @override
  Map<String, Object?> toJson() => _\$ResponseCodeCollect_${parsePathToSimple(storeWriter)}ToJson(this);

  ${() {
      String members = '';
      for (final CodeWrapper codeWrapper in storeWriter.responseCodeCollect) {
        final String codeStr = codeWrapper.code.toString();
        members += '''
  /// ${codeWrapper.tip}
  final int C${codeStr[0]}_${codeStr[1]}${codeStr[2]}_${codeStr[3]}${codeStr[4]}_${codeStr[5]}${codeStr[6]} = $codeStr;
  ''';
      }
      return members;
    }()}
}''';
  }
}
