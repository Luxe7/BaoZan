import 'package:flutter/cupertino.dart';

class MenuItemModel {
  MenuItemModel({this.icon, this.onTap, this.right, this.title});
  //图标
  final IconData? icon;
  //标题
  final String? title;
  //右侧文字
  final String? right;
  //点击事件
  final Function()? onTap;
}
