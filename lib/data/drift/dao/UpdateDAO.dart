import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/data/drift/table/Cloud.dart';
import 'package:hybrid/data/drift/table/Local.dart';
import 'package:hybrid/jianji/controller/RememberingPageGetXController.dart';
import 'package:hybrid/util/SbHelper.dart';

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
  Remembers,
])
class UpdateDAO extends DatabaseAccessor<DriftDb> with _$UpdateDAOMixin {
  UpdateDAO(DriftDb attachedDatabase) : super(attachedDatabase);

  /// [upOrDown] 0表示向上移动，1表示向下移动
  /// 返回上一个或下一个 [Folder] id，为空表示没有上一个或下一个。
  Future<int?> updateSortFolder(int currentFolderSort, int upOrDown) async {
    return await transaction<int?>(
      () async {
        // 获取按照 sort 排序后的全部 folders。
        final sortFolders = await DriftDb.instance.retrieveDAO.getFoldersBySort(0, 9999);

        // 仅查看 sort。
        // sorts_index 与 sortFolders_index 的 index 一一对应。
        final sorts = sortFolders.map((e) => e.sort).toList();

        final currentIndex = sorts.indexOf(currentFolderSort);
        final currentFolder = sortFolders[currentIndex];

        if (upOrDown == 0) {
          if (currentIndex == 0) {
            // 没有上一个了。
            return null;
          }
          final previousIndex = sorts[currentIndex - 1]!;
          final previousFolder = sortFolders[previousIndex];

          await update(folders).replace(currentFolder.copyWith(sort: previousFolder.sort));
          await update(folders).replace(previousFolder.copyWith(sort: currentFolder.sort));
          return previousFolder.id;
        } else if (upOrDown == 1) {
          if (currentIndex == sorts.length - 1) {
            // 没有下一个了。
            return null;
          }
          log('message');
          log(sorts.toString());
          log(sortFolders.toString());
          final nextIndex = sorts[currentIndex + 1]!;
          final nextFolder = sortFolders[nextIndex];

          await update(folders).replace(currentFolder.copyWith(sort: nextFolder.sort));
          await update(folders).replace(nextFolder.copyWith(sort: currentFolder.sort));
          return nextFolder.id;
        } else {
          throw '未知 upOrDown: $upOrDown';
        }
      },
    );
  }

  Future<bool> updateFragment(Fragment fragment) async {
    return await update(fragments).replace(fragment);
  }

  /// 设置初始化时，第一个随机 [Fragment]。
  /// 前提必须在 [remembers] 表中，存在至少一个 [Remember] 。
  Future<void> updateInitRandomRemembering(RememberStatus rememberStatus) async {
    await transaction(
      () async {
        final r = await DriftDb.instance.retrieveDAO.getSingleRandomRemember();
        await update(remembers).replace(r.copyWith(status: rememberStatus.index));
      },
    );
  }

  /// 恢复至未初始化状态。
  Future<void> updateBeforeInitRemembering() async {
    await update(remembers).write(RemembersCompanion.insert(rememberTimes: 0.toValue(), status: RememberStatus.none.index.toValue()));
  }

  /// 更新当前：必须当前 [Remember] 的 [RememberStatus] 不为 [RememberStatus.none]。
  ///   - 若当前为空，则对当前无操作，且对下一个也无操作。
  /// 更新下一个：没有下一个时无操作。
  Future<void> updateCurrentAndNextRemember(RememberStatus rememberStatus) async {
    await transaction(
      () async {
        // 更新当前。
        final Remember? r = (await DriftDb.instance.retrieveDAO.getRememberingOrNull());
        if (r != null) {
          await update(remembers).replace(r.copyWith(rememberTimes: r.rememberTimes + 1, status: RememberStatus.none.index));
        } else {
          return;
        }

        // 更新下一个。
        if (rememberStatus == RememberStatus.randomRepeat) {
          final Remember rr = await DriftDb.instance.retrieveDAO.getRandomRepeatRemember();
          await update(remembers).replace(rr.copyWith(status: RememberStatus.randomRepeat.index));
        } else if (rememberStatus == RememberStatus.randomNotRepeat) {
          final Remember? rnr = (await DriftDb.instance.retrieveDAO.getRandomNotRepeatRemember());
          if (rnr != null) {
            await update(remembers).replace(rnr.copyWith(status: RememberStatus.randomNotRepeat.index));
          }
        } else {
          throw '未知 rememberStatus: ${rememberStatus.toString()}';
        }
      },
    );
  }
}
