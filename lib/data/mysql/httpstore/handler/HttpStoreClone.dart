// ignore_for_file: camel_case_types

import 'HttpRequest.dart';
import 'HttpResponse.dart';
import 'HttpStore.dart';

class HttpStore_Clone extends HttpStore<RequestDataVO_Clone, RequestParamsVO_Clone, ResponseCodeCollect_Clone, ResponseDataVO_Clone> {
  HttpStore_Clone();

  factory HttpStore_Clone.fromJson(Map<String, Object?> json) {
    return HttpStore_Clone()
      ..httpRequest = HttpRequest<RequestDataVO_Clone, RequestParamsVO_Clone>.fromJson(
        (json['httpRequest']! as Map<Object?, Object?>).cast<String, Object?>(),
        (Map<String, Object?>? reqvoJson) => reqvoJson == null ? null : RequestDataVO_Clone.fromJson(reqvoJson),
        (Map<String, Object?>? reqpvoJson) => reqpvoJson == null ? null : RequestParamsVO_Clone.fromJson(reqpvoJson),
      )
      ..httpResponse = HttpResponse<ResponseCodeCollect_Clone, ResponseDataVO_Clone>.fromJson(
        (json['httpResponse']!  as Map<Object?, Object?>).cast<String,Object?>(),
        (Map<String, Object?>? respdvoJson) => respdvoJson == null ? null : ResponseDataVO_Clone.fromJson(respdvoJson),
        (Map<String, Object?> respccolJson) => ResponseCodeCollect_Clone.fromJson(respccolJson),
      );
  }

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'httpRequest': httpRequest.toJson(),
        'httpResponse': httpResponse.toJson(),
      };
}

class RequestDataVO_Clone extends RequestDataVO {
  RequestDataVO_Clone();

  factory RequestDataVO_Clone.fromJson(Map<String, Object?> json) {
    return RequestDataVO_Clone()..json = json;
  }

  late Map<String, Object?> json;

  @override
  Map<String, Object?> toJson() => json;
}

class RequestParamsVO_Clone extends RequestParamsVO {
  RequestParamsVO_Clone();

  factory RequestParamsVO_Clone.fromJson(Map<String, Object?> json) {
    return RequestParamsVO_Clone()..json = json;
  }

  late Map<String, Object?> json;

  @override
  Map<String, Object?> toJson() => json;
}

class ResponseDataVO_Clone extends ResponseDataVO {
  ResponseDataVO_Clone();

  factory ResponseDataVO_Clone.fromJson(Map<String, Object?> json) {
    return ResponseDataVO_Clone()..json = json;
  }

  late Map<String, Object?> json;

  @override
  Map<String, Object?> toJson() => json;
}

class ResponseCodeCollect_Clone extends ResponseCodeCollect {
  ResponseCodeCollect_Clone();

  factory ResponseCodeCollect_Clone.fromJson(Map<String, Object?> json) {
    return ResponseCodeCollect_Clone()..json = json;
  }

  late Map<String, Object?> json;

  @override
  Map<String, Object?> toJson() => json;
}
