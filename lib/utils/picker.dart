import 'dart:typed_data';

import 'package:flutter/material.dart';
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
    // 如果是Web，使用List<Uint8List>? bytesFromPicker = await ImagePickerWeb.getMultiImagesAsBytes();

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
    List<Uint8List>? result = (await Future.wait(
      assets!.map((e) async {
        return (await e.file)?.readAsBytes();
      }),
    ))
        .whereType<Uint8List>()
        .toList();

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
}
