import 'package:drift/drift.dart';

import '../db/DriftDb.dart';

part 'JianJiDAO.g.dart';

@DriftAccessor(tables: <Type>[])
class JianJiDAO extends DatabaseAccessor<DriftDb> with _$JianJiDAOMixin {
  JianJiDAO(DriftDb attachedDatabase) : super(attachedDatabase);

  /// 不包含 offset 本身，
  Future<List<Folder>> getFoldersByLimit(int limit, int offset) async {
    return await (select(attachedDatabase.folders)..limit(limit, offset: offset)).get();
  }

  Future<void> deleteFolder(int id) async {
    await (delete(attachedDatabase.folders)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<Folder> addFolder(FoldersCompanion foldersCompanion) async {
    return await into(attachedDatabase.folders).insertReturning(foldersCompanion);
  }
}
