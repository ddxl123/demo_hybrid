
import 'package:hybrid/data/sqlite/mmodel/MAppVersionInfo.dart';
import 'package:hybrid/data/sqlite/sqliter/OpenSqlite.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'AppVersionStatus.dart';

enum Compare { frontBig, backBig, equal }

class AppVersionManager {
  ///

  /// 获取被保存在本地应用版本
  /// - **前提: sqlite 数据库中必须存在 version_infos 表，且值必然不为 null**
  Future<String> _getSavedAppVersion() async {
    final MAppVersionInfo appVersionInfo = MAppVersionInfo();
    final String savedVersion = (await db.query(appVersionInfo.tableName, limit: 1)).first[appVersionInfo.saved_version]! as String;
    return savedVersion.toString();
  }

  /// 获取当前应用版本
  Future<String> getCurrentAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// 应用版本检查
  Future<AppVersionStatus> appVersionCheck() async {
    final String currentAppVersion = await getCurrentAppVersion();
    final String saveAppVersion = await _getSavedAppVersion();

    final List<String> currentAppVersionString = currentAppVersion.split('.');
    final List<String> saveAppVersionString = saveAppVersion.split('.');

    final Compare zeroCompare = compare(int.parse(currentAppVersionString[0]), int.parse(saveAppVersionString[0]));
    final Compare oneCompare = compare(int.parse(currentAppVersionString[1]), int.parse(saveAppVersionString[1]));
    final Compare twoCompare = compare(int.parse(currentAppVersionString[2]), int.parse(saveAppVersionString[2]));

    if (zeroCompare == Compare.frontBig) {
      return AppVersionStatus.changeDbAfterUpload;
    } else if (zeroCompare == Compare.backBig) {
      return AppVersionStatus.back;
    } else {
      if (oneCompare == Compare.frontBig) {
        return AppVersionStatus.changeDbNotUpload;
      } else if (oneCompare == Compare.backBig) {
        return AppVersionStatus.back;
      } else {
        if (twoCompare == Compare.frontBig) {
          return AppVersionStatus.notChangeDB;
        } else if (twoCompare == Compare.backBig) {
          return AppVersionStatus.back;
        } else {
          return AppVersionStatus.keep;
        }
      }
    }
  }

  /// 若 [front] 大于 [back]，
  /// - 则返回 [Compare.frontBig]，
  ///
  /// 若 [front] 小于 [back]，
  /// - 则返回 [Compare.backBig]，
  ///
  /// 若 [front] 等于 [back]，
  /// - 则返回 [Compare.equal]，
  Compare compare(int front, int back) {
    if (front > back) {
      return Compare.frontBig;
    } else if (front < back) {
      return Compare.backBig;
    } else {
      return Compare.equal;
    }
  }
}
