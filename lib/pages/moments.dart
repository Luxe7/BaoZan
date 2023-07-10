import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat/main.dart';
import 'package:wechat/models/moment.dart';
import 'package:wechat/pages/index.dart';
import 'package:wechat/pages/post.dart';
import 'package:wechat/utils/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../utils/essay_analyser.dart';
import '../widgets/image_picture.dart';
import '../widgets/moment.dart';
import 'moment_detail.dart';

const _expandedHeight = 360.0;
List<Moment> moments = [];

// 保存数据
void saveData() {
  prefs?.setStringList('moments', Moment.encode(moments));
}

// 读取数据
void readData() {
  final data = prefs?.getStringList('moments');
  if (data != null) {
    moments = Moment.decode(data);
  }
}

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

    // 初始化SharedPreferences
    SharedPreferences.getInstance().then((SharedPreferences? value) {
      prefs = value;
      if (prefs?.getBool('first') ?? true) {
        moments = Moment.mocks();
        // 保存
        saveData();
        prefs?.setBool('first', false);
      } else {
        // 读取
        readData();
        setState(() {});
      }
    });

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
    bool isLightForeground =
        (isTop || Theme.of(context).brightness == Brightness.dark);
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
          controller: _controller,
          slivers: [
            SliverAppBar(
              toolbarHeight: 48,
              systemOverlayStyle: isLightForeground
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
                style: TextStyle(
                    fontSize: 18,
                    color: isLightForeground ? Colors.white : Colors.black,
                    // 加粗
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              // 左边返回
              leading: IconButton(
                onPressed: () {},
                color: isLightForeground ? Colors.white : Colors.black,
                icon: const Icon(CupertinoIcons.back),
              ),
              // 右边照相
              actions: [
                InkResponse(
                  onTap: (() {
                    // 弹出底部菜单
                    DuPicker.showModalSheet(
                      context,
                      const DuBottomSheet(),
                    ).then((value) {
                      if (value == null || value.isEmpty) {
                        return;
                      }
                      switch (value) {
                        case 'essay':
                          // 弹出Dialog输入框
                          TextEditingController link = TextEditingController();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("转发推文"),
                                content: TextField(
                                  controller: link,
                                  decoration: const InputDecoration(
                                    hintText: "链接",
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.url,
                                  autofocus: true,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.maybePop(context);
                                    },
                                    child: const Text("取消"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      EssayAnalyzer.linkToEssay(link.text)
                                          .then((value) {
                                        moments.add(
                                            Moment(user: myself, essay: value));
                                        setState(() {});

                                        // 保存
                                        saveData();
                                        Navigator.maybePop(context);
                                      });
                                    },
                                    child: const Text("发送"),
                                  ),
                                ],
                              );
                            },
                          );
                        case 'images':
                          //把数据压入发布界面
                          List<Uint8List> selectedAssets = [];
                          DuPicker.assets(
                                  context: context,
                                  requestType: RequestType.image,
                                  selectedAssets: selectedAssets)
                              .then((assets) {
                            if (mounted) {
                              Navigator.of(context)
                                  .push(CupertinoPageRoute(builder: ((context) {
                                return PostEditPage(selectedAssets: assets);
                              }))).then((value) {
                                if (value == null) {
                                  // 取消
                                  return;
                                }
                                moments.add(value);
                                setState(() {});

                                // 保存
                                saveData();
                              });
                            }
                          });
                      }
                    });
                  }),
                  onLongPress: () {
                    // 长按进入纯文本（微信本来就是这样）
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: ((context) {
                      return const PostEditPage(selectedAssets: []);
                    }))).then((value) {
                      if (value == null) {
                        // 取消
                        return;
                      }
                      moments.add(value);
                      setState(() {});

                      // 保存
                      saveData();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      isTop ? Icons.camera_alt : Icons.camera_alt_outlined,
                      color: isLightForeground ? Colors.white : Colors.black,
                    ),
                  ),
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
                  var moment = moments[moments.length - index - 1];

                  // 仿造朋友圈的列表
                  return MomentWidget(
                    moment: moment,
                    onDelete: (moment) {
                      moments.remove(moment);
                      setState(() {});
                      // 保存
                      saveData();
                    },
                    onLike: (moment) {
                      setState(() {});
                      // 保存
                      saveData();
                    },
                    onDetail: (moment) {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(builder: ((context) {
                        return MomentDetailPage(moment: moment);
                      })));
                    },
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
