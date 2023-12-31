import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat/main.dart';
import 'package:wechat/models/favorates.dart';
import 'package:wechat/models/moment.dart';
import 'package:wechat/models/user.dart';
import 'package:wechat/pages/index.dart';
import 'package:wechat/pages/post.dart';
import 'package:wechat/utils/index.dart';
import 'package:wechat/wechat_icons_icons.dart';
import 'package:wechat/widgets/avatar_widget.dart';
import 'package:wechat/widgets/image_picture.dart';
import 'package:wechat/widgets/name_widget.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../utils/essay_analyser.dart';

import '../widgets/moment.dart';
import 'moment_detail.dart';

const _expandedHeight = 360.0;
List<Moment> moments = [];

// 保存数据
void saveData() {
  print(Moment.encode(moments));
  prefs?.setStringList('moments', Moment.encode(moments));
// 保存myself
  prefs?.setString('myself', jsonEncode(myself.toJson()));
}

// 读取数据
void readData() {
  final data = prefs?.getStringList('moments');
  if (data != null) {
    moments = Moment.decode(data);
  }
  final self = prefs?.getString('myself');
  if (self != null) {
    myself = User.fromJson(jsonDecode(self));
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
          bool prevIsTop = isTop;
          if (notification.metrics.pixels <
              _expandedHeight - MediaQuery.of(context).padding.top) {
            // 滑动到顶部
            isTop = true;
          } else {
            isTop = false;
          }
          if (prevIsTop != isTop) {
            if (mounted) {
              setState(() {});
            }
          }
          return false;
        },
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverAppBar(
              toolbarHeight: Platform.isAndroid ? 40 : 48,
              systemOverlayStyle: (isLightForeground)
                  ? const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                      statusBarBrightness: Brightness.dark,
                    )
                  : const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                    ),
              // 顶部标题
              title: Text(
                isTop ? '' : '朋友圈',
                style: Platform.isAndroid
                    ? TextStyle(
                        fontSize: 17,
                        color: isLightForeground ? Colors.white : Colors.black,
                      )
                    : TextStyle(
                        fontSize: 18,
                        color: isLightForeground ? Colors.white : Colors.black,
                        // 加粗
                        fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              // 左边返回
              leading: IconButton(
                padding: const EdgeInsets.only(left: 8, right: 24),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: isLightForeground ? Colors.white : Colors.black,
                icon: const Icon(
                  WechatIcons.back,
                  size: 18,
                ),
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
                    padding: const EdgeInsets.only(left: 24, right: 14.0),
                    child: Icon(
                      isTop
                          ? WechatIcons.filled_camera
                          : WechatIcons.outlined_camera,
                      color: isLightForeground ? Colors.white : Colors.black,
                      size: 24,
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
                        bottom: 20,
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(color: const Color(0xff222222))),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () {
                          DuPicker.assets(context: context).then((list) {
                            if (list?.isEmpty ?? true) {
                              return;
                            }
                            Uint8List? byteData = list?[0];
                            if (byteData != null) {
                              // 转换为base64
                              List<int> imageData =
                                  byteData.buffer.asUint8List();
                              String base64Image =
                                  'data:image/png;base64,${base64Encode(imageData)}';

                              // 更新背景
                              setState(() {
                                myself.background = base64Image;
                                saveData();
                              });
                            }
                          });
                        },
                        child: ImagePicture(
                          url: myself.background ?? 'images/moments.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // 上下渐变
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00000000),
                              Color(0x44000000),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 头像左边的名字
                    Positioned(
                      bottom: 30,
                      right: 88,
                      child: NameWidget(
                        user: myself,
                        onChange: (p0) => setState(() {}),
                        child: Text(
                          myself.name ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // 嵌入一个头像在底部
                    Positioned(
                      bottom: 0,
                      right: 12,
                      child: AvatarWidget(
                        user: myself,
                        size: 64,
                        radius: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 留32的空间
            SliverToBoxAdapter(
              child: Container(
                height: 32,
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
                      if (mounted) {
                        try {
                          setState(() {
                            // 在这里进行状态更新
                          });
                        } catch (error) {
                          print(
                              'Error occurred while calling setState: $error');
                        }

                        // setState(() {});
                        // 保存
                        saveData();
                      }
                    },
                    onLike: (moment) {
                      DuPicker.selectNumber(context,
                              title: '目标赞数', min: 0, max: 400, value: 0)
                          .then((value) {
                        moment.favorates = Favorates(value).getList();
                        setState(() {});
                        // 保存
                        saveData();
                      });
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
