import 'dart:convert';
import 'dart:developer';

class Description {
  Description(this.description) {
    stackTrace = StackTrace.current;
  }

  final String description;
  late final StackTrace stackTrace;
}

class SbLogger {
  ///

  SbLogger({
    required this.code,
    required this.viewMessage,
    required this.data,
    required this.description,
    required this.exception,
    required this.stackTrace,
  }) {
    _withDebug();
  }

  /// 信息码。
  int? code;

  /// 显示在 toast 的 【文本消息】，不包含 [code]。
  String? viewMessage;

  /// 描述。
  Description? description;

  /// 数据。[Map]、[List] 会被自动缩进。
  Object? data;

  Object? exception;
  StackTrace? stackTrace;

  SbLogger _withDebug() {
    try {
      log('> — — ');
      if (code != null) {
        log('  | code: $code');
      }
      if (viewMessage != null) {
        log('  | viewMessage: $viewMessage');
      }
      if (description != null) {
        log('  | description: ${description!.description} ${'(package:' + description!.stackTrace.toString().split('(package:')[2].split(')')[0] + ')'}');
      }
      if (data != null) {
        try {
          log('  | data: ${const JsonEncoder.withIndent('  ').convert(data)}');
        } catch (e) {
          log('  | data: $data');
        }
      }

      log('  | loggerOutputSt: (package:' + StackTrace.current.toString().split('(package:')[3].split(')')[0] + ')');

      if (exception != null) {
        log('  | exception: ↓', error: exception);
      }
      if (stackTrace != null) {
        log('  | stackTrace: ↓', stackTrace: stackTrace);
      }
    } catch (e, st) {
      log('  | logger internal error: ↓', error: e, stackTrace: st);
    }
    return this;
  }

  SbLogger withToast(bool isWithCode) {
    return this;
  }

  SbLogger withRecord() {
    return this;
  }

  SbLogger withAll(bool isWithCodeForToast) {
    return withToast(isWithCodeForToast).withRecord();
  }
}
