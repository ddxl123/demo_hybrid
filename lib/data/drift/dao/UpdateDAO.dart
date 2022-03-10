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

  Future<bool> updateFragment(Fragment fragment) async {
    return await update(fragments).replace(fragment);
  }

  /// 设置初始化时，第一个随机 [Fragment]。
  /// 前提必须在 [remembers] 表中，存在至少一个 [Remember] 。
  Future<void> initRandomRemembering(RememberStatus rememberStatus) async {
    await transaction(
      () async {
        await update(remembers).write(RemembersCompanion.insert(rememberTimes: 0.toValue(), status: RememberStatus.none.index.toValue()));
        final r = await DriftDb.instance.retrieveDAO.getSingleRandomRemember();
        await update(remembers).replace(r.copyWith(status: rememberStatus.index));
        log('initRandomRemembering');
        log((await (select(remembers)..where((tbl) => tbl.status.equals(rememberStatus.index))).get()).toString());
      },
    );
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
        // if (rememberStatus == RememberStatus.randomRepeat) {
        //   final Remember rr = await DriftDb.instance.retrieveDAO.getRandomRepeatRemember();
        //   await update(remembers).replace(rr.copyWith(status: RememberStatus.randomRepeat.index));
        // } else
        if (rememberStatus != RememberStatus.none) {
          final Remember? rnr = (await DriftDb.instance.retrieveDAO.getRandomNotRepeatRemember());
          if (rnr != null) {
            await update(remembers).replace(rnr.copyWith(status: rememberStatus.index));
          }
        } else {
          throw '未知 rememberStatus: ${rememberStatus.toString()}';
        }
      },
    );
  }
}
