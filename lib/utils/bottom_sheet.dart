//微信底部弹出
import 'package:flutter/material.dart';
import 'package:wechat/utils/essay_analyser.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '/utils/index.dart';

class DuBottomSheet extends StatelessWidget {
  const DuBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
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
          Btn(
            child: const Text("转发推文"),
            onTap: () {
              Navigator.maybePop(context, 'essay');
            },
          ),
          // 分割线
          Container(
            color: Colors.grey.withOpacity(0.2),
            height: 0.5,
          ),
          //从相册选择照片
          Btn(
              child: const Text("从手机相册选择"),
              onTap: () {
                Navigator.maybePop(context, 'images');
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
    );
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
