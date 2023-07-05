import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wechat/utils/Picker.dart';
import 'package:wechat/utils/config.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostEditPage extends StatefulWidget {
  const PostEditPage({Key? key, this.selectedAssets}) : super(key: key);
  final List<AssetEntity>? selectedAssets;
  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  //已选中图片列表
  List<AssetEntity> selectedAssets = [];

  //是否开始拖拽
  bool isDragNow = false;

  //是否将要删除
  bool isWillRemove = false;

  //是否将要排序
  bool isWillOrder = false;

  //被拖拽到的ID
  String targetAssetId = "";

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
              for (final asset in selectedAssets) _buildPhotoitem(asset, width),
              //选择图片按钮
              if (selectedAssets.length < maxAssets)
                _buildAddBtn(context, width)
            ],
          );
        },
      ),
    );
  }

//添加按钮
  GestureDetector _buildAddBtn(BuildContext context, double width) {
    return GestureDetector(
      onTap: () async {
        var result = await DuPicker.assets(context: context);
        if (result == null) {
          return;
        }
        setState(() {
          selectedAssets = result;
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
          isDragNow = true;
        });
      },

      onDragEnd: (details) {
        setState(() {
          isDragNow = false;
          isWillOrder = false;
        });
      },
//当被放置并且被Drag Target接受时调用
      onDragCompleted: () {},

      onDraggableCanceled: (velocity, offset) {
        setState(() {
          isDragNow = false;
          isWillOrder = false;
        });
      },
      //拖动进行时显示在指针下方的小部件
      feedback: Container(
        clipBehavior: Clip.antiAlias,
        padding: (isWillOrder && targetAssetId == asset.id)
            ? EdgeInsets.zero
            : EdgeInsets.all(imagePadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: (isWillOrder && targetAssetId == asset.id)
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
            isWillOrder = true;
            targetAssetId = asset.id;
          });
          return true;
        },
        onAccept: (data) {
          //队列中删除拖拽对象
          final int index = selectedAssets.indexOf(data);
          selectedAssets.removeAt(index);
          //将拖拽对象插入到目标对象之前
          final int targetIndex = selectedAssets.indexOf(asset);
          selectedAssets.insert(targetIndex, data);
          setState(() {
            isWillOrder = false;
            targetAssetId = "";
          });
        },
        onLeave: (data) {
          setState(() {
            isWillOrder = false;
            targetAssetId = "";
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
            color: isWillRemove ? Colors.red[300] : Colors.red[200],
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //图标
              Icon(
                Icons.delete,
                size: 32,
                color: isWillRemove ? Colors.white : Colors.white70,
              ),
              //文字
              Text(
                "拖拽到这里删除",
                style: TextStyle(
                    color: isWillRemove ? Colors.white : Colors.white70),
              )
            ]),
          ),
        );
      },

      //将要被接受
      onWillAccept: (data) {
        setState(() {
          isWillRemove = true;
        });
        return true;
      },

      onAccept: (data) {
        setState(() {
          selectedAssets.remove(data);
          isWillRemove = false;
        });
      },

      onLeave: (data) {
        setState(() {
          isWillRemove = false;
        });
      },
    );
  }

//主视图
  Widget _mainView() {
    return Column(
      children: [
        //图片列表
        _buildPhotosList(),
        // const Spacer(),
        // isDragNow ? _buildRemoveBar() : SizedBox.shrink(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("发布"),
      ),
      body: _mainView(),
      bottomSheet: isDragNow ? _buildRemoveBar() : null,
    );
  }
}
