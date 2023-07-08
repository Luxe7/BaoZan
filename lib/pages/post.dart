import 'package:flutter/material.dart';
import 'package:wechat/utils/Picker.dart';
import 'package:wechat/utils/config.dart';
import 'package:wechat/widgets/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../entity/index.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({Key? key, this.selectedAssets}) : super(key: key);
  final List<AssetEntity>? selectedAssets;
  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  //已选中图片列表
  List<AssetEntity> _selectedAssets = [];

  //内容输入控制器
  TextEditingController _contentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _contentController.dispose();
    super.dispose();
  }

  //内容输入框

  Widget _buildContentInput() {
    return Padding(
      padding: const EdgeInsets.all(spacing),
      child: LimitedBox(
        maxHeight: 180,
        child: TextField(
          maxLines: null,
          controller: _contentController,
          decoration: const InputDecoration(
            hintText: "这一刻的想法...",
            hintStyle: TextStyle(
              color: Colors.black26,
              fontSize: 18,
              //fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  //菜单列表
  List<MenuItemModel> _menus = [];

  //菜单项目
  Widget _buildMenus() {
    List<Widget> ws = [];
    ws.add(const DividerWidget());
    for (var menu in _menus) {
      ws.add(ListTile(
        leading: Icon(menu.icon),
        title: Text(menu.title!),
        trailing: Text(menu.right ?? ""),
        onTap: menu.onTap,
      ));
      ws.add(const DividerWidget());
    }
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: ws,
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
    // TODO: implement initState
    super.initState();
    _selectedAssets = widget.selectedAssets ?? [];
    _menus = [
      MenuItemModel(icon: Icons.location_on_outlined, title: "所在位置"),
      MenuItemModel(icon: Icons.location_on_outlined, title: "所在位置"),
      MenuItemModel(icon: Icons.location_on_outlined, title: "所在位置"),
    ];
  }

//图片列表
  Widget _buildPhotosList() {
    return Padding(
      padding: const EdgeInsets.all(spacing),
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
        color: Colors.black12,
        width: width,
        height: width,
        child: const Icon(
          Icons.add,
          size: 48,
          color: Colors.black38,
        ),
      ),
    );
  }

//图片项
  Widget _buildPhotoitem(AssetEntity asset, double width) {
    return Draggable<AssetEntity>(
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
        padding: (_isWillOrder && _targetAssetId == asset.id)
            ? EdgeInsets.zero
            : EdgeInsets.all(imagePadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: (_isWillOrder && _targetAssetId == asset.id)
              ? Border.all(
                  color: accentColor,
                  width: imagePadding,
                )
              : null,
        ),
        child: AssetEntityImage(
          asset,
          width: width,
          height: width,
          fit: BoxFit.cover,
          isOriginal: false,
        ),
      ),
      childWhenDragging: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
        child: AssetEntityImage(
          asset,
          width: width,
          height: width,
          fit: BoxFit.cover,
          isOriginal: false,
          opacity: AlwaysStoppedAnimation(0.2),
        ),
      ),
      //子组件
      child: DragTarget<AssetEntity>(
        builder: (context, candidateData, rejectedData) {
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
            child: AssetEntityImage(
              asset,
              width: width,
              height: width,
              fit: BoxFit.cover,
              isOriginal: false,
            ),
          );
        },
        onWillAccept: (data) {
          setState(() {
            _isWillOrder = true;
            _targetAssetId = asset.id;
          });
          return true;
        },
        onAccept: (data) {
          //队列中删除拖拽对象
          final int index = _selectedAssets.indexOf(data);
          _selectedAssets.removeAt(index);
          //将拖拽对象插入到目标对象之前
          final int targetIndex = _selectedAssets.indexOf(asset);
          _selectedAssets.insert(targetIndex, data);
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
    return Padding(
      padding: const EdgeInsets.all(pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("发布"),
      // ),
      appBar: AppBarWidget(
        //左侧返回按钮
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black38,
          ),
        ),
        //右侧发表按钮
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: pagePadding),
            child: ElevatedButton(onPressed: () {}, child: Text("发表")),
          )
        ],
      ),
      body: _mainView(),
      bottomSheet: _isDragNow ? _buildRemoveBar() : null,
    );
  }
}
