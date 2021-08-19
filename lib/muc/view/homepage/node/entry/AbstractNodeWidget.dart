
import 'package:flutter/material.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/muc/view/homepage/poolentry/AbstractPoolEntry.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBoxWidget.dart';

abstract class AbstractNodeWidget extends AbstractPoolEntryWidget {
  const AbstractNodeWidget(PoolNodeModel poolNodeModel) : super(poolNodeModel);

  @override
  Widget build(BuildContext context) {
    return SbFreeBoxPositioned(
      easyPosition: easyPosition,
      child: SbButton(
        child: Material(
          child: Text(nodeTitle),
        ),
        onLongPressed: (_) {
          SbHelper().getNavigator!.push(onLongPressedRoute);
        },
        onUp: (_) {
          SbHelper().getNavigator!.push(onUpRoute);
        },
      ),
    );
  }

  Offset get easyPosition;

  String get nodeTitle;

  Route<void> get onLongPressedRoute;

  Route<void> get onUpRoute;
}
