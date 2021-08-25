import 'dart:async';

import 'package:flutter/material.dart';

import 'AppInitPage.dart';

class DataCenterEntry extends StatefulWidget {
  @override
  _DataCenterEntryState createState() => _DataCenterEntryState();
}

class _DataCenterEntryState extends State<DataCenterEntry> {
  @override
  void initState() {
    super.initState();
    print('DataCenterEntry initState');
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      print('DataCenterEntry');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppInitPage(builder: () => Container()),
    );
  }
}
