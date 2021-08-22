import 'package:flutter/material.dart';
import 'package:hybrid/mainentry/datacenter/DataCenterEntry.dart';
import 'package:hybrid/mainentry/main/MainEntry.dart';

late String entryName;

void main() {
  entryName = 'MainEntry';
  runApp(MainEntry());
}

@pragma('vm:entry-point')
// ignore: non_constant_identifier_names
void data_center() {
  entryName = 'DataCenterEntry';
  runApp(DataCenterEntry());
}
