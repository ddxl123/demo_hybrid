class CheckUser {
  static Future<void> check() async {
    // 检测本地是否存在账号信息？------------ 0
    if (true) {
      // 本地存在账号信息。

      // 对 token 进行云端验证？
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

  static Future<void> checkCopy() async {
    // 检测本地是否存在账号信息？------------ 0
    if (true) {
      // 本地存在账号信息。

      // 对 token 进行云端验证？
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
