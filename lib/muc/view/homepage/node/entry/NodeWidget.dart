import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnFragment.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnMemory.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnRule.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/muc/view/homepage/node/longpressednode/LongPressedNodeRoute.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/entry/NodeSheetRouteForComplete.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/entry/NodeSheetRouteForFragment.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/entry/NodeSheetRouteForMemory.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/entry/NodeSheetRouteForRule.dart';
import 'package:hybrid/util/SbHelper.dart';

import 'AbstractNodeWidget.dart';

class NodeWidgetForFragment extends AbstractNodeWidget {
  const NodeWidgetForFragment(PoolNodeModel poolNodeModel) : super(poolNodeModel);

  @override
  Offset get easyPosition => SbHelper.str2Offset(poolNodeModel.getCurrentNodeModel<MPnFragment>().get_easy_position) ?? Offset.zero;

  @override
  Route<void> get onLongPressedRoute => LongPressedNodeRouteForFragment(poolNodeModel);

  @override
  Route<void> get onUpRoute => NodeSheetRouteForFragment(poolNodeModel);

  @override
  String get nodeTitle => poolNodeModel.getCurrentNodeModel<MPnFragment>().get_title ?? 'unknown';
}

class NodeWidgetForMemory extends AbstractNodeWidget {
  const NodeWidgetForMemory(PoolNodeModel poolNodeModel) : super(poolNodeModel);

  @override
  Offset get easyPosition => SbHelper.str2Offset(poolNodeModel.getCurrentNodeModel<MPnMemory>().get_easy_position) ?? Offset.zero;

  @override
  Route<void> get onLongPressedRoute => LongPressedNodeRouteForMemory(poolNodeModel);

  @override
  Route<void> get onUpRoute => NodeSheetRouteForMemory(poolNodeModel);

  @override
  String get nodeTitle => poolNodeModel.getCurrentNodeModel<MPnMemory>().get_title ?? 'unknown';
}

class NodeWidgetForComplete extends AbstractNodeWidget {
  const NodeWidgetForComplete(PoolNodeModel poolNodeModel) : super(poolNodeModel);

  @override
  Offset get easyPosition => SbHelper.str2Offset(poolNodeModel.getCurrentNodeModel<MPnComplete>().get_easy_position) ?? Offset.zero;

  @override
  Route<void> get onLongPressedRoute => LongPressedNodeRouteForComplete(poolNodeModel);

  @override
  Route<void> get onUpRoute => NodeSheetRouteForComplete(poolNodeModel);

  @override
  String get nodeTitle => poolNodeModel.getCurrentNodeModel<MPnComplete>().get_title ?? 'unknown';
}

class NodeWidgetForRule extends AbstractNodeWidget {
  const NodeWidgetForRule(PoolNodeModel poolNodeModel) : super(poolNodeModel);

  @override
  Offset get easyPosition => SbHelper.str2Offset(poolNodeModel.getCurrentNodeModel<MPnRule>().get_easy_position) ?? Offset.zero;

  @override
  Route<void> get onLongPressedRoute => LongPressedNodeRouteForRule(poolNodeModel);

  @override
  Route<void> get onUpRoute => NodeSheetRouteForRule(poolNodeModel);

  @override
  String get nodeTitle => poolNodeModel.getCurrentNodeModel<MPnRule>().get_title ?? 'unknown';
}
