import 'package:drift/drift.dart';
import 'package:hybrid/data/drift/table/Local.dart';

import '../db/DriftDb.dart';

part 'EasyDAO.g.dart';

@DriftAccessor(tables: <Type>[AppVersionInfos])
class EasyDAO extends DatabaseAccessor<DriftDb> with _$EasyDAOMixin {
  EasyDAO(DriftDb attachedDatabase) : super(attachedDatabase);

  Future<String> getSavedAppVersion() async {
    return (await select(appVersionInfos).getSingle()).savedVersion;
  }
}
