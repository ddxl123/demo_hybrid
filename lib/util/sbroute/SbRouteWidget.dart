import 'package:flutter/material.dart';

import 'SbPopResult.dart';
import 'SbRoute.dart';

class SbRouteWidget extends StatefulWidget {
  const SbRouteWidget(this.sbPopupRoute);

  final SbRoute sbPopupRoute;

  @override
  _SbRouteWidgetState createState() => _SbRouteWidgetState();
}

class _SbRouteWidgetState extends State<SbRouteWidget> {
  @override
  void initState() {
    super.initState();
    widget.sbPopupRoute.onInit();
    widget.sbPopupRoute.sbRouteSetState = () {
      if (mounted) {
        setState(() {});
      }
    };
    WidgetsBinding.instance!.addPostFrameCallback((Duration timeStamp) {
      widget.sbPopupRoute.onRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.sbPopupRoute.onBuild();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            background(),
            ...widget.sbPopupRoute.body(),
            popWaiting(),
          ],
        ),
      ),
    );
  }

  /// 背景
  Widget background() {
    return Positioned(
      top: 0,
      child: Listener(
        onPointerUp: (_) {
          widget.sbPopupRoute.toPop(
            SbPopResult(value: null, popResultSelect: PopResultSelect.clickBackground),
          );
        },
        child: Opacity(
          opacity: widget.sbPopupRoute.backgroundOpacity,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: widget.sbPopupRoute.backgroundColor,
          ),
        ),
      ),
    );
  }

  /// popWaiting
  Widget popWaiting() {
    return Positioned(
      top: 0,
      child: Offstage(
        offstage: !widget.sbPopupRoute.isPopWaiting,
        child: Opacity(
          opacity: 0.5,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            color: Colors.white,
            child: const Text('等待中...'),
          ),
        ),
      ),
    );
  }
}
