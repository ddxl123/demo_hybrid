import 'package:flutter/material.dart';

import 'DartTest.dart';

class FlutterTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AAA(),
        ),
      ),
    );
  }
}

int i = 0;

class AAA extends StatefulWidget {
  @override
  _AAAState createState() => _AAAState();
}

class _AAAState extends State<AAA> {
  @override
  Widget build(BuildContext context) {
    if (i == 3 || i == 4) {
      return Column(
        children: <Widget>[
          BBB(),
          TextButton(
            child: const Text('change'),
            onPressed: () {
              i++;
              setState(() {});
            },
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          CCC(),
          TextButton(
            child: const Text('change'),
            onPressed: () {
              i++;
              setState(() {});
            },
          ),
        ],
      );
    }
  }
}

class BBB extends StatefulWidget {
  @override
  _BBBState createState() => _BBBState();
}

class _BBBState extends State<BBB> {
  @override
  void initState() {
    super.initState();
    print('BBB init');
  }

  @override
  Widget build(BuildContext context) {
    print('BBB build');
    return Container(
      child: const Text('BBB'),
    );
  }
}

class CCC extends StatefulWidget {
  @override
  _CCCState createState() => _CCCState();
}

class _CCCState extends State<CCC> {
  @override
  void initState() {
    super.initState();
    print('CCC init');
  }

  @override
  Widget build(BuildContext context) {
    print('CCC build');
    return Container(
      child: const Text('CCC'),
    );
  }
}
