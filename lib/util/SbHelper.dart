// ignore_for_file: avoid_classes_with_only_static_members
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SingleResult<T> {
  SingleResult({required this.result, required this.exception, required this.stackTrace});

  SingleResult.empty() {
    exception = Exception('未处理 SingleResult！');
  }

  /// 当 [_hasError] 为 false 时，[result] 必须不为 null。
  T? result;
  Object? exception;
  StackTrace? stackTrace;

  bool get _hasError => exception != null || result == null;

  /// 当 [setSuccess] 时，传入的 result 不能为空。
  Future<SingleResult<T>> setSuccess({required Future<T> setResult()}) async {
    try {
      result = await setResult();
      exception = null;
      stackTrace = null;
      return this;
    } catch (e, st) {
      return setError(exception: Exception('setSuccess 内部异常！$e'), stackTrace: st);
    }
  }

  SingleResult<T> setError({required Object? exception, required StackTrace? stackTrace}) {
    result = null;
    this.exception = exception ?? Exception('result 不能为 null！');
    this.stackTrace = stackTrace;
    return this;
  }

  /// 可以在 [onError] 内部进行 throw。
  ///
  /// [HR]：指定返回类型。
  Future<HR> handle<HR>({required Future<HR> onSuccess(T successResult), required Future<HR> onError(Object? exception, StackTrace? stackTrace)}) async {
    if (_hasError) {
      return await onError(exception, stackTrace);
    }
    try {
      return await onSuccess(result as T);
    } catch (e, st) {
      return await onError(Exception('onSuccess 内部异常！$e'), st);
    }
  }

  void _setAll({required T? result, required Object? exception, required StackTrace? stackTrace}) {
    this.result = result;
    this.exception = exception;
    this.stackTrace = stackTrace;
  }

  /// 将当前对象克隆到指定对象上。
  void cloneTo(SingleResult<T> otherResult) {
    otherResult._setAll(result: result, exception: exception, stackTrace: stackTrace);
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
