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
                  var favorateList = ['张三', '李四', '王五', '赵六', '田七'];
                  // 仿造朋友圈的列表
                  return Container(
                    // 分割线
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? const Color(0xffe5e5e5)
                                  : const Color(0xff242424),
                          width: 0.5,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 头像
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'images/avatar.jpg',
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // 名称
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '花开富贵',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xff596b91)
                                        : const Color(0xff808fa5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),
                                // 内容
                                const Text(
                                  '今天天气真好，我想出去玩',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                // 图片
                                Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children: [
                                    Image.asset(
                                      'images/moments.jpg',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Image.asset(
                                      'images/moments.jpg',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Image.asset(
                                      'images/moments.jpg',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '1分钟前',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xffb3b3b3)
                                        : const Color(0xff5d5d5d),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // 点赞列表
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xfff7f7f7)
                                        : const Color(0xff202020),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? const Color(0xff596b91)
                                          : const Color(0xff808fa5),
                                      fontSize: 14,
                                    ),
                                    child: Wrap(
                                      children: favorateList.map((e) {
                                        if (favorateList.indexOf(e) == 0) {
                                          return Row(
                                            children: [
                                              Icon(
                                                CupertinoIcons.heart,
                                                size: 14,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? const Color(0xff596b91)
                                                    : const Color(0xff808fa5),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(e),
                                              const Text('，')
                                            ],
                                          );
                                        } else if (favorateList.indexOf(e) ==
                                            favorateList.length - 1) {
                                          return Text(e);
                                        }
                                        return Row(
                                          children: [Text(e), const Text('，')],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
