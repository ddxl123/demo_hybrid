// ignore_for_file: avoid_classes_with_only_static_members
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpHandler.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

/// 与 [HttpHandler] 基本一直。
///
/// [R] 必须是个可序列化类型。
class SingleResult<R> extends DoSerializable {
  SingleResult();

  factory SingleResult.fromJson(Map<String, Object?> json) => SingleResult<R>()
    ..result = () {
      final Object? resultValue = json['result'];
      if (resultValue == null) {
        return resultValue as R?;
      }

      final String rTypeName = R.toString();
      if (!rTypeName.contains('<')) {
        return resultValue as R?;
      }

      if (rTypeName.startsWith('List')) {
        final String rNameSb = rTypeName.substring(5);
        final String rName2 = rNameSb.substring(0, rNameSb.length - 1);
        if (rName2 == 'int') {
          return (resultValue as List<Object?>).cast<int>() as R;
        }
        if (rName2 == 'int?') {
          return (resultValue as List<Object?>).cast<int?>() as R;
        }
        if (rName2 == 'bool') {
          return (resultValue as List<Object?>).cast<bool>() as R;
        }
        if (rName2 == 'bool?') {
          return (resultValue as List<Object?>).cast<bool?>() as R;
        }
        if (rName2 == 'String') {
          return (resultValue as List<Object?>).cast<String>() as R;
        }
        if (rName2 == 'String?') {
          return (resultValue as List<Object?>).cast<String?>() as R;
        }
        if (rName2 == 'double') {
          return (resultValue as List<Object?>).cast<double>() as R;
        }
        if (rName2 == 'double?') {
          return (resultValue as List<Object?>).cast<double?>() as R;
        }
        if (rName2.startsWith('Map') && !rName2.endsWith('?')) {
          return List.castFrom<Object?, Map<String, Object?>>(resultValue as List<Object?>) as R;
        }
      }
      if (rTypeName.startsWith('Map')) {
        return (resultValue as Map<Object?, Object?>).cast<String, Object>() as R;
      }
    }()
    .._viewMessage = json['viewMessage'] as String?
    .._description = json['description'] == null ? null : Description.fromJson((json['description']! as Map<Object?, Object?>).cast<String, Object?>())
    .._exception = json['exception'] == null ? null : Exception(json['exception']! as String)
    ..stackTrace = json['stackTrace'] == null ? null : StackTrace.fromString(json['stackTrace']! as String)
    ..isSet = json['isSet']! as bool;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'result': result,
        'viewMessage': _viewMessage,
        'description': _description?.toJson(),
        'exception': _exception?.toString(),
        'stackTrace': stackTrace?.toString(),
        'isSet': isSet,
      };

  R? result;

  String? _viewMessage;

  Description? _description;

  Object? _exception;

  StackTrace? stackTrace;

  bool isSet = false;

  String getRequiredVm() => _viewMessage ?? '_viewMessage 为空！';

  Description getRequiredDescp() => _description ?? Description('_description 为空！');

  Object getRequiredE() => _exception ?? Exception('_exception 为空！');

  bool _hasError() => _exception != null;

  SingleResult<R> setSuccess({required R setResult()}) {
    if (isSet) {
      return this;
    }
    try {
      result = setResult();
      isSet = true;
      return this;
    } catch (e, st) {
      return setError(vm: '结果数据解析异常！', descp: Description(''), e: e, st: st);
    }
  }

  /// [e] 不能为空，因为需要根据 [e] 来判断是否 [doCancel]。
  SingleResult<R> setError({required String vm, required Description descp, required Object e, required StackTrace? st}) {
    if (isSet) {
      return this;
    }
    isSet = true;

    _viewMessage = vm;
    _description = descp;
    _exception = e;
    stackTrace = st;
    return this;
  }

  SingleResult<R> setErrorClone(SingleResult from) {
    return setError(vm: from.getRequiredVm(), descp: from.getRequiredDescp(), e: from.getRequiredE(), st: from.stackTrace);
  }

  /// 可以在 [doError] 内部进行 throw。
  ///
  /// [HR]：指定返回类型。
  ///
  /// 必须先 [setSuccess]/[setError]，再 [handle]。
  /// 必须先 [setSuccess]/[setError]，再 [doSuccess]/[doError]。
  ///
  /// 不捕获 [doError] 的异常。
  Future<HR> handle<HR>({required Future<HR> doSuccess(R successResult), required Future<HR> doError(SingleResult<R> errorResult)}) async {
    if (!isSet) {
      setError(vm: '未完全处理！', descp: Description(''), e: Exception('必须先进行 setCancel/setPass，才能进行 handle！'), st: null);
      return await doError(this);
    }

    if (!_hasError()) {
      try {
        return await doSuccess(result as R);
      } catch (e, st) {
        setError(vm: 'doSuccess 内部异常！', descp: Description(''), e: e, st: st);
        return await doError(this);
      }
    } else {
      return await doError(this);
    }
  }
}

