import 'package:flutter/material.dart';

import 'AppInitPage.dart';

class DataCenterEntry extends StatefulWidget {
  @override
  _DataCenterEntryState createState() => _DataCenterEntryState();
}

class _DataCenterEntryState extends State<DataCenterEntry> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AppInitPage(
          builder: () => const Text('data_center'),
        ),
      ),
    );
  }
}
