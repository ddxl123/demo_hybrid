import 'dart:convert';

class ParseIntoSqlsContent {
  ParseIntoSqlsContent({required this.rawSqls});

  final Map<String, String> rawSqls;

  /// raw sqls
  String parseIntoSqlsContent() {
    return """
class ParseIntoSqls {
  Map<String, String> parseIntoSqls = <String, String>${const JsonEncoder.withIndent('  ').convert(rawSqls).replaceAll(RegExp(r'"'), '\'')};
}
""";
  }
}
