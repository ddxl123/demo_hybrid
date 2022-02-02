// ignore_for_file: avoid_classes_with_only_static_members
import 'dart:math';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpHandler.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

extension ToValue on Object? {
  drift.Value<T> toValue<T>() {
    return drift.Value<T>(this as T);
  }
}

/// 与 [HttpHandler] 基本一直。
///
/// [D] 必须是个可序列化类型。
class SingleResult<D> extends DoSerializable {
  SingleResult();

  factory SingleResult.fromJson({required Map<String, Object?> json, required D dataCast(Object data)}) => SingleResult<D>()
    .._data = json['data'] == null ? null : dataCast(json['data']!)
    .._viewMessage = json['viewMessage'] as String?
    .._description = json['description'] == null ? null : Description.fromJson((json['description']! as Map<Object?, Object?>).cast<String, Object?>())
    .._exception = json['exception'] == null ? null : Exception(json['exception']! as String)
    ..stackTrace = json['stackTrace'] == null ? null : StackTrace.fromString(json['stackTrace']! as String);

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'data': _data,
        'viewMessage': _viewMessage,
        'description': _description?.toJson(),
        'exception': _exception?.toString(),
        'stackTrace': stackTrace?.toString(),
      };

  Map<String, Object?> toJsonExcludeData() => <String, Object?>{
        'data': null,
        'viewMessage': _viewMessage,
        'description': _description?.toJson(),
        'exception': _exception?.toString(),
        'stackTrace': stackTrace?.toString(),
      };

  D? _data;

  D getRequiredData() => _data!;

  void setData(D data) {
    _data = data;
  }

  /// 存在异常时，才会存在 [_viewMessage]、[_description]、[_exception]、[stackTrace]。
  ///
  /// TODO: 集成 [_viewMessage]、[_description]、[_exception]、[stackTrace] 为一个对象。
  String? _viewMessage;

  Description? _description;

  /// 存在 [_exception] 必然存在错误。
  Object? _exception;

  StackTrace? stackTrace;

  String getRequiredVm() => _viewMessage ?? '_viewMessage 为空！';

  Description getRequiredDescp() => _description ?? Description('_description 为空！');

  Object getRequiredE() => _exception ?? Exception('_exception 为空！');

  /// TODO: 对 [setSuccess] 设置栈堆定位。
  SingleResult<D> setSuccess({required D putData()}) {
    try {
      // 若被调用前不存在异常，则可直接配置 data；
      // 若被调用前存在异常，则保留异常结果；
      if (_exception != null) {
        return this;
      }
      // 带上 "!" 目的是让 D 类型不能为 null。
      _data = putData()!;
      return this;
    } catch (e, st) {
      return setError(vm: '结果数据解析异常！', descp: Description(''), e: e, st: st);
    }
  }

  /// TODO: 对 [setError] 进行修改，将 [descp] 和 [e] 融为一体。
  ///
  /// TODO: 对 [setError] 设置栈堆定位。
  SingleResult<D> setError({required String vm, required Description descp, required Object e, required StackTrace? st}) {
    // 若被调用前不存在异常，则配置新异常；
    // 若被调用前存在异常，则保留异常结果。
    if (_exception != null) {
      return this;
    }
    _viewMessage = vm;
    _description = descp;
    _exception = e;
    stackTrace = st;
    return this;
  }

  /// TODO: 找出 [resetAll] 未修改的。
  SingleResult<D> setErrorClone(SingleResult<Object?> from) {
    return setError(
      vm: from.getRequiredVm(),
      descp: from.getRequiredDescp(),
      e: from.getRequiredE(),
      st: from.stackTrace,
    );
  }

  SingleResult<D> resetAll(SingleResult<D> from) {
    _data = from._data;
    _exception = from._exception;
    _description = from._description;
    _viewMessage = from._viewMessage;
    stackTrace = from.stackTrace;
    return this;
  }

  SingleResult<D> resetAllExcludeData(SingleResult<D> from) {
    _exception = from._exception;
    _description = from._description;
    _viewMessage = from._viewMessage;
    stackTrace = from.stackTrace;
    return this;
  }

  /// 当执行完 [setSuccess]/[setError] 后，对最终的 [SingleResult] 进行处理。
  ///
  /// [doSuccess] 内部错误，会被 [doError] 捕获。
  ///
  /// [doError] 内部错误，会进行抛出，可以在外部对该异常进行捕获。
  ///
  /// [HR] 指定返回类型。
  ///
  Future<HR> handle<HR>({
    required Future<HR> doSuccess(D successData),

    /// TODO: 将 [doError] 的 [errorResult] 包装成异常的单独对象（集成 [_viewMessage]、[_description]、[_exception]、[stackTrace]）。
    required Future<HR> doError(SingleResult<D> errorResult),
  }) async {
    if (_data == null && _exception == null) {
      setError(vm: '未完全处理！', descp: Description(''), e: Exception('必须先进行 setCancel/setPass，才能进行 handle！'), st: null);
      return await doError(this);
    }

    if (_exception == null) {
      try {
        return await doSuccess(_data as D);
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
