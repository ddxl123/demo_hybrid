// ignore_for_file: avoid_classes_with_only_static_members
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

class SingleResult<R> {
  R? result;
  String? viewMessage;
  Description? description;
  Object? exception;
  StackTrace? stackTrace;

  bool isSet = false;

  bool _hasError() => exception != null;

  SingleResult<R> setSuccess({required R setResult()}) {
    try {
      result = setResult();
      return this;
    } catch (e, st) {
      return setError(vm: '结果数据解析异常！', descp: Description(''), e: e, st: st);
    }
  }

  /// [e] 不能为空，因为需要根据 [e] 来判断是否 [doCancel]。
  SingleResult<R> setError({required String vm, required Description descp, required Object e, required StackTrace? st}) {
    viewMessage = vm;
    description = descp;
    exception = e;
    stackTrace = st;
    return this;
  }

  /// 可以在 [doError] 内部进行 throw。
  ///
  /// [HR]：指定返回类型。
  ///
  /// 必须先 [setSuccess]/[setError]，再 [handle]。
  /// 必须先 [setSuccess]/[setError]，再 [doSuccess]/[doError]。
  Future<HR> handle<HR>({required Future<HR> doSuccess(R successResult), required Future<HR> doError(SingleResult<R> errorResult)}) async {
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
