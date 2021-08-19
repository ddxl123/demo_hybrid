
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/muc/view/homepage/selectpool/SelectPoolRoute.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBoxController.dart';

class HomePageGetController extends GetxController {
  SbFreeBoxController sbFreeBoxController = SbFreeBoxController();

  void toSelectPool(Rect triggerRect) {
    SbHelper().getNavigator!.push(SelectPoolRoute(triggerRect: triggerRect));
  }
}
