import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteTool.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBox.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBoxController.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBoxWidget.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';
import 'package:hybrid/util/sbroute/SbPopResult.dart';
import 'package:hybrid/util/sbroute/SbRoute.dart';

/// TODO: 需要实现 N 条 N 条获取数据
class TableDataRoute extends SbRoute {
  TableDataRoute({required this.currentTableName});

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  double get backgroundOpacity => 0;

  String currentTableName;

  final SbFreeBoxController _sbFreeBoxController = SbFreeBoxController();

  @override
  List<Widget> body() {
    final double width = MediaQueryData.fromWindow(window).size.width * 2 / 3;
    final double height = MediaQueryData.fromWindow(window).size.height * 2 / 3;
    return <Positioned>[
      Positioned(
        child: Center(
          child: SbRoundedBox(
            width: width,
            height: height,
            isScrollable: false,
            children: <Widget>[
              SbFreeBox(
                boxSize: Size(width, height),
                sbFreeBoxController: _sbFreeBoxController,
                freeMoveScaleLayerWidgets: SbFreeBoxStack(
                  builder: (BuildContext context, void Function(void Function()) bSetState) {
                    return <SbFreeBoxPositioned>[
                      SbFreeBoxPositioned(
                        easyPosition: Offset.zero,
                        child: TableForTableData(tableName: currentTableName),
                      ),
                    ];
                  },
                ),
                fixedLayerWidgets: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(color: Colors.blue, child: Text(currentTableName)),
                    ),
                  ],
                ),
              ),
            ],
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
      code: null,
      viewMessage: null,
      data: null,
      description: null,
      exception: exception,
      stackTrace: stackTrace,
    );
    return false;
  }
}

/// 对应表数据的表格
class TableForTableData extends StatefulWidget {
  const TableForTableData({required this.tableName});

  final String tableName;

  @override
  _TableForTableDataState createState() => _TableForTableDataState();
}

class _TableForTableDataState extends State<TableForTableData> {
  ///

  /// 表头数据
  List<String> header = <String>[];

  /// 表体数据
  List<ModelBase> body = <ModelBase>[];

  late final Future<void> _future = Future<void>(
    () async {
      header.addAll(await SqliteTool().getAllFieldBy(widget.tableName));
      final SingleResult<List<ModelBase>> queryResult =
          await DataTransferManager.instance.executeSqliteCurd.queryRowsAsModels(QueryWrapper(tableName: widget.tableName));
      await queryResult.handle<void>(
        onSuccess: (List<ModelBase> successResult) async {
          body.addAll(successResult);
        },
        onError: (Object? exception, StackTrace? stackTrace) async {
          SbLogger(
            code: null,
            viewMessage: '获取失败！',
            data: null,
            description: null,
            exception: queryResult.exception,
            stackTrace: queryResult.stackTrace,
          );
        },
      );
    },
  );

  Widget _builder(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      SbLogger(
        code: null,
        viewMessage: null,
        data: null,
        description: null,
        exception: snapshot.error,
        stackTrace: snapshot.stackTrace,
      );
      return const Text('err');
    }
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        return const Text('正在获取中...');
      case ConnectionState.done:
        return _table();
      default:
        return Text('unknown：${snapshot.connectionState}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future,
      builder: _builder,
    );
  }

  Table _table() {
    return Table(
      border: TableBorder.all(),
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            for (int i = 0; i < header.length; i++)
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  header[i],
                  style: const TextStyle(color: Colors.cyanAccent),
                ),
              ),
          ],
        ),
        for (int x = 0; x < body.length; x++)
          TableRow(
            children: <Widget>[
              for (int y = 0; y < body[x].getRowJson.values.length; y++)
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(
                      body[x].getRowJson.values.elementAt(y).toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
