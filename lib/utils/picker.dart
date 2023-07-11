import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'index.dart';

///选取器
class DuPicker {
  ///相册
  static Future<List<Uint8List>?> assets({
    required BuildContext context,
    List<Uint8List>? selectedAssets,
    int maxAssets = maxAssets,
    RequestType requestType = RequestType.image,
  }) async {
    List<Uint8List>? result = [];
    // 如果是Web
    if (kIsWeb) {
      List<XFile>? filesFromPicker = await ImagePicker().pickMultiImage();
      List<Uint8List> bytesFromPicker =
          await Future.wait(filesFromPicker.map((e) => e.readAsBytes()));

      result = bytesFromPicker;
    } else if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      // 如果是移动端，使用List<AssetEntity>? result = await AssetPicker.pickAssets(context);
      List<AssetEntity>? assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          // selectedAssets: selectedAssets,
          requestType: requestType,
          maxAssets: maxAssets,
        ),
      );

      // 通过(await e.file)?.readAsBytes()转换为List<Unit8List>
      if (assets == null) return [];
      result = (await Future.wait(
        assets.map((e) async {
          return (await e.file)?.readAsBytes();
        }),
      ))
          .whereType<Uint8List>()
          .toList();
    }
    return result;
  }

  ///底部弹出视图
  static Future<T?> showModalSheet<T>(BuildContext context, Widget child) {
    const borderRadius = BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10));
    return showModalBottomSheet<T>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: child,
        );
      },
    );
  }

  static Future<int> selectNumber(BuildContext context,
      {required String title,
      required int min,
      required int max,
      required int value}) async {
    int tempCollectedNumber = value;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text("目标赞数"),
          title: Text(title),
          content:
              // 使用CupertinoPicker.builder
              ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: CupertinoPicker.builder(
              // 设置滚动个数
              itemExtent: 40,
              // 设置选中项
              //initialItemCount: 10,
              // 不允许负数出现
              scrollController:
                  FixedExtentScrollController(initialItem: tempCollectedNumber),
              // 设置选中项
              onSelectedItemChanged: (int index) {
                tempCollectedNumber = index;
              },
              // 设置子项构造器
              itemBuilder: (BuildContext context, int index) {
                if (index < 0) return null;
                return Center(
                  child: Text(
                    index.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () {
                Navigator.of(context).maybePop();
                tempCollectedNumber = value;
              },
            ),
            TextButton(
              child: const Text("确定"),
              onPressed: () {
                Navigator.of(context).maybePop(tempCollectedNumber);
              },
            ),
          ],
        );
      },
    );
    return tempCollectedNumber;
  }
}
