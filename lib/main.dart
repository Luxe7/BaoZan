import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';
import 'pages/index.dart';
import 'package:wechat/pages/moments.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';

SharedPreferences? prefs;

User myself = User(
  id: '1',
  name: '小明',
  avatar: 'https://picsum.photos/250?image=9',
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 全局使用BouncingScrollPhysics的方法是，将ScrollConfiguration包裹在MaterialApp外面，然后设置BouncingScrollPhysics
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '爆赞',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
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
          toolbarHeight: 48,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      darkTheme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
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
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        splashColor: Colors.white30,
      ),
      home: StartPage(),
      // const ScrollConfiguration(
      //   behavior: BouncingScrollBehavior(),
      //   //child: MomentsPage(),

      // ),
    );
  }
}

class BouncingScrollBehavior extends ScrollBehavior {
  const BouncingScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();
}
