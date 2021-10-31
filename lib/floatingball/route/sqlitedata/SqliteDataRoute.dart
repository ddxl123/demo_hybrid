import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteTool.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';
import 'package:hybrid/util/sbroute/SbPopResult.dart';
import 'package:hybrid/util/sbroute/SbRoute.dart';

import 'TableDataRoute.dart';

class SqliteDataRoute extends SbRoute {
  @override
  Color get backgroundColor => Colors.pink;

  @override
  // TODO: implement backgroundOpacity
  double get backgroundOpacity => 0;

  late final Future<List<String>> _future = Future<List<String>>(() async {
    return await SqliteTool().getAllTableNames();
  });

  Widget _builder(BuildContext context, AsyncSnapshot<List<String>> snapshot) {
    Widget sbRoundedBox({required List<Widget> children}) {
      return SbRoundedBox(
        width: MediaQueryData.fromWindow(window).size.width * 2 / 3,
        height: MediaQueryData.fromWindow(window).size.height * 2 / 3,
        children: children,
      );
    }

    if (!snapshot.hasData || snapshot.hasError) {
      SbLogger(
        c: -1,
        vm: null,
        data: null,
        descp: null,
        e: snapshot.error,
        st: snapshot.stackTrace,
      ).withRecord().withToast(true);
      return sbRoundedBox(
        children: const <Widget>[
          Text('获取失败'),
        ],
      );
    }
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        return sbRoundedBox(
          children: const <Widget>[
            Text('正在获取中...'),
          ],
        );
      case ConnectionState.done:
        return sbRoundedBox(
          children: <Widget>[
            for (int i = 0; i < snapshot.data!.length; i++)
              //
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: Text(snapshot.data![i]),
                      onPressed: () {
                        Navigator.push(context, TableDataRoute(currentTableName: snapshot.data![i]));
                      },
                    ),
                  ),
                ],
              ),
          ],
        );
      default:
        return sbRoundedBox(
          children: const <Widget>[
            Text('unknown snapshot'),
          ],
        );
    }
  }

  @override
  List<Widget> body() {
    return <Positioned>[
      Positioned(
        child: Center(
          child: FutureBuilder<List<String>>(
            initialData: const <String>[],
            future: _future,
            builder: _builder,
          ),
        ),
      ),
    ];
  }

  @override
  Future<bool> whenPop(SbPopResult? popResult) async {
    return await quickWhenPop(popResult, (SbPopResult quickPopResult) async => false);
  }

  @override
  bool whenException(Object? exception, StackTrace? stackTrace) {
    SbLogger(
      c: null,
      vm: null,
      data: null,
      descp: null,
      e: exception,
      st: stackTrace,
    );
    return false;
  }
}
