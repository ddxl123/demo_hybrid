import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';

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
void demo() {
  runApp(const Cell());
}

class Cell extends StatefulWidget {
  const Cell({Key? key}) : super(key: key);

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  int value = 0;

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
    print('cell build');
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.amberAccent,
          child: Center(
            child: TextButton(onPressed: () {}, child: Text(value.toString())),
          ),
        ),
      ),
    );
  }
}
