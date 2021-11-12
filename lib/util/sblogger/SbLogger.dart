import 'dart:convert';
import 'dart:developer';

import 'package:hybrid/util/SbHelper.dart';

class Description extends DoSerializable {
  Description(this.text) {
    stackTrace = StackTrace.current;
  }

  factory Description.fromJson(Map json) =>
      Description(json['text']! as String)..stackTrace = json['stackTrace'] == null ? null : StackTrace.fromString(json['stackTrace']! as String);

  @override
  Map<String, Object?> toJson() => <String, dynamic>{
        'text': text,
        'stackTrace': stackTrace?.toString(),
      };

  final String text;

  StackTrace? stackTrace;
}

class SbLogger {
  ///

  SbLogger({
    required this.c,
    required this.vm,
    required this.data,
    required this.descp,
    required this.e,
    required this.st,
  }) {
    _withDebug();
  }

  static String? _entryName;

  static void engineEntryBinding(String entryName) {
    SbLogger._entryName = entryName;
  }

  /// 信息码。
  int? c;

  /// 显示在 toast 的 【文本消息】，不包含 [c]。
  String? vm;

  /// 描述。
  Description? descp;

  /// 数据。[Map]、[List] 会被自动缩进。
  Object? data;

  Object? e;
  StackTrace? st;

  bool get isAllNull => c == null && vm == null && descp == null && data == null && e == null && st == null;

  SbLogger _withDebug() {
    try {
      if (isAllNull) {
        log('> — — ${_entryName ?? 'Warning: The log information to be output is all empty!'}');
        return this;
      }

      log('> — — ${_entryName ?? 'Warning: unassigned engine entry!'}');
      if (c != null) {
        log('  | $_entryName | code: $c');
      }
      if (vm != null) {
        log('  | $_entryName | viewMessage: $vm');
      }
      if (descp != null) {
        log('  | $_entryName | description: ${descp!.text} ${'(package:' + descp!.stackTrace.toString().split('(package:')[2].split(')')[0] + ')'}');
      }
      if (data != null) {
        try {
          log('  | $_entryName | data: ${const JsonEncoder.withIndent('  ').convert(data)}');
        } catch (e) {
          log('  | $_entryName | data: $data');
        }
      }

      log('  | $_entryName | loggerOutputSt: (package:' + StackTrace.current.toString().split('(package:')[3].split(')')[0] + ')');

      if (e != null) {
        log('  | $_entryName | exception: \n$e');
      }
      if (st != null) {
        log('  | $_entryName | stackTrace: \n$st');
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
