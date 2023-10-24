import 'package:flutter/material.dart';

class Document extends StatelessWidget {
  const Document({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('使用说明'),
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.1), // 设置淡灰色的背景，可以调整透明度
        padding: const EdgeInsets.all(16), // 设置内边距
        child: RichText(
            text: const TextSpan(
          text: "应用中的可自定义内容：\n",
          style: TextStyle(fontSize: 20.0),
          children: <TextSpan>[
            TextSpan(
              text: '''

                  朋友圈背景头部图片：点击更改即可\n
                  用户自己的头像：点击更改即可\n
                  已发表的时间：点击后可选择时间，最大值为360min\n
                  期望得到的赞数：点击后可选择赞数，最大值为449\n''',
              style: TextStyle(fontSize: 15.0),
            )
          ],
        )),
      ),
    );
  }
}
