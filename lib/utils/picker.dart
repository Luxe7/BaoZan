import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'index.dart';

///选取器
class DuPicker {
  ///相册
  static Future<List<AssetEntity>?> assets({
    required BuildContext context,
    List<AssetEntity>? selectedAssets,
    int maxAssets = maxAssets,
    RequestType requestType = RequestType.image,
  }) async {
    List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        selectedAssets: selectedAssets,
        requestType: requestType,
        maxAssets: maxAssets,
      ),
    );
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
