import 'dart:convert';
import 'dart:developer';

import 'package:hybrid/util/SbHelper.dart';

class Description extends DoSerializable {
  Description(this.text) {
    stackTrace = StackTrace.current;
  }

  factory Description.fromJson(Map<String, Object?> json) =>
      Description(json['text']! as String)..stackTrace = json['stackTrace'] == null ? null : StackTrace.fromString(json['stackTrace']! as String);

  @override
  Map<String, Object?> toJson() => <String, Object?>{
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
    String content = '\n';
    try {
      if (isAllNull) {
        content += '> — — ${_entryName ?? 'Warning: The log information to be output is all empty!'}\n';
        return this;
      }

      content += '> — — ${_entryName ?? 'Warning: unassigned engine entry!'}\n';
      if (c != null) {
        content += '  | $_entryName | code: $c\n';
      }
      if (vm != null) {
        content += '  | $_entryName | viewMessage: $vm\n';
      }
      if (descp != null) {
        content += '  | $_entryName | description: ${descp!.text} ${'(package:' + descp!.stackTrace.toString().split('(package:')[2].split(')')[0] + ')'}\n';
      }
      if (data != null) {
        try {
          content += '  | $_entryName | data: ${const JsonEncoder.withIndent('  ').convert(data)}\n';
        } catch (e) {
          content += '  | $_entryName | data: $data\n';
        }
      }

      content += '  | $_entryName | loggerOutputSt: (package:' + StackTrace.current.toString().split('(package:')[3].split(')')[0] + ')\n';

      if (e != null) {
        content += '  | $_entryName | exception: \n$e\n';
      }
      if (st != null) {
        content += '  | $_entryName | stackTrace: \n$st\n';
      }
    } catch (e, st) {
      content += '  | $_entryName | logger internal error: $e $st\n';
    }
    log(content);
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
