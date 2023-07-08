//微信底部弹出
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '/utils/index.dart';

class DuBottomSheet {
//选择
  DuBottomSheet({this.selectedAssets});
  final List<AssetEntity>? selectedAssets;
  Future<T?> wxPicker<T>(BuildContext context) {
    return DuPicker.showModalSheet<T>(
        context,
        DefaultTextStyle(
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : const Color(0xff2c2c2c),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //转发推文
              const Btn(child: Text("转发推文")),
              Container(
                color: Colors.grey.withOpacity(0.2),
                height: 0.5,
              ),
              //从相册选择照片
              Btn(
                  child: const Text("从手机相册选择"),
                  onTap: () {
                    DuPicker.assets(
                            context: context,
                            requestType: RequestType.image,
                            selectedAssets: selectedAssets)
                        .then((result) {
                      Navigator.maybePop(context, result);
                    });
                  }),
              const SizedBox(height: 5),
              //取消
              Btn(
                child: const SafeArea(child: Text("取消")),
                onTap: () {
                  Navigator.maybePop(context);
                },
              ),
            ],
          ),
        ));
  }
}

class Btn extends StatelessWidget {
  const Btn({super.key, required this.child, this.onTap});

  final Widget child;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 底色
        Positioned.fill(
          child: Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : const Color(0xff2c2c2c),
          ),
        ),
        // 内容
        Container(
          alignment: Alignment.center,
          height: 48,
          child: child,
        ),
        // 波纹
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
