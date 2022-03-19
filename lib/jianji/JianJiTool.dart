import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:text_selection_controls/text_selection_controls.dart';

import '../engine/constant/execute/OToNative.dart';
import '../engine/transfer/TransferManager.dart';

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
