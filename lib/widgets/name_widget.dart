import 'package:flutter/material.dart';
import 'package:wechat/models/user.dart';

import '../pages/moments.dart';

class NameWidget extends StatefulWidget {
  const NameWidget(
      {super.key, required this.child, required this.user, this.onChange});
  final User? user;
  final Widget child;
  final Function(String?)? onChange;
  @override
  State<NameWidget> createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 修改名字
        TextEditingController nameController = TextEditingController();
        nameController.text = widget.user?.name ?? '';
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('修改名字'),
            content: TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '请输入新的名字',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  // 修改名字
                  setState(() {
                    widget.user?.name = nameController.text;
                    saveData();
                    widget.onChange?.call(widget.user?.name);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('确定'),
              ),
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}
