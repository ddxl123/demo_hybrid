import 'package:drift/drift.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/data/drift/table/Cloud.dart';
import 'package:hybrid/data/drift/table/Local.dart';
import 'package:hybrid/util/SbHelper.dart';

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

  Future<MemoryGroup> insertMemoryGroup(MemoryGroupsCompanion memoryGroupsCompanion) async {
    return await into(memoryGroups).insertReturning(memoryGroupsCompanion);
  }

  /// 将每个 [fragments] 插入到全部 [memoryGroups] 中。
  Future<void> insertMemoryGroup2Fragments({
    required List<MemoryGroup> memoryGroups,
    required List<Fragment> fragments,
    required Future<void> Function(MemoryGroup filteredMemoryGroup, List<Fragment> filteredFragments) filtered,
  }) async {
    await batch((batch) async {
      for (var memoryGroup in memoryGroups) {
        final List<MemoryGroup2FragmentsCompanion> memoryGroup2FragmentsCompanions = <MemoryGroup2FragmentsCompanion>[];
        final List<Fragment> filteredFragments = <Fragment>[];

        for (var element in fragments) {
          final MemoryGroup2Fragment? m2f = await ((select(memoryGroup2Fragments))
                ..where(
                  (tbl) =>
                      (tbl.fragmentId.equals(element.id) | tbl.fragmentCloudId.equals(element.cloudId)) &
                      (tbl.memoryGroupId.equals(memoryGroup.id) | tbl.memoryGroupCloudId.equals(memoryGroup.cloudId)),
                ))
              .getSingleOrNull();
          // 以防重复。
          if (m2f == null) {
            filteredFragments.add(element);

            memoryGroup2FragmentsCompanions.add(
              MemoryGroup2FragmentsCompanion.insert(
                memoryGroupId: memoryGroup.id.toValue(),
                memoryGroupCloudId: memoryGroup.cloudId.toValue(),
                fragmentId: element.id.toValue(),
                fragmentCloudId: element.cloudId.toValue(),
              ),
            );
          }
        }
        await filtered(memoryGroup, filteredFragments);
        batch.insertAll(memoryGroup2Fragments, memoryGroup2FragmentsCompanions);
      }
    });
  }
}
