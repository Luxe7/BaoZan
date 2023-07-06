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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffeeeeee),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      //home: const TimeLinePage(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff191919),
        colorScheme: const ColorScheme.dark(
          background: Color(0xff191919),
          surface: Color(0xff191919),
        ),
        splashColor: Colors.white30,
      ),
      home: const MomentsPage(),
    );
  }
}
