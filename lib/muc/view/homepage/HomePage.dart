import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/global/Global.dart';
import 'package:hybrid/muc/getcontroller/homepage/HomePageGetController.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/muc/view/homepage/poolentry/PoolEntry.dart';
import 'package:hybrid/muc/view/loginpage/LoginPage.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBox.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBoxWidget.dart';



class HomePage extends StatelessWidget {
  final HomePageGetController _homePageController = Get.put(HomePageGetController());
  final PoolGetController _fragmentPoolGetController = Get.put(PoolGetController());

  @override
  Widget build(BuildContext context) {
    return SbButton(
      child: SbFreeBox(
        sbFreeBoxController: _homePageController.sbFreeBoxController,
        boxSize: Size(screenSize.width, screenSize.height),
        fixedLayerWidgets: _fixedLayerWidgets(context),
        freeMoveScaleLayerWidgets: _freeMoveScaleLayerWidgets(),
      ),
      onLongPressed: (PointerDownEvent event) {
        SbHelper.getNavigator!.push(PoolEntry().toLongPressPool());
      },
    );
  }

  Stack _fixedLayerWidgets(BuildContext context) {
    return Stack(
      children: <Positioned>[
        _bottomWidgets(context),
      ],
    );
  }

  Positioned _bottomWidgets(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        /// Row在Stack中默认不是撑满宽度
        width: screenSize.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: TextButton(onPressed: () {}, child: const Text('发现'))),
            Expanded(
              child: SbRectWidget(
                builder: (Rect Function() getRect) {
                  return TextButton(
                    onPressed: () {
                      _homePageController.toSelectPool(getRect());
                    },
                    child: GetBuilder<PoolGetController>(
                      builder: (PoolGetController controller) {
                        return Text(controller.currentPoolType.text);
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: TextButton(
                child: const Text('我'),
                onPressed: () {
                  SbHelper.getNavigator!.push(LoginPage());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _freeMoveScaleLayerWidgets() {
    return GetBuilder<PoolGetController>(
      builder: (PoolGetController fragmentPoolGetController) {
        return SbFreeBoxStack(
          builder: (BuildContext context, void Function(void Function()) bSetState) {
            return <Widget>[
              for (int i = 0; i < fragmentPoolGetController.currentPoolData.length; i++) PoolEntry().toNode(fragmentPoolGetController.currentPoolData[i]),
            ];
          },
        );
      },
    );
  }
}
