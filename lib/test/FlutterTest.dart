import 'package:flutter/material.dart';

class FlutterTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AAA(),
      ),
    );
  }
}

class AAA extends StatefulWidget {
  @override
  _AAAState createState() => _AAAState();
}

class _AAAState extends State<AAA> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          select(),
          TextButton(
            onPressed: () {
              b = !b;
              setState(() {});
            },
            child: Text('aaa'),
          ),
          TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text('aaa'),
          ),
        ],
      ),
    );
  }

  Widget select() {
    if (b) {
      return BBB();
    } else {
      return CCC();
    }
  }
}

bool b = true;

class BBB extends StatefulWidget {
  const BBB({Key? key}) : super(key: key);

  @override
  _BBBState createState() => _BBBState();
}

class _BBBState extends State<BBB> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('bbb init');
  }

  @override
  Widget build(BuildContext context) {
    print('bbb build');
    return Container();
  }
}

class CCC extends StatefulWidget {
  const CCC({Key? key}) : super(key: key);

  @override
  _CCCState createState() => _CCCState();
}

class _CCCState extends State<CCC> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('ccc init');
  }

  @override
  Widget build(BuildContext context) {
    print('ccc build');
    return Container();
  }
}
