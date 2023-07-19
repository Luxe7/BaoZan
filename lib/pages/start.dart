import 'package:flutter/material.dart';
import 'package:wechat/pages/index.dart';
import 'package:wechat/utils/index.dart';
import 'index.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('爆赞：你的朋友圈集赞助手'),
          actions: [
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeveloperInfoPage()),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                '''Before you do anything，ask yourself：\n
                Is It Worth The Time？\n
                ''',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              InkResponse(
                child: Column(
                  children: [
                    Image.asset('images/bottomsheet_icon_moment.png'),
                    const Text(
                      '进入朋友圈',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MomentsPage()),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Document()),
                  );
                },
                child: Text('使用说明'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
