import 'package:drift/drift.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/data/drift/table/Cloud.dart';
import 'package:hybrid/data/drift/table/Local.dart';

part 'UpdateDAO.g.dart';

@DriftAccessor(tables: <Type>[
  AppInfos,
  Users,
  Folders,
  Fragments,
  MemoryGroups,
  Folder2Fragments,
  MemoryGroup2Fragments,
  SimilarFragments,
])
class UpdateDAO extends DatabaseAccessor<DriftDb> with _$UpdateDAOMixin {
  UpdateDAO(DriftDb attachedDatabase) : super(attachedDatabase);

  Future<bool> updateFragment(Fragment fragment) async {
    return await update(fragments).replace(fragment);
  }
}
