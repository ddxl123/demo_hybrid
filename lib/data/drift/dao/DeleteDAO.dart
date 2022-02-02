import 'package:drift/drift.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/data/drift/table/Cloud.dart';
import 'package:hybrid/data/drift/table/Local.dart';

part 'DeleteDAO.g.dart';

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
class DeleteDAO extends DatabaseAccessor<DriftDb> with _$DeleteDAOMixin {
  DeleteDAO(DriftDb attachedDatabase) : super(attachedDatabase);

  /// 删除 [Fragment] 连带 [Folder2Fragment]、[MemoryGroup2Fragment]
  Future<void> deleteFragmentWith(Fragment fragment) async {
    await transaction(
      () async {
        await (delete(fragments)..where((tbl) => tbl.id.equals(fragment.id))).go();
        await (delete(folder2Fragments)..where((tbl) => tbl.fragmentId.equals(fragment.id) | tbl.fragmentCloudId.equals(fragment.cloudId))).go();
        await (delete(memoryGroup2Fragments)..where((tbl) => tbl.fragmentId.equals(fragment.id) | tbl.fragmentCloudId.equals(fragment.cloudId))).go();
      },
    );
  }

  /// 删除 [Folder] 连带 [Fragment]。[Folder2Fragment]，[MemoryGroup2Fragment]
  Future<void> deleteFolderWith(Folder folder) async {
    await transaction(
      () async {
        await (delete(folders)..where((tbl) => tbl.id.equals(folder.id))).go();
        final List<Folder2Fragment> f2fs =
            await (select(folder2Fragments)..where((tbl) => tbl.folderId.equals(folder.id) | tbl.folderCloudId.equals(folder.cloudId))).get();
        await (delete(fragments)..where((tbl) => tbl.id.isIn(f2fs.map((e) => e.fragmentId)) | tbl.cloudId.isIn(f2fs.map((e) => e.fragmentCloudId)))).go();
        await (delete(folder2Fragments)..where((tbl) => tbl.folderId.equals(folder.id) | tbl.folderCloudId.equals(folder.cloudId))).go();
        await (delete(memoryGroup2Fragments)
              ..where((tbl) => tbl.fragmentId.isIn(f2fs.map((e) => e.fragmentId)) | tbl.fragmentCloudId.isIn(f2fs.map((e) => e.fragmentCloudId))))
            .go();
      },
    );
  }

  /// 删除 [MemoryGroup] 连带 [MemoryGroup2Fragment]
  Future<void> deleteMemoryGroupWith(MemoryGroup memoryGroup) async {
    await transaction(
      () async {
        await (delete(memoryGroups)..where((tbl) => tbl.id.equals(memoryGroup.id))).go();
        await (delete(memoryGroup2Fragments)..where((tbl) => tbl.memoryGroupId.equals(memoryGroup.id) | tbl.memoryGroupCloudId.equals(memoryGroup.cloudId)))
            .go();
      },
    );
  }
}
