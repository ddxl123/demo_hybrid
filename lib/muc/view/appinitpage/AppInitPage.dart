
import 'package:flutter/material.dart';
import 'package:hybrid/data/mysql/http/HttpInit.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteInit.dart';
import 'package:hybrid/floatingball/FloatingballInit.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

enum AppInitStatus { ok, exception, initializing }

class AppInitPage extends StatefulWidget {
  const AppInitPage({required this.builder});

  /// [builder] 如果 使用 Widget 而不使用 Widget Function() 的话，Widget 对象在初始化时就会被创建。
  /// 从而会导致 [HomePage] 会先被初始化后才会进行 [AppInitPage] 初始化。
  final Widget Function() builder;

  @override
  _AppInitPageState createState() => _AppInitPageState();
}

class _AppInitPageState extends State<AppInitPage> {
  ///

  late final Future<AppInitStatus> _future = Future<AppInitStatus>(
    () async {
      HttpInit().init();
      final SqliteInitResult sqliteInitResult = await SqliteInit().init();
      FloatingBallInit().init(context);
      if (sqliteInitResult == SqliteInitResult.ok) {
        return AppInitStatus.ok;
      } else {
        return AppInitStatus.exception;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppInitStatus>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<AppInitStatus> snapshot) {
        if (snapshot.hasError) {
          SbLogger(
            code: -1,
            viewMessage: null,
            data: null,
            description: Description('initAll err'),
            exception: snapshot.error,
            stackTrace: snapshot.stackTrace,
          ).withRecord().withToast(true);
          return const Scaffold(
            body: Center(
              child: Text('应用初始化失败！'),
            ),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Scaffold(
              body: Center(
                child: Text('正在初始化应用中...'),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasData && snapshot.data == AppInitStatus.ok) {
              return widget.builder();
            } else {
              return const Scaffold(
                body: Center(
                  child: Text('应用初始化失败！'),
                ),
              );
            }
          default:
            return const Scaffold(
              body: Center(
                child: Text('应用初始化失败！'),
              ),
            );
        }
      },
    );
  }
}
