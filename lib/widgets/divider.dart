import 'package:flutter/material.dart';

///分割条
class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1.5,
      color: Colors.grey.withOpacity(0.1),
    );
  }
}
