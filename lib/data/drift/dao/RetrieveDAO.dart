import 'package:drift/drift.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/data/drift/table/Cloud.dart';
import 'package:hybrid/data/drift/table/Local.dart';
import 'package:hybrid/jianji/controller/RememberingPageGetXController.dart';

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
  Remembers,
])
class RetrieveDAO extends DatabaseAccessor<DriftDb> with _$RetrieveDAOMixin {
  RetrieveDAO(DriftDb attachedDatabase) : super(attachedDatabase);

  Future<Folder?> getFolderById(int folderId) async {
    return await (select(folders)..where((tbl) => tbl.id.equals(folderId))).getSingleOrNull();
  }

  Future<List<Folder>> getFoldersBySort(int offset, int limit) async {
    return await (select(folders)
          ..orderBy([(u) => OrderingTerm.asc(u.sort)])
          ..limit(limit, offset: offset))
        .get();
  }

  /// 获取 [folder] 内的 [Fragment]s，连带 [folder2Fragments] 查询。
  Future<List<Fragment>> getFolder2Fragments(Folder folder, int offset, int limit) async {
    final result = select(folder2Fragments).join(
      <Join>[
        innerJoin(
          folders,
          folders.id.equalsExp(folder2Fragments.folderId) | folders.cloudId.equalsExp(folder2Fragments.cloudId),
        ),
        innerJoin(
          fragments,
          fragments.id.equalsExp(folder2Fragments.fragmentId) | fragments.cloudId.equalsExp(folder2Fragments.fragmentCloudId),
        ),
      ],
    );
    result.where(folders.id.equals(folder.id) | folders.cloudId.equals(folder.cloudId));
    result.limit(limit, offset: offset);
    return (await result.get()).map((e) => e.readTable(fragments)).toList();
  }

  /// 获取 [folder] 内的 [Fragment]s 的 ids，只需查询 [folder2Fragments]。
  Future<List<int>> getFolder2FragmentsIds(Folder folder) async {
    return (await (select(folder2Fragments)..where((tbl) => tbl.folderId.equals(folder.id) | tbl.folderCloudId.equals(folder.cloudId))).get())
        .map((e) => e.fragmentId!)
        .toList();
  }

  /// 获取 [memoryGroup] 内的 [Fragment]s。
  Future<List<Fragment>> getMemoryGroup2Fragments(MemoryGroup memoryGroup, int offset, int limit) async {
    final result = select(memoryGroup2Fragments).join(
      <Join>[
        innerJoin(memoryGroups,
            memoryGroups.id.equalsExp(memoryGroup2Fragments.memoryGroupId) | memoryGroups.cloudId.equalsExp(memoryGroup2Fragments.memoryGroupCloudId)),
        innerJoin(fragments, fragments.id.equalsExp(memoryGroup2Fragments.fragmentId) | fragments.cloudId.equalsExp(memoryGroup2Fragments.fragmentCloudId)),
      ],
    );
    result.where(memoryGroups.id.equals(memoryGroup.id) | memoryGroups.cloudId.equals(memoryGroup.cloudId));
    result.limit(limit, offset: offset);
    return (await result.get()).map((e) => e.readTable(fragments)).toList();
  }

  Future<Fragment> getSingleFragmentById(int fragmentId) async {
    return await (select(fragments)
          ..where((tbl) => tbl.id.equals(fragmentId))
          ..limit(1))
        .getSingle();
  }

  /// [ids] 为 [Fragment.id]，使用 [Fragment.id] 直接获取，不包括 [Fragment.couldId]。
  Future<List<Fragment>> getFragmentsByIsIn(Iterable<int> ids) async {
    return await (select(fragments)..where((tbl) => tbl.id.isIn(ids))).get();
  }

  Future<List<MemoryGroup>> getMemoryGroups(int offset, int limit) async {
    return await (select(memoryGroups)..limit(limit, offset: offset)).get();
  }

  /// [ins] 为 [MemoryGroup.id]，使用 [MemoryGroup.id] 直接获取，不包括 [MemoryGroup.couldId]。
  Future<List<MemoryGroup>> getMemoryGroupsByIsIn(Iterable<int> ins) async {
    return await (select(memoryGroups)..where((tbl) => tbl.id.isIn(ins))).get();
  }

  /// 获取 [memoryGroup] 内碎片数量。
  Future<int> getMemoryGroup2FragmentCount(MemoryGroup memoryGroup) async {
    final s = selectOnly(memoryGroup2Fragments);
    s.where(memoryGroup2Fragments.memoryGroupId.equals(memoryGroup.id) | memoryGroup2Fragments.memoryGroupCloudId.equals(memoryGroup.cloudId));
    s.addColumns([countAll()]);
    return (await s.getSingle()).read(countAll());
  }

