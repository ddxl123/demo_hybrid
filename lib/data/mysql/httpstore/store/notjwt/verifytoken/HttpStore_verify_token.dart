// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:hybrid/data/mysql/constant/PathConstant.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpRequest.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpResponse.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'HttpStore_verify_token.g.dart';

class HttpStore_verify_token extends HttpStore_POST<RequestDataVO_VT, ResponseCodeCollect_VT, ResponseDataVO_VT> {
  HttpStore_verify_token({
    required RequestDataVO_VT setRequestDataVO_VT(),
  }) : super(
          PathConstant.VERIFY_TOKEN,
          setRequestDataVO_VT,
          ResponseCodeCollect_VT(),
          (Map<String, Object?> json) => ResponseDataVO_VT.fromJson(json),
        );
}

@JsonSerializable()
class RequestDataVO_VT extends RequestDataVO {
  RequestDataVO_VT({required this.token});

  factory RequestDataVO_VT.fromJson(Map<String, Object?> json) => _$RequestDataVO_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestDataVO_VTToJson(this);

  final String? token;
}

@JsonSerializable()
class ResponseDataVO_VT extends ResponseDataVO {
  ResponseDataVO_VT({required this.new_token});

  factory ResponseDataVO_VT.fromJson(Map<String, Object?> json) => _$ResponseDataVO_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseDataVO_VTToJson(this);

  late String new_token;
}

class ResponseCodeCollect_VT extends ResponseCodeCollect {}
