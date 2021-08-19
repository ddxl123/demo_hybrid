
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/muc/view/homepage/poolentry/AbstractPoolEntry.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sheetroute/SbSheetRouteController.dart';

import '../more/AbstractMoreRoute.dart';

/// [FDM] 碎片数据模型。
abstract class AbstractNodeSheetRoute<FDM extends ModelBase> extends AbstractPoolEntrySheetRoute<FDM> {
  AbstractNodeSheetRoute(PoolNodeModel poolNodeModel) : super(poolNodeModel);

  @override
  Widget bodySliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        bodyBuilder,
        childCount: sheetPageController.bodyData.length,
      ),
    );
  }

  @override
  Future<void> bodyDataFuture(List<FDM> bodyData, Mark mark);

  @override
  Widget headerSliver() {
    return SliverToBoxAdapter(
      child: Container(
        child: Row(
          children: <Widget>[
            Text(nodeTitle),
            Expanded(child: Container()),
            TextButton(
              child: const Icon(Icons.more_horiz),
              onPressed: () {
                SbHelper().getNavigator!.push(moreRoute);
              },
            ),
          ],
        ),
        color: Colors.white,
      ),
    );
  }

  @override
  void popMethod() {
    SbHelper().getNavigator!.removeRoute(this);
  }

  @override
  Widget failureWidget() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text('获取失败！'),
      ),
    );
  }

  @override
  Widget loadingWidget() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text('获取中...'),
      ),
    );
  }

  @override
  Widget noMoreWidget() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text('没有更多了~'),
      ),
    );
  }

  String get nodeTitle;

  /// 点右上角更多的按钮要触发的 route
  AbstractMoreRoute<FDM> get moreRoute;

  Widget? bodyBuilder(BuildContext context, int index);
}
