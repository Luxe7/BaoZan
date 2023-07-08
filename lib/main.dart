import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/index.dart';
import 'package:wechat/pages/moments.dart';

SharedPreferences? prefs;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化SharedPreferences
  SharedPreferences.getInstance().then((SharedPreferences? value) {
    prefs = value;
  });
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
        primarySwatch: Colors.green,
        // 扩大圆角
        filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        )),
        scaffoldBackgroundColor: const Color(0xffffffff),
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
        primarySwatch: Colors.green,
        // 扩大圆角
        filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.green.shade200;
            }
            return Colors.green;
          }),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        )),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff191919),
        colorScheme: const ColorScheme.dark(
          background: Color(0xff191919),
          surface: Color(0xff191919),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff222222),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        splashColor: Colors.white30,
      ),
      home: const MomentsPage(),
    );
  }
}
