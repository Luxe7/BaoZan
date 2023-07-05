//微信底部弹出
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '/utils/index.dart';
import '/widgets/index.dart';

class DuBottomSheet {
//选择
  DuBottomSheet({this.selectedAssets});
  final List<AssetEntity>? selectedAssets;
  Future<T?> wxPicker<T>(BuildContext context) {
    return DuPicker.showModalSheet<T>(context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //转发推文
            _buildBtn(const Text("转发推文")),
            const DividerWidget(),
            //从相册选择照片
            _buildBtn(
              const Text("从相册选择照片"),
              onTap: () async {
                List<AssetEntity>? result;
                result = await DuPicker.assets(
                    context: context,
                    requestType: RequestType.image,
                    selectedAssets: selectedAssets);
                _popRoute(context, result: result);
              },
            ),
            const DividerWidget(
              height: 6,
            ),
            //取消
            _buildBtn(const Text("取消"), onTap: () {
              _popRoute(context);
            }),
          ],
        ));
  }

  void _popRoute(BuildContext context, {result}) {
    Navigator.pop(context);
    Navigator.pop(context, result);
  }

  InkWell _buildBtn(Widget child, {Function()? onTap}) {
    return InkWell(
      //水波纹效果
      onTap: onTap,
      child: Container(alignment: Alignment.center, height: 40, child: child),
    );
  }
}
