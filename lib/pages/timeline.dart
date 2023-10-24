import 'package:flutter/material.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({super.key});

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  Widget _mainView() {
    return Center(
        child: ElevatedButton(
            onPressed: (() async {
              //
            }),
            child: const Text("发布")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _mainView());
  }
}
