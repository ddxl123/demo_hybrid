import 'package:drift/drift.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/data/drift/table/Cloud.dart';
import 'package:hybrid/data/drift/table/Local.dart';

part 'RetrieveDAO.g.dart';

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
class RetrieveDAO extends DatabaseAccessor<DriftDb> with _$RetrieveDAOMixin {
  RetrieveDAO(DriftDb attachedDatabase) : super(attachedDatabase);

  /// 不包含 offset 本身，
  Future<List<Folder>> getFolders(int offset, int limit) async {
    return await (select(folders)..limit(limit, offset: offset)).get();
  }

  Future<List<Fragment>> getFragments(Folder folder, int offset, int limit) async {
    final result = await (select(folder2Fragments).join(
      <Join>[
        innerJoin(
          folders,
          (folders.id.equalsExp(folder2Fragments.folderId) | folders.cloudId.equalsExp(folder2Fragments.cloudId)),
        ),
        innerJoin(
          fragments,
          (fragments.id.equalsExp(folder2Fragments.fragmentId) | fragments.cloudId.equalsExp(folder2Fragments.fragmentCloudId)),
        ),
      ],
    )
          ..where(folders.id.equals(folder.id) | folders.cloudId.equals(folder.cloudId))
          ..limit(limit, offset: offset))
        .get();
    return result.map((e) => e.readTable(fragments)).toList();
  }

  Future<List<MemoryGroup>> getMemoryGroups(int offset, int limit) async {
    return await (select(memoryGroups)..limit(limit, offset: offset)).get();
  }
}
