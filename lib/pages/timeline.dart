import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/pages/index.dart';
import 'package:wechat/utils/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({super.key});

  @override
  State<TimeLinePage> createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  Widget _mainView() {
    return Center(
        child: ElevatedButton(
            onPressed: (() async {
              DuBottomSheet()
                  .wxPicker<List<AssetEntity>>(context)
                  .then((result) {
                if (result == null || result.isEmpty) {
                  return;
                }
                //把数据压入发布界面
                Navigator.of(context)
                    .push(CupertinoPageRoute(builder: ((context) {
                  return PostEditPage(selectedAssets: result);
                })));
              });
            }),
            child: const Text("发布")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _mainView());
  }
}