  /// 获取 [folder] 内碎片数量。
  Future<int> getFolder2FragmentCount(Folder folder) async {
    final s = selectOnly(folder2Fragments);
    s.where(folder2Fragments.folderId.equals(folder.id) | folder2Fragments.folderCloudId.equals(folder.cloudId));
    s.addColumns([countAll()]);
    return (await s.getSingle()).read(countAll());
  }

  Future<bool> getIsExistMemoryGroup(Fragment fragment) async {
    return (await (select(memoryGroup2Fragments)
                  ..where((tbl) => tbl.fragmentId.equals(fragment.id) | tbl.fragmentCloudId.equals(fragment.cloudId))
                  ..limit(1))
                .getSingleOrNull()) ==
            null
        ? false
        : true;
  }

  /// 获取 [forMemoryGroups] 内的全部 [Fragment]s，并去除重复行、随机排序。
  Future<List<Fragment>> getMemoryGroup2FragmentsByTidyUpForRemember(List<MemoryGroup> forMemoryGroups) async {
    final result = select(memoryGroup2Fragments, distinct: true).join(
      <Join>[
        innerJoin(memoryGroups,
            memoryGroups.id.equalsExp(memoryGroup2Fragments.memoryGroupId) | memoryGroups.cloudId.equalsExp(memoryGroup2Fragments.memoryGroupCloudId)),
        innerJoin(fragments, fragments.id.equalsExp(memoryGroup2Fragments.fragmentId) | fragments.cloudId.equalsExp(memoryGroup2Fragments.fragmentCloudId)),
      ],
    );
    result.where(memoryGroups.id.isIn(forMemoryGroups.map((e) => e.id)) | memoryGroups.cloudId.isIn(forMemoryGroups.map((e) => e.cloudId)));
    result.orderBy([OrderingTerm.random()]);
    return (await result.get()).map((e) => e.readTable(fragments)).toList();
  }

  Future<List<Fragment>> getAllRemember2Fragments() async {
    final List<Remember> rms = await select(remembers).get();
    return await (select(fragments, distinct: true)..where((tbl) => tbl.id.isIn(rms.map((e) => e.fragmentId)) | tbl.id.isIn(rms.map((e) => e.fragmentCloudId))))
        .get();
  }

  Future<int> getAllRemember2FragmentsCount() async {
    return (await select(remembers, distinct: true).get()).length;
  }

  Future<int> getAllCompleteRemember2FragmentsCount() async {
    return (await (selectOnly(remembers)
              ..where(remembers.rememberTimes.isBiggerOrEqualValue(1))
              ..addColumns([countAll()]))
            .getSingle())
        .read(countAll());
  }

  Future<bool> getIsExistRememberByFragmentId(int fragmentId) async {
    final rs = await (select(remembers)..where((tbl) => tbl.fragmentId.equals(fragmentId))).get();
    if (rs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  /// 获取被标记为 非 [RememberStatus.none] 的行。
  /// 如果返回 null，则为 [RememberStatus.none]。
  Future<Remember?> getRememberingOrNull() async {
    return await (select(remembers)
          ..where((tbl) => tbl.status.equals(RememberStatus.none.index).not())
          ..limit(1))
        .getSingleOrNull();
  }

  /// 获取被标记为 非 [RememberStatus.none] 的 [Remember] 所对应的 [Fragment]。
  /// 如果返回 null，则为 [RememberStatus.none]。
  /// 如果 [Fragment] 未找到，则会抛出异常。
  Future<Fragment?> getRemembering2FragmentOrNull() async {
    final Remember? rn = await getRememberingOrNull();
    if (rn == null) {
      return null;
    }
    return await getSingleFragmentById(rn.fragmentId!);
  }

  /// 前提必须在 [remembers] 表中，存在至少一个 [Remember] 。
  Future<Remember> getSingleRandomRemember() async {
    return await (select(remembers)
          ..orderBy([(u) => OrderingTerm.random()])
          ..limit(1))
        .getSingle();
  }

  Future<Remember?> getRandomNotRepeatRemember() async {
    return await (select(remembers)
          ..where((tbl) => tbl.rememberTimes.equals(0))
          ..orderBy([(u) => OrderingTerm.random()])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<Remember> getRandomRepeatRemember() async {
    return await (select(remembers)
          ..orderBy([(u) => OrderingTerm.random()])
          ..limit(1))
        .getSingle();
  }
}