@immutable
class SizeInt {
  const SizeInt(this.width, this.height);

  static SizeInt fromSizeDouble(Size sizeDouble) => SizeInt(sizeDouble.width.toInt(), sizeDouble.height.toInt());

  final int width;
  final int height;

  SizeInt multi(double widthMul, double heightMul) {
    return SizeInt((width * widthMul).toInt(), (height * heightMul).toInt());
  }

  @override
  bool operator ==(Object other) {
    return other is SizeInt && width == other.width && height == other.height;
  }

  @override
  int get hashCode => hashValues(width, height);

  @override
  String toString() {
    return 'SizeInt($width, $height)';
  }
}

class SbHelper {
  /// 生成随机小数点后 1 位的正 double 值。
  ///
  /// 范围：[0.0 ~ max.99999999999999]
  static double randomDouble(int max) {
    return randomInt(max) + Random().nextDouble();
  }

  /// 生成随机正 int 值。
  ///
  /// 范围：[0 ~ max)
  static int randomInt(int max) {
    return Random().nextInt(max);
  }

  /// 生成随机字符串。
  static String randomString(int length) {
    const String lowerLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String upperLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String number = '1234567890';
    const String englishSymbols = '~`!@#\$%^&*()_-+={[}]|\\:;"\'<,>.?/';
    const String chinaSymbols = '~·！@#￥%……&*（）——-+={【}】|、：；“‘《，》。？/';
    const String chineseCharacter = '去我额人他有哦怕啊是的发给和就看了在下从吧了吗';
    const String space = ' ';
    const String all = lowerLetters + upperLetters + number + englishSymbols + chinaSymbols + chineseCharacter + space;
    String result = '';
    for (int i = 0; i < length; i++) {
      result += all[randomInt(all.length)];
    }
    return result;
  }

  /// 生成 uuid。
  static String get newUuid => const Uuid().v4();

  /// 生成当前时间戳。
  static int get newTimestamp => DateTime.now().millisecondsSinceEpoch;

  /// 统一获取 get 插件的 navigator，以防引用包冲突。
  static NavigatorState? get getNavigator => navigator;

  static Offset? str2Offset(String? offsetStr) {
    if (offsetStr == null) {
      return null;
    }
    final List<String> posStr = offsetStr.split(',');
    if (posStr.length != 2) {
      throw 'length err!';
    }
    return Offset(double.parse(posStr.first), double.parse(posStr.last));
  }
}

/// 当类需要序列化，则继承该类。
abstract class DoSerializable {
  Map<String, Object?> toJson();
}

/// 对 [StackTrace] 进行自定义序列化解析。
class StackTraceConverter implements JsonConverter<StackTrace?, String?> {
  const StackTraceConverter();

  @override
  StackTrace? fromJson(String? json) => json == null ? null : StackTrace.fromString(json);

  @override
  String? toJson(StackTrace? object) => object?.toString();
}

extension QuickCast on Object {
  Map<String, Object?> quickCast() {
    return (this as Map<Object?, Object?>).cast<String, Object?>();
  }
}

extension QuickCastNullable on Object? {
  Map<String, Object?>? quickCastNullable() {
    return (this as Map<Object?, Object?>?)?.cast<String, Object?>();
  }
}
