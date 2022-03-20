import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:text_selection_controls/text_selection_controls.dart';

import '../data/mysql/http/Httper.dart';
import '../engine/constant/execute/OToNative.dart';
import '../engine/transfer/TransferManager.dart';
import '../util/SbHelper.dart';

FlutterSelectionControls selectionControlForSearchByBrowser(BuildContext context) {
  return FlutterSelectionControls(
    toolBarItems: [
      ToolBarItem(
        item: const Text('复制', style: TextStyle(color: Colors.blue)),
        itemControl: ToolBarItemControl.copy,
      ),
      ToolBarItem(
        item: const Text('全选', style: TextStyle(color: Colors.blue)),
        itemControl: ToolBarItemControl.selectAll,
      ),
      ToolBarItem(
        item: const Text('搜索选中内容', style: TextStyle(color: Colors.blue)),
        onItemPressed: (String highlightedText, int startIndex, int endIndex) async {
          OkCancelResult o = await showOkCancelAlertDialog(
            context: context,
            message: '是否在浏览器搜索以下内容？\n$highlightedText',
            okLabel: '是',
            cancelLabel: '否',
            isDestructiveAction: true,
          );
          if (o == OkCancelResult.ok) {
            await TransferManager.instance.transferExecutor.toNative<String, bool>(
              operationId: OToNative.LAUNCH_WEB,
              setSendData: () => 'https://www.baidu.com/s?wd=$highlightedText',
              resultDataCast: (Object resultData) => resultData as bool,
            );
          }
        },
      ),
    ],
  );
}

bool once = false;
bool isShortNotRemind = false;

/// [currentAppVersion] 必须与服务器版本相同。
int currentAppVersion = 2;
int dioAppVersion = 1;
String appUpdateContent = '请先检查更新！';

Future<void> showCheckAppVersionUpdate({required BuildContext context, required bool isForceShow, required bool isShowToastWhenNotUpdate}) async {
  if (!isForceShow && isShortNotRemind) {
    return;
  }
  if (!once) {
    once = true;
  }
  await Httper.dio.get('http://8.134.133.105/examples/check_update.html').then(
    (response) async {
      List<String> dataList = response.data.toString().split('|');
      int getVersion = int.parse(dataList.first.trim());
      String getUpdateContent = dataList.last.trim();
      dioAppVersion = getVersion;
      appUpdateContent = getUpdateContent;

      if (currentAppVersion != dioAppVersion) {
        int? actionResult = await showAlertDialog(
          context: context,
          title: '检测到应用有新的版本，是否进行更新？',
          message: '当前版本 $currentAppVersion -> 最新版本 $dioAppVersion\n\n\n' + appUpdateContent,
          actions: const [
            AlertDialogAction(key: 2, label: '短时间内不再提醒'),
            AlertDialogAction(key: 1, label: '暂时不更新'),
            AlertDialogAction(key: 0, label: '立即更新', isDestructiveAction: true),
          ],
        );
        if (actionResult == 0) {
          SingleResult singleResult = await TransferManager.instance.transferExecutor.toNative(
            operationId: OToNative.LAUNCH_WEB,
            setSendData: () => 'http://8.134.133.105/examples/app-debug.apk',
            resultDataCast: (result) => result as bool,
          );
          await singleResult.handle(
            doSuccess: (successData) async {},
            doError: (SingleResult<dynamic> errorResult) async {
              throw errorResult;
            },
          );
        } else if (actionResult == 1) {
        } else if (actionResult == 2) {
          isShortNotRemind = true;
        }
      } else {
        if (isShowToastWhenNotUpdate) {
          EasyLoading.showToast('已经是最新版本了！');
        }
      }
    },
  ).onError(
    (e, st) async {
      EasyLoading.showToast('检测更新时发生异常，请联系管理员！\n${e.toString()}');
    },
  ).whenComplete(
    () {
      once = false;
    },
  );
}

Future<void> showAppInstruction({required BuildContext context}) async {
  await showAlertDialog(
    context: context,
    title: '软件使用说明',
    message: '本软件为解决某些人偷懒而不学习的燃眉之急，临时定制开发的一款软件。\n\n本软件不太稳定，甚至可能会丢失数据，暂不适合将持久性的知识点存储在本软件中。'
        '\n'
        '\n'
        '\n成组：意思是将「已选好的知识点」添加到「已选好的记忆组」中。'
        '\n'
        '\n'
        '\n●「选择知识点」：'
        '\n'
        '\n1. 点击「成组」橙色按钮切换到成组模式。'
        '\n'
        '\n2. 创建「知识类别」文件夹，并在文件夹内创建知识点（「预设选项」中包含了已创建好的系列知识点）。'
        '\n'
        '\n3. 点击全选，或点击「右边的小圆圈」进行单选。'
        '\n'
        '\n4. 选好了「知识点」后，便可返回到主页面。'
        '\n'
        '\n'
        '\n●「选择记忆组」：'
        '\n'
        '\n1. 在「记忆组页面」创建组后，点击「右边的小圈圈」选中该「记忆组」。'
        '\n'
        '\n2. 这时已选好了「记忆组」。'
        '\n'
        '\n'
        '\n●「执行记忆」：'
        '\n'
        '\n1. 选好了「知识点」和「记忆组」后，可再次点击「成组」（橙色）按钮，执行「成组」，便会将「已选好的知识点」添加到「已选好的记忆组」中。'
        '\n'
        '\n2. 点击「记」绿色按钮后，选择一个「记忆组」（「右边的小圈圈」进行选中）'
        '\n'
        '\n3. 再次点击「记」绿色按钮后，执行「开始记忆」。'
        '\n'
        '\n4. 在任务列表内，点击「未开始」橙色按钮，可选择记忆方式。'
        '\n'
        '\n5. 建议选择「悬浮模式」，可进行被动式学习！'
        '\n'
        '\n'
        '\n最后，享受被动学习的乐趣吧！',
  );
}
