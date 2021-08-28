

import 'package:hybrid/appversion/AppVersionManager.dart';
import 'package:hybrid/appversion/AppVersionStatus.dart';
import 'package:hybrid/data/sqlite/mmodel/MAppVersionInfo.dart';
import 'package:hybrid/data/sqlite/mmodel/ParseIntoSqls.dart';
import 'package:hybrid/util/SbHelper.dart';

import '../../../Config.dart';
import 'OpenSqlite.dart';
import 'SqliteDiag.dart';
import 'SqliteTest.dart';
import 'SqliteTool.dart';

enum SqliteInitResult {
  /// 没问题。
  ok,

  /// 版本相同，但表结构不一致。可能是新版本应用修改了数据表结构，但版本号没有进行修改，导致覆盖安装，
  sameVersionButTableInconsistent,

  /// 查看: [AppVersionStatus.back]。
  back,

  /// 查看: [AppVersionStatus.notChangeDB]。
  notChangeDB,

  /// 查看: [AppVersionStatus.changeDbNotUpload]。
  changeDbNotUpload,

  /// 查看: [AppVersionStatus.changeDbAfterUpload]。
  changeDbAfterUpload,
}

class SqliteInit {
  Future<SqliteInitResult> init() async {
    // 打开 sqlite。
    await openDb();

    if (isDev) {
      await SqliteTool().dropAllTable();
    }

    // 检查应用是否第一次被打开: 根据 [version_info] 表是否存在进行检查
    SqliteInitResult sqliteInitResult;
    if (await SqliteDiag().isTableExist(MAppVersionInfo().tableName)) {
      sqliteInitResult = await _noFirstInit();
    } else {
      sqliteInitResult = await _firstInit();
    }

    if (isDev) {
      await SqliteTest().createTestData();
    }

    return sqliteInitResult;
  }

  // 非第一次打开
  Future<SqliteInitResult> _noFirstInit() async {
    // 检查 app 版本的准确性
    final AppVersionStatus appVersionStatus = await AppVersionManager().appVersionCheck();

    // 如果 app 版本一致，则进行表的一致性检查。
    if (appVersionStatus == AppVersionStatus.keep) {
      final bool isTableConsistent = await SqliteDiag().isTableConsistent(ParseIntoSqls().parseIntoSqls);
      if (!isTableConsistent) {
        return SqliteInitResult.sameVersionButTableInconsistent;
      }
    }

    if (appVersionStatus == AppVersionStatus.back) {
      return SqliteInitResult.back;
    }
    if (appVersionStatus == AppVersionStatus.notChangeDB) {
      return SqliteInitResult.notChangeDB;
    }
    if (appVersionStatus == AppVersionStatus.changeDbNotUpload) {
      return SqliteInitResult.changeDbNotUpload;
    }
    if (appVersionStatus == AppVersionStatus.changeDbAfterUpload) {
      return SqliteInitResult.changeDbAfterUpload;
    }

    return SqliteInitResult.ok;
  }

  // 第一次打开 app
  Future<SqliteInitResult> _firstInit() async {
    // 创建全部表
    await SqliteTool().createAllTables(ParseIntoSqls().parseIntoSqls);

    // 创建 [version_infos] 信息
    final String currentAppVersion = await AppVersionManager().getCurrentAppVersion();
    final MAppVersionInfo appVersionInfo = MAppVersionInfo.createModel(
      id: null,
      aiid: null,
      uuid: null,
      created_at: SbHelper.newTimestamp,
      updated_at: SbHelper.newTimestamp,
      saved_version: currentAppVersion,
    );
    await db.insert(appVersionInfo.tableName, appVersionInfo.getRowJson);

    return SqliteInitResult.ok;
  }
}
