import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';

class MainEntry extends StatefulWidget {
  @override
  _MainEntryState createState() => _MainEntryState();
}

class _MainEntryState extends State<MainEntry> {
  @override
  Widget build(BuildContext context) {
    print('------------- MainEntry Build');
    return SbButtonApp(
      child: GetMaterialApp(
        home: TextButton(
          child: Text("ddd"),
          onPressed: () {
            setState(() {});
          },
        ),
      ),
    );
  }
}
