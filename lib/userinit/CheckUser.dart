import 'package:hybrid/data/mysql/http/HttpCurd.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpResponse.dart';
import 'package:hybrid/data/mysql/httpstore/store/notjwt/verifytoken/HttpStore_verify_token.dart';
import 'package:hybrid/data/sqlite/mmodel/MUser.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class CheckUser {
  ///

  /// 验证并刷新 token (如果验证成功)。
  ///
  /// 成功返回 true，jwt 异常返回 false（比如 token 过期），其他异常返回 null。
  static Future<bool> _verifyToken(MUser mUser) async {
    bool isTokenVerifyAndRefreshSuccess = false;
    final HttpStore_verify_token result = await HttpCurd.sendRequest(
      httpStore: HttpStore_verify_token(
        setRequestDataVO_VT: () => RequestDataVO_VT(
          token: mUser.get_token,
        ),
      ),
      sameNotConcurrent: null,
    );

    await result.httpResponse.handle(
      doCancel: (HttpResponse<ResponseCodeCollect_VT, ResponseDataVO_VT> hr) async {
        isTokenVerifyAndRefreshSuccess = false;
        SbLogger(code: hr.code, viewMessage: hr.viewMessage, data: null, description: hr.description, exception: hr.exception, stackTrace: hr.stackTrace)
            .withAll(true);
      },
      doContinue: (HttpResponse<ResponseCodeCollect_VT, ResponseDataVO_VT> hr) {},
    );

    return isTokenVerifyAndRefreshSuccess;
  }

  // 则先弹出弹出清空除了账号信息外其他全部数据的页面，再弹出下载初始化数据的页面。
  static void pushDownloadInitDataPage() {
    if (true) {
      // 下载成功，完成。------------ 2
    } else {
      // 下载失败，自动重新下载三遍后仍然失败，则显示重新下载按钮。
      // 下载成功，则 ————————————> 2
    }
  }

  /// 用户点击登陆时检查要登陆的账号是否与本地已存在的账号信息是否相匹配（登陆页面显示像QQ登陆页面那样的多账号，不过这里只是一个历史账号（如果有））。
  static void pushRegisterAndLoginPage() {
    if (true) {
      // 相匹配。

      // 向云端获取 token 是否成功？
      if (true) {
        // 获取成功，则 ————————————> 1
      } else {
        // 获取失败。
      }
    } else {
      // 不相匹配。

      // 弹出提示框，提示用户是否切换账号，切换账号会清除原账号的全部数据，清空数据后需重启应用？
      if (true) {
        // 是。则删除并重启后 ————————————> 0
      } else {
        // 否。
      }
    }
  }

  /// 若返回 true，则表示通过，可以执行下一个任务。
  ///
  /// 若返回 false，则表示未通过，不可执行下一个任务。其中，[check] 内部弹出页面时会立即返回结果，该返回的结果皆为 false。
  static Future<bool> check() async {
    try {
      // 检测本地是否存在账号信息？
      final List<MUser> mUsers = await ModelManager.queryRowsAsModels(connectTransaction: null, tableName: MUser().tableName);
      if (mUsers.isNotEmpty) {
        // 本地存在账号信息。
        final MUser user = mUsers.first;

        // 对 token 进行云端验证，如果验证成功则获取新 token？
        final bool isTokenVerifySuccess = await _verifyToken(user);
        if (isTokenVerifySuccess) {
          // 验证成功，即用户已登陆。

          // 检测本地初始化数据是否已下载？------------ 1
          if (user.get_is_downloaded_init_data == 1) {
            // 已下载，完成。
            return true;
          } else {
            // 未下载。

            // 弹出下载的相关页面。
            pushDownloadInitDataPage();
            return false;
          }
        } else {
          // 验证失败，即用户未登录，或 token 过期。

          // 弹出登陆页面。
          pushRegisterAndLoginPage();
          return false;
        }
      } else {
        // 本地不存在账号信息。

        // 弹出登陆页面。
        pushRegisterAndLoginPage();
        return false;
      }
    } catch (e, st) {
      SbLogger(code: -1, viewMessage: '发生异常！', data: null, description: Description('CheckUser 异常！'), exception: e, stackTrace: st).withAll(true);
      return false;
    }
  }

  ///
  ///
  ///
  ///
  static Future<void> checkCopy() async {
    // 检测本地是否存在账号信息？------------ 0
    if (true) {
      // 本地存在账号信息。

      // 对 token 进行云端验证，如果验证成功则获取新 token？
      if (true) {
        // 验证成功，即用户已登陆。

        // 检测本地初始化数据是否已下载？------------ 1
        if (true) {
          // 已下载，完成。
        } else {
          // 未下载，

          // 则先弹出弹出清空除了账号信息外其他全部数据的页面，再弹出下载初始化数据的页面？
          if (true) {
            // 下载成功，完成。------------ 2
          } else {
            // 下载失败，自动重新下载三遍后仍然失败，则显示重新下载按钮。
            // 下载成功，则 ————————————> 2
          }
        }
      } else {
        // 验证失败，即用户未登录，或 token 过期。

        // 弹出登陆页面。用户点击登陆时检查要登陆的账号是否与本地已存在的账号信息是否相匹配（登陆页面显示像QQ登陆页面那样的多账号，不过这里只是一个历史账号（如果有））？
        if (true) {
          // 相匹配。

          // 向云端获取 token 是否成功？------------ 3
          if (true) {
            // 获取成功，则 ————————————> 1
          } else {
            // 获取失败。
          }
        } else {
          // 不相匹配。

          // 弹出提示框，提示用户是否切换账号，切换账号会清除原账号的全部数据，清空数据后需重启应用？
          if (true) {
            // 是。则删除并重启后 ————————————> 0
          } else {
            // 否。
          }
        }
      }
    } else {
      // 本地不存在账号信息。

      // 弹出登陆页面，并 ————————————> 3
    }
  }
}
