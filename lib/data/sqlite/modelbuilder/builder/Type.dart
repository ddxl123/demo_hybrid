import 'dart:core';

class SqliteType {
  static const String TEXT = 'TEXT';
  static const String INTEGER = 'INTEGER';
  static const String UNIQUE = 'UNIQUE';
  static const String PRIMARY_KEY = 'PRIMARY KEY';
  static const String AUTOINCREMENT = 'AUTOINCREMENT';

  /// UNSIGNED, sqlite 没有该类型。
  /// NOT NULL, 全部数据都设置为可空。
}

class DartType {
  static const String STRING = 'String';
  static const String INT = 'int';
}
