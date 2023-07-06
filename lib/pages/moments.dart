import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/models/moment.dart';
import 'package:wechat/pages/index.dart';
import 'package:wechat/pages/post.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../utils/bottom_sheet.dart';

const _expandedHeight = 360.0;

class MomentsPage extends StatefulWidget {
  const MomentsPage({super.key});

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  final ScrollController _controller = ScrollController();
  var isTop = true;
  List<Moment> moments = [];
  @override
  void initState() {
    super.initState();
    moments = Moment.mocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 上面是图片，可以伸缩，伸缩之后顶部出现标题，左边返回，右边是一个照相的图标
      // 监听滑动
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          // 判断是否滑动到顶部
          if (notification.metrics.pixels < _expandedHeight) {
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
              // actions: [
              //   IconButton(
              //     onPressed: () {
              //       Navigator.of(context).push(CupertinoPageRoute(
              //         builder: (context) =>
              //             const TimeLinePage(), //PostEditPage(),
              //       ));
              //     },
              //     icon: const Icon(Icons.camera_alt),
              //   ),
              // ],
              actions: [
                IconButton(
                  onPressed: (() {
                    DuBottomSheet()
                        .wxPicker<List<AssetEntity>>(context)
                        .then((result) {
                      if (result == null || result.isEmpty) {
                        return;
                      }
                      //把数据压入发布界面
                      if (mounted) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return PostEditPage(selectedAssets: result);
                        })));
                      }
                    });
                  }),
                  icon: Icon(
                      isTop ? Icons.camera_alt : Icons.camera_alt_outlined),
                ),
              ],
              // 伸缩的高度
              expandedHeight: _expandedHeight,
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

                  var moment = moments[index];
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
                      horizontal: 10,
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

                                const SizedBox(height: 5),
                                // 内容
                                const Text(
                                  '今天天气真好，我想出去玩',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                // 图片
                                if ((moment.pictures?.length ?? 0) > 1)
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight: 300,
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                2),
                                    child: GridView.builder(
                                      // 不允许滑动
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          Image.network(
                                        moment.pictures![index],
                                        fit: BoxFit.cover,
                                      ),
                                      itemCount: moment.pictures?.length ?? 0,
                                      gridDelegate: () {
                                        // 2列
                                        switch (moment.pictures?.length ?? 0) {
                                          case 2:
                                          case 4:
                                            return const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5,
                                            );
                                        }
                                        // 3列
                                        return const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                        );
                                      }(),
                                      shrinkWrap: true,
                                    ),
                                  ),
                                if ((moment.pictures?.length ?? 0) == 1)
                                  Image.network(
                                    moment.pictures![index],
                                    fit: BoxFit.cover,
                                  ),

                                const SizedBox(height: 10),
                                Text(
                                  '1分钟前',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xffb3b3b3)
                                        : const Color(0xff5d5d5d),
                                    fontSize: 14,
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
                childCount: moments.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
