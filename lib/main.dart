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
