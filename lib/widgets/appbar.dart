import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget(
      {super.key,
      this.backgroundColor,
      this.elevation,
      this.leading,
      this.actions,
      this.title,
      this.centerTitle,
      this.isAnimated,
      this.isShow});

  ///appbar的背景颜色
  final Color? backgroundColor;

  ///appbar的海拔阴影
  final double? elevation;

  /// 在[title]之前的小组件
  final Widget? leading;

  /// 在[title]之后的小组件
  final List<Widget>? actions;

  ///appbar 标题
  final Widget? title;

  ///是否使用动画
  final bool? isAnimated;

  ///是否显示动画
  final bool? isShow;

  final bool? centerTitle;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(30);

  Widget _mainView() {
    return AppBar(
      title: title,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
    );

    // // 如果使用动画，则返回被动画组件嵌套的appbar，并且如果需要显示，则让appbar向下逐渐淡入，否则向上逐渐淡出
    // return isAnimated == true
    //     ? isShow == true
    //         ? FadeInDown(
    //             duration: const Duration(milliseconds: 300), child: appBar)
    //         : FadeOutUp(
    //             duration: const Duration(milliseconds: 300), child: appBar)
    //     : appBar;
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
