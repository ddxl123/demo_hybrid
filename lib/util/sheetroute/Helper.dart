import 'package:flutter/material.dart';

class StatefulInitBuilder<T> extends StatefulWidget {
  const StatefulInitBuilder({required this.initValue, required this.init, required this.builder, this.dispose, Key? key}) : super(key: key);

  final T initValue;
  final void Function(StatefulInitBuilderState<T> state) init;
  final Widget Function(StatefulInitBuilderState<T> state) builder;
  final void Function(StatefulInitBuilderState<T> state)? dispose;

  @override
  StatefulInitBuilderState<T> createState() => StatefulInitBuilderState<T>();
}

class StatefulInitBuilderState<T> extends State<StatefulInitBuilder<T>> {
  late T value;

  @override
  void initState() {
    super.initState();
    value = widget.initValue;
    widget.init(this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }

  @override
  void dispose() {
    widget.dispose?.call(this);
    super.dispose();
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
