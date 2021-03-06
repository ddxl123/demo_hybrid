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
  Remembers,
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

  /// 将每个 [forFragments] 插入到全部 [forMemoryGroups] 中。
  Future<void> insertMemoryGroup2Fragments({
    required List<MemoryGroup> forMemoryGroups,
    required List<Fragment> forFragments,
    required Future<void> Function(MemoryGroup filteredMemoryGroup, List<Fragment> filteredFragments) filtered,
  }) async {
    await transaction(
      () async {
        for (var memoryGroup in forMemoryGroups) {
          final List<MemoryGroup2FragmentsCompanion> memoryGroup2FragmentsCompanions = <MemoryGroup2FragmentsCompanion>[];
          final List<Fragment> filteredFragments = <Fragment>[];

          for (var element in forFragments) {
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
          for (var element in memoryGroup2FragmentsCompanions) {
            await into(memoryGroup2Fragments).insert(element);
          }
        }
      },
    );
  }

  /// 插入 [Remember]s。
  /// 每个插入都会检查对应的 [Fragment.id] 是否重复，重复则不插入。
  Future<void> insertRemembers(List<Fragment> forFragments) async {
    // 此处不能用 batch，因为 batch 内的插入并不能在 batch 内部得出结果。
    await transaction(
      () async {
        for (var element in forFragments) {
          final isExist = await DriftDb.instance.retrieveDAO.getIsExistRememberByFragmentId(element.id);
          if (!isExist) {
            await into(remembers).insert(RemembersCompanion.insert(fragmentId: element.id.toValue(), fragmentCloudId: element.cloudId.toValue()));
          }
        }
      },
    );
  }
}
