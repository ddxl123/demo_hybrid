import 'package:flutter/material.dart';
import 'package:hybrid/mainentry/data/DataChannel.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'AppInitPage.dart';

class DataCenterEntry extends StatefulWidget {
  @override
  _DataCenterEntryState createState() => _DataCenterEntryState();
}

class _DataCenterEntryState extends State<DataCenterEntry> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppInitPage(builder: () => Container()),
    );
  }
}
