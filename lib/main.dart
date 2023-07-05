import 'package:flutter/material.dart';

import 'pages/index.dart';
import 'package:wechat/pages/moments.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '朋友圈模拟器',
      theme: ThemeData(
        useMaterial3: true,
      ),
      //home: const TimeLinePage(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MomentsPage(),
    );
  }
}
