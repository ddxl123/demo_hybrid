import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 版本号规范：
/// 主版本号.特征版本号.修正版本号.送测版本号+构建次数 1.0.0.0+1
///
/// 主版本号：当本地数据库结构发生改变，且需要完成同步后才能更新应用时，主版本号+1，主版本号之后的所有版本号归0，构建次数+1。
///   如：版本号1.0.1.2+5，当主版本号+1 -> 2.0.0.0+6
///
/// 特征版本号：当本地数据库结构发生改变，但无需完成同步便能更新应用时，特征版本号+1，主版本号不变，特征版本号之后的所以版本号归0，构建次数+1。
///   如：版本号1.0.1.2+5，当特征版本号+1 -> 1.1.0.0+6
///
/// 修正版本号：当本地数据库结构未发生改变时，修正版本号+1，主版本号、特征版本号不变，送测版本号归0，构建次数+1。
///   如：版本号1.0.1.2+5，当修正版本号+1 -> 1.0.2.0+6
///
/// 送测版本号：发布的测试版
///   如：版本号1.0.1.2+5，当送测版本号+1 -> 1.0.1.3+6
///
/// 构建次数：不会因之前的版本号改变而归0，任何版本号变动后构建次数+1。

enum AppVersionStatus {
  /// 当前本地数据库结构发生改变，且需要完成同步后才能更新应用时。
  currentFirstBig,

  /// 当前本地数据库结构发生改变，但无需完成同步便能更新应用时。
  currentSecondBig,

  /// 当前本地数据库结构未发生改变时。
  currentThirdBig,

  /// 测试版本。
  currentFourBig,

  /// 存储版本与当前版本相同。
  equal,

  /// 存储版本高于当前版本，即版本回退。
  back,
}

class AppVersionManager {
  ///

  /// 获取被记录在本地的应用版本。
  Future<String> getSavedAppVersion() async => await DriftDb.instance.easyDAO.getSavedAppVersion();

  /// 获取当前应用版本
  Future<String> getCurrentAppVersion() async => (await PackageInfo.fromPlatform()).version;

  /// 应用版本检查
  Future<AppVersionStatus> check() async {
    final String currentAppVersion = await getCurrentAppVersion();
    final String saveAppVersion = await getSavedAppVersion();

    if (currentAppVersion == saveAppVersion) {
      return AppVersionStatus.equal;
    }

    final List<String> currentAppVersionString = currentAppVersion.split('.');
    final List<String> saveAppVersionString = saveAppVersion.split('.');

    if (int.parse(currentAppVersionString[0]) > int.parse(saveAppVersionString[0])) {
      return AppVersionStatus.currentFirstBig;
    } else if (int.parse(currentAppVersionString[1]) > int.parse(saveAppVersionString[1])) {
      return AppVersionStatus.currentSecondBig;
    } else if (int.parse(currentAppVersionString[2]) > int.parse(saveAppVersionString[2])) {
      return AppVersionStatus.currentThirdBig;
    } else if (int.parse(currentAppVersionString[3]) > int.parse(saveAppVersionString[3])) {
      return AppVersionStatus.currentFourBig;
    } else {
      return AppVersionStatus.back;
    }
  }
}
