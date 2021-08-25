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

  static String? _entryName;

  static void engineEntryBinding(String entryName) {
    SbLogger._entryName = entryName;
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
      log('> — — ${_entryName == null ? 'Warning: unassigned engine entry!' : ''}');
      if (code != null) {
        log('  | $_entryName | code: $code');
      }
      if (viewMessage != null) {
        log('  | $_entryName | viewMessage: $viewMessage');
      }
      if (description != null) {
        log('  | $_entryName | description: ${description!.description} ${'(package:' + description!.stackTrace.toString().split('(package:')[2].split(')')[0] + ')'}');
      }
      if (data != null) {
        try {
          log('  | $_entryName | data: ${const JsonEncoder.withIndent('  ').convert(data)}');
        } catch (e) {
          log('  | $_entryName | data: $data');
        }
      }

      log('  | $_entryName | loggerOutputSt: (package:' + StackTrace.current.toString().split('(package:')[3].split(')')[0] + ')');

      if (exception != null) {
        log('  | $_entryName | exception: \n$exception');
      }
      if (stackTrace != null) {
        log('  | $_entryName | stackTrace: \n$stackTrace');
      }
    } catch (e, st) {
      log('  | $_entryName | logger internal error: ↓', error: e, stackTrace: st);
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
