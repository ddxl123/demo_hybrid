import 'package:drift/drift.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/data/drift/table/Cloud.dart';
import 'package:hybrid/data/drift/table/Local.dart';

part 'InsertDAO.g.dart';

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
class InsertDAO extends DatabaseAccessor<DriftDb> with _$InsertDAOMixin {
  InsertDAO(DriftDb attachedDatabase) : super(attachedDatabase);

  Future<Folder> insertFolder(FoldersCompanion foldersCompanion) async {
    return await into(folders).insertReturning(foldersCompanion);
  }

  /// [fragmentsCompanion] 要插入的 fragment。
  ///
  /// [forFolder] 所插入的 fragment 对应的 folder。
  Future<List<Fragment>> insertFragments(List<FragmentsCompanion> fragmentsCompanions, Folder forFolder) async {
    return await transaction(
      () async {
        final List<Fragment> newFragments = <Fragment>[];
        for (var element in fragmentsCompanions) {
          final Fragment fragment = await into(fragments).insertReturning(element);
          newFragments.add(fragment);
          await into(folder2Fragments).insertReturning(
            Folder2FragmentsCompanion.insert(
              folderId: Value(forFolder.id),
              folderCloudId: Value(forFolder.cloudId),
              fragmentId: Value(fragment.id),
              fragmentCloudId: Value(fragment.cloudId),
            ),
          );
        }
        return newFragments;
      },
    );
  }
}
