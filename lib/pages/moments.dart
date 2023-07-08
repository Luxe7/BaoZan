import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/models/comment.dart';
import 'package:wechat/models/moment.dart';
import 'package:wechat/pages/index.dart';
import 'package:wechat/pages/post.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../models/user.dart';
import '../utils/bottom_sheet.dart';
import '../widgets/image_picture.dart';

const _expandedHeight = 360.0;
List<Moment> moments = [];

class MomentsPage extends StatefulWidget {
  const MomentsPage({super.key});

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  final ScrollController _controller = ScrollController();
  var isTop = true;

  @override
  void initState() {
    super.initState();
    moments = Moment.mocks();

    // 状态栏透明
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 上面是图片，可以伸缩，伸缩之后顶部出现标题，左边返回，右边是一个照相的图标
      // 监听滑动
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          // 判断是否滑动到顶部
          if (notification.metrics.pixels <
              _expandedHeight - MediaQuery.of(context).padding.top) {
            // 滑动到顶部
            isTop = true;
          } else {
            isTop = false;
          }
          setState(() {});
          return false;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _controller,
          slivers: [
            SliverAppBar(
              toolbarHeight: 48,
              systemOverlayStyle: isTop
                  ? const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                      statusBarBrightness: Brightness.light,
                    )
                  : const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.dark,
                    ),
              // 顶部标题
              title: Text(
                isTop ? '' : '朋友圈',
                style: const TextStyle(
                    fontSize: 18,
                    // 加粗
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              // 左边返回
              leading: IconButton(
                onPressed: () {},
                color: isTop ? Colors.white : Colors.black,
                icon: const Icon(CupertinoIcons.back),
              ),
              // 右边照相
              actions: [
                IconButton(
                  color: isTop ? Colors.white : Colors.black,
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
                            .push(CupertinoPageRoute(builder: ((context) {
                          return PostEditPage(selectedAssets: result);
                        }))).then((value) {
                          moments.add(value);
                          setState(() {});
                        });
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
                collapseMode: CollapseMode.pin,
                background: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned.fill(
                        child: Container(
                            color: Theme.of(context).scaffoldBackgroundColor)),
                    // 灰色背景 #222222
                    Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(color: const Color(0xff222222))),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'images/moments.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // 头像左边的名字
                    const Positioned(
                      bottom: 32,
                      right: 92,
                      child: Text(
                        '张三',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // 嵌入一个头像在底部
                    Positioned(
                      bottom: 0,
                      right: 12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const ImagePicture(
                          url: 'images/avatar.jpg',
                          fit: BoxFit.contain,
                          width: 64,
                          height: 64,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var favorateList = [
                    User(
                      id: '1',
                      name: '张三',
                      avatar: 'images/avatar.jpg',
                    ),
                    User(
                      id: '2',
                      name: '李四',
                      avatar: 'images/avatar.jpg',
                    ),
                  ];
                  var commentsList = [
                    Comment(
                      id: '1',
                      user: User(
                        id: '1',
                        name: '张三',
                        avatar: 'images/avatar.jpg',
                      ),
                      content: '这是一条评论',
                    ),
                    Comment(
                      id: '2',
                      user: User(
                        id: '2',
                        name: '李四',
                        avatar: 'images/avatar.jpg',
                      ),
                      content: '这是一条评论',
                    )
                  ];

                  var moment = moments[moments.length - index - 1];
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
                              borderRadius: BorderRadius.circular(3),
                              child: ImagePicture(
                                url: moment.user?.avatar ?? '',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // 名称
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    moment.user?.name ?? '',
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? const Color(0xff596b91)
                                          : const Color(0xff808fa5),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
// 判断moment.content是否为空字符串
                                  const SizedBox(height: 5),
                                  if (moment.content?.isNotEmpty ?? false) ...[
                                    // 内容
                                    Text(
                                      moment.content ?? '',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                  // 图片
                                  if ((moment.pictures?.length ?? 0) > 1)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 48),
                                      child: GridView.builder(
                                        padding: EdgeInsets.zero,
                                        // 不允许滑动
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            ImagePicture(
                                          url: moment.pictures![index],
                                          fit: BoxFit.cover,
                                        ),
                                        itemCount: moment.pictures?.length ?? 0,
                                        gridDelegate: () {
                                          // 2列
                                          switch (
                                              moment.pictures?.length ?? 0) {
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
                                    Padding(
                                      padding: const EdgeInsets.only(right: 48),
                                      child: ImagePicture(
                                        url: moment.pictures![0],
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                  const SizedBox(height: 10),

                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
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
                                      // 赞和评论的菜单按钮
                                      // 菜单从左侧弹出，底色为#4c4c4c
                                      PopupMenuButton(
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              child: Text(
                                                '赞',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? const Color(0xff596b91)
                                                      : const Color(0xff808fa5),
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: Text(
                                                '评论',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? const Color(0xff596b91)
                                                      : const Color(0xff808fa5),
                                                ),
                                              ),
                                            ),
                                          ];
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? const Color(0xfff7f7f7)
                                                    : const Color(0xff202020),
                                          ),
                                          // 两个点的图形，而不是三个点
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 4,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? const Color(0xff596b91)
                                                      : const Color(0xff808fa5),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Container(
                                                width: 4,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? const Color(0xff596b91)
                                                      : const Color(0xff808fa5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // 点赞列表
                                  Container(
                                    alignment: Alignment.topLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? const Color(0xfff7f7f7)
                                          : const Color(0xff202020),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          child: DefaultTextStyle(
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? const Color(0xff596b91)
                                                  : const Color(0xff808fa5),
                                              fontSize: 14,
                                            ),
                                            child: Wrap(
                                              children: favorateList.map((e) {
                                                return Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    if (favorateList
                                                            .indexOf(e) ==
                                                        0) ...[
                                                      Icon(
                                                        CupertinoIcons.heart,
                                                        size: 14,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.light
                                                            ? const Color(
                                                                0xff596b91)
                                                            : const Color(
                                                                0xff808fa5),
                                                      ),
                                                      const SizedBox(width: 5),
                                                    ],
                                                    Text(
                                                      (e.name ?? '') +
                                                          ((favorateList
                                                                      .indexOf(
                                                                          e) !=
                                                                  favorateList
                                                                          .length -
                                                                      1)
                                                              ? '，'
                                                              : ''),
                                                      // 粗体
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        if (commentsList.isNotEmpty) ...[
                                          // 线条
                                          Container(
                                            height: 0.5,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? const Color(0xffdedede)
                                                  : const Color(0xff2b2b2b),
                                            ),
                                          ),
                                          // 评论列表
                                          // 格式：名称：评论内容
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 0,
                                            ),
                                            child: ListBody(
                                              children: commentsList.map((e) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 2),
                                                  child: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: e.user?.name ??
                                                              '',
                                                          style: TextStyle(
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? const Color(
                                                                    0xff596b91)
                                                                : const Color(
                                                                    0xff808fa5),
                                                            fontSize: 14,
                                                            // 粗体
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const TextSpan(
                                                          text: '：',
                                                        ),
                                                        TextSpan(
                                                          text: e.content,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 10),
                                ],
                              ),
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
