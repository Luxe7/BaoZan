import 'package:flutter/material.dart';

import '../utils/config.dart';

///分割条
class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: pagePadding),
      height: height ?? 1.5,
      color: Colors.grey.withOpacity(0.1),
    );
  }
}
