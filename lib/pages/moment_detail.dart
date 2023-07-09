import 'package:flutter/material.dart';
import 'package:wechat/models/moment.dart';
import 'package:wechat/widgets/moment.dart';

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
        title: const Text('详情'),
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
