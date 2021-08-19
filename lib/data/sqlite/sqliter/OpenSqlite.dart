import 'package:sqflite/sqflite.dart';

late final Database db;
late final String dbPathRoot;
const String dbName = '/jysp.db';

/// 打开 sqlite 数据库
Future<void> openDb() async {
  dbPathRoot = await getDatabasesPath();
  final String dbPath = dbPathRoot + dbName;
  db = await openDatabase(dbPath);
}
