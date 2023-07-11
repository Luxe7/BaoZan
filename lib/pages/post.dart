import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat/main.dart';
import 'package:wechat/models/user.dart';
import 'package:wechat/models/favorates.dart';
import 'package:wechat/widgets/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat/utils/index.dart';

import '../models/moment.dart';

int collectedNumber = 0;

class PostEditPage extends StatefulWidget {
  const PostEditPage({Key? key, this.selectedAssets}) : super(key: key);
  final List<Uint8List>? selectedAssets;
  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  //已选中图片列表
  List<Uint8List> _selectedAssets = [];
  int collectedNumber = 0;

  //内容输入控制器
  final TextEditingController _contentController = TextEditingController();
  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  //内容输入框

  Widget _buildContentInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: pagePadding, vertical: spacing),
      child: LimitedBox(
        maxHeight: 180,
        child: TextField(
          maxLines: null,
          minLines: 3,
          controller: _contentController,
          decoration: const InputDecoration(
            hintText: "这一刻的想法...",
            hintStyle: TextStyle(
              // color: Colors.black26,
              fontSize: 18,
              //fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // //菜单列表
  // List<MenuItemModel> _menus = [];

  //菜单项目
  Widget _buildMenus() {
    // List<Widget> ws = [];
    // ws.add(const DividerWidget());
    // for (var menu in _menus) {
    //   ws.add(ListTile(
    //     leading: Icon(menu.icon),
    //     title: Text(menu.title!),
    //     trailing: Text(menu.right ?? ""),
    //     onTap: menu.onTap,
    //   ));
    //   ws.add(const DividerWidget());
    // }
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          const DividerWidget(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: pagePadding),
            leading: const Icon(Icons.location_on_outlined),
            title: const Text("所在位置"),
            // 向右的箭头
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const DividerWidget(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: pagePadding),
            leading: const Icon(Icons.thumb_up_outlined),
            title: const Text("目标赞数"),
            // 向右的箭头
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 显示目标赞数
                Text(collectedNumber.toString()),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () async {
              var result = await DuPicker.selectNumber(
                context,
                title: "目标赞数",
                min: 0,
                max: 100,
                value: collectedNumber,
              );
              //if (result != null) return;
              collectedNumber = result;
              setState(() {});
            },
          ),
          const DividerWidget(),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: pagePadding),
            leading: const Icon(CupertinoIcons.person_alt),
            title: const Text("谁可以看"),
            // 向右的箭头
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const DividerWidget(),
        ],
      ),
    );
  }

  //是否开始拖拽
  bool _isDragNow = false;

  //是否将要删除
  bool _isWillRemove = false;

  //是否将要排序
  bool _isWillOrder = false;

  //被拖拽到的ID
  String _targetAssetId = "";

  @override
  void initState() {
    super.initState();
    _selectedAssets = widget.selectedAssets ?? [];
    // _menus = [
    //   MenuItemModel(icon: Icons.location_on_outlined, title: "所在位置"),
    //   MenuItemModel(icon: Icons.location_on_outlined, title: "所在位置"),
    //   MenuItemModel(icon: Icons.location_on_outlined, title: "所在位置"),
    // ];
  }

//图片列表
  Widget _buildPhotosList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: pagePadding),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double width =
              (constraints.maxWidth - spacing * 2 - imagePadding * 2 * 3) / 3;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              //图片
              for (final asset in _selectedAssets)
                _buildPhotoitem(asset, width),
              //选择图片按钮
              if (_selectedAssets.length < maxAssets)
                _buildAddBtn(context, width)
            ],
          );
        },
      ),
    );
  }

//添加按钮
  Widget _buildAddBtn(BuildContext context, double width) {
    return GestureDetector(
      onTap: () async {
        var result = await DuPicker.assets(context: context);
        if (result == null) {
          return;
        }
        setState(() {
          _selectedAssets = result;
        });
      },
      child: Container(
        color: Colors.grey.withOpacity(0.05),
        width: width,
        height: width,
        child: const Icon(
          CupertinoIcons.add,
          size: 48,
        ),
      ),
    );
  }

