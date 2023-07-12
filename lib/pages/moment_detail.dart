import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/models/moment.dart';
import 'package:wechat/widgets/moment.dart';

import '../wechat_icons_icons.dart';

class MomentDetailPage extends StatefulWidget {
  const MomentDetailPage({super.key, required this.moment});
  final Moment moment;
  @override
  State<MomentDetailPage> createState() => _MomentDetailPageState();
}

class _MomentDetailPageState extends State<MomentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: const EdgeInsets.only(left: 8, right: 24),
          onPressed: () {
            Navigator.maybePop(context);
          },
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          icon: const Icon(
            WechatIcons.back,
            size: 18,
          ),
        ),
        title: const Text(
          '详情',
          // 加粗
          // style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: MomentWidget(
          moment: widget.moment,
          isDetail: true,
        ),
      ),
    );
  }
}
