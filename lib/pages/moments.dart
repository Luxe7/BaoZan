import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/pages/post.dart';

class MomentsPage extends StatefulWidget {
  const MomentsPage({super.key});

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  final ScrollController _controller = ScrollController();
  var isTop = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 上面是图片，可以伸缩，伸缩之后顶部出现标题，左边返回，右边是一个照相的图标
      // 监听滑动
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          // 判断是否滑动到顶部
          if (notification.metrics.pixels < 200) {
            // 滑动到顶部
            print('滑动到顶部');
            isTop = true;
          } else {
            isTop = false;
          }
          setState(() {});
          return false;
        },
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverAppBar(
              toolbarHeight: 48,
              // 顶部标题
              title: Text(
                isTop ? '' : '朋友圈',
                style: const TextStyle(fontSize: 18),
              ),
              centerTitle: true,
              // 左边返回
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.back),
              ),
              // 右边照相
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const PostEditPage(),
                    ));
                  },
                  icon: const Icon(Icons.camera_alt),
                ),
              ],
              // 伸缩的高度
              expandedHeight: 200,
              stretch: true,
              pinned: true,
              // 伸缩的内容
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                ],
                background: Image.asset(
                  'images/moments.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    height: 100,
                    color: Colors.primaries[index % Colors.primaries.length],
                  );
                },
                childCount: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
