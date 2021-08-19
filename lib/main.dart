import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';
import 'package:hybrid/util/sheetroute/SbSheetRoute.dart';
import 'package:hybrid/util/sheetroute/SbSheetRouteController.dart';

import 'muc/view/appinitpage/AppInitPage.dart';
import 'muc/view/homepage/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SbButtonApp(
      child: GetMaterialApp(
        home: AppInitPage(
          builder: () => HomePage(),
        ),
      ),
    );
    // return FlutterTest();
  }
}

@pragma('vm:entry-point')
void point1() {
  runApp(const Point1());
}

class Point1 extends StatefulWidget {
  const Point1({Key? key}) : super(key: key);

  @override
  _Point1State createState() => _Point1State();
}

class _Point1State extends State<Point1> {
  @override
  Widget build(BuildContext context) {
    print('Point1 build');
    return Center(
      child: MaterialApp(
        home: AAA(),
      ),
    );
  }
}

class AAA extends StatefulWidget {
  const AAA({Key? key}) : super(key: key);

  @override
  _AAAState createState() => _AAAState();
}

class _AAAState extends State<AAA> {
  int value = 1000;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      value += 1;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(context, BBB());
      },
      child: Text('point1 $value'),
    );
  }
}

class BBB extends SbSheetRoute<int> {
  @override
  void bodyDataException(Object? exception, StackTrace? stackTrace) {
    print('-------------------------$bodyDataException');
  }

  @override
  Future<void> bodyDataFuture(List<int> bodyData, Mark mark) async {}

  @override
  Widget bodySliver() {
    return const SliverToBoxAdapter(
      child: Text('bodySliver'),
    );
  }

  @override
  Widget failureWidget() {
    return const Text('failureWidget');
  }

  @override
  Widget headerSliver() {
    return const SliverToBoxAdapter(
      child: Text('headerSliver'),
    );
  }

  @override
  Widget loadingWidget() {
    return const Text('loadingWidget');
  }

  @override
  Widget noMoreWidget() {
    return const Text('noMoreWidget');
  }

  @override
  void popMethod() {}
}

// ========================

@pragma('vm:entry-point')
void point2() {
  runApp(const Point2());
}

class Point2 extends StatefulWidget {
  const Point2({Key? key}) : super(key: key);

  @override
  _Point2State createState() => _Point2State();
}

class _Point2State extends State<Point2> {
  int value = 2000;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      value += 1;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Point2 build');
    // return MaterialApp(
    //   home: Scaffold(
    //     body: Container(
    //       color: Colors.amberAccent,
    //       child: Center(
    //         child: TextButton(onPressed: () {}, child: Text('point2 $value')),
    //       ),
    //     ),
    //   ),
    // );
    return Center(
      child:  Text('point2',textDirection: TextDirection.ltr,),
    );
  }
}

// ========================

@pragma('vm:entry-point')
void point3() {
  runApp(const Point3());
}

class Point3 extends StatefulWidget {
  const Point3({Key? key}) : super(key: key);

  @override
  _Point3State createState() => _Point3State();
}

class _Point3State extends State<Point3> {
  int value = 3000;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      value += 1;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Point3 build');
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.amberAccent,
          child: Center(
            child: TextButton(onPressed: () {}, child: Text('point3 $value')),
          ),
        ),
      ),
    );
  }
}