//图片项
  Widget _buildPhotoitem(Uint8List asset, double width) {
    // 随机生成一个ID
    final String id = const Uuid().v1();
    final imageWidget = Image.memory(
      asset,
      width: width,
      height: width,
      fit: BoxFit.cover,
      // isOriginal: false,
    );
    return Draggable<Uint8List>(
      //此可拖动对象将拖放的数据
      data: asset,

      onDragStarted: () {
        setState(() {
          _isDragNow = true;
        });
      },

      onDragEnd: (details) {
        setState(() {
          _isDragNow = false;
          _isWillOrder = false;
        });
      },
//当被放置并且被Drag Target接受时调用
      onDragCompleted: () {},

      onDraggableCanceled: (velocity, offset) {
        setState(() {
          _isDragNow = false;
          _isWillOrder = false;
        });
      },
      //拖动进行时显示在指针下方的小部件
      feedback: Container(
        clipBehavior: Clip.antiAlias,
        padding: (_isWillOrder && _targetAssetId == id)
            ? EdgeInsets.zero
            : const EdgeInsets.all(imagePadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: (_isWillOrder && _targetAssetId == id)
              ? Border.all(
                  color: accentColor,
                  width: imagePadding,
                )
              : null,
        ),
        child: Image.memory(
          asset,
          width: width,
          height: width,
          fit: BoxFit.cover,
          // isOriginal: false,
        ),
      ),
      childWhenDragging: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
        child: imageWidget,
      ),
      //子组件
      child: DragTarget<Uint8List>(
        builder: (context, candidateData, rejectedData) {
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
            child: imageWidget,
          );
        },
        onWillAccept: (data) {
          setState(() {
            _isWillOrder = true;
            _targetAssetId = id;
          });
          return true;
        },
        onAccept: (data) {
          //队列中删除拖拽对象
          final int index = _selectedAssets.indexOf(data);
          _selectedAssets.removeAt(index);
          //将拖拽对象插入到目标对象之前
          final int targetIndex = _selectedAssets.indexOf(asset);
          if (targetIndex == -1) {
            _selectedAssets.add(data);
          } else {
            _selectedAssets.insert(targetIndex, data);
          }
          setState(() {
            _isWillOrder = false;
            _targetAssetId = "";
          });
        },
        onLeave: (data) {
          setState(() {
            _isWillOrder = false;
            _targetAssetId = "";
          });
        },
      ),
    );
  }

//删除 bar
  Widget _buildRemoveBar() {
    return DragTarget<AssetEntity>(
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
          width: double.infinity,
          child: Container(
            height: 100,
            color: _isWillRemove ? Colors.red[300] : Colors.red[200],
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //图标
              Icon(
                Icons.delete,
                size: 32,
                color: _isWillRemove ? Colors.white : Colors.white70,
              ),
              //文字
              Text(
                "拖拽到这里删除",
                style: TextStyle(
                    color: _isWillRemove ? Colors.white : Colors.white70),
              )
            ]),
          ),
        );
      },

      //将要被接受
      onWillAccept: (data) {
        setState(() {
          _isWillRemove = true;
        });
        return true;
      },

      onAccept: (data) {
        setState(() {
          _selectedAssets.remove(data);
          _isWillRemove = false;
        });
      },

      onLeave: (data) {
        setState(() {
          _isWillRemove = false;
        });
      },
    );
  }

//主视图
  Widget _mainView() {
    return ListView(
      children: [
        //内容输入
        _buildContentInput(),

        //图片列表
        _buildPhotosList(),
        // const Spacer(),
        // isDragNow ? _buildRemoveBar() : SizedBox.shrink(),

        //菜单
        _buildMenus(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //左侧取消文字按钮
        leadingWidth: 80,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "取消",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xff2c2c2c),
            ),
          ),
        ),
        //右侧发表按钮
        actions: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: spacing),
            child: SizedBox(
              width: 70,
              height: 36,
              child: FilledButton(
                onPressed: () async {
                  List<String> pictures = [];
                  // 图片转换为base64
                  for (Uint8List byteData in _selectedAssets) {
                    List<int> imageData = byteData.buffer.asUint8List();
                    String base64Image =
                        'data:image/png;base64,${base64Encode(imageData)}';
                    pictures.add(base64Image);
                  }
                  // ignore: use_build_context_synchronously
                  var tempFavorates = Favorates(collectedNumber);
                  Navigator.maybePop(
                      context,
                      Moment(
                          id: '1',
                          content: _contentController.text,
                          pictures: pictures,
                          user: myself,
                          favorates: tempFavorates.getList()));
                },
                child: const Text(
                  "发表",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
      body: _mainView(),
      bottomSheet: _isDragNow ? _buildRemoveBar() : null,
    );
  }
}
