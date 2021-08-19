
import 'package:flutter/material.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/util/sbroute/SbRoute.dart';
import 'package:hybrid/util/sheetroute/SbSheetRoute.dart';

abstract class AbstractPoolEntryWidget extends StatelessWidget {
  const AbstractPoolEntryWidget(this.poolNodeModel);

  final PoolNodeModel poolNodeModel;
}

abstract class AbstractPoolEntryRoute extends SbRoute {
  AbstractPoolEntryRoute(this.poolNodeModel);

  final PoolNodeModel poolNodeModel;
}

abstract class AbstractPoolEntrySheetRoute<D> extends SbSheetRoute<D> {
  AbstractPoolEntrySheetRoute(this.poolNodeModel);

  final PoolNodeModel poolNodeModel;
}
