import 'dart:convert';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

Map<int, Uint8List?> base64imageMap = {};

class ImagePicture extends StatelessWidget {
  final double? width, height;
  final String? url;
  final Uint8List? raw;
  final BoxFit fit;

  const ImagePicture(
      {Key? key,
      this.url,
      this.fit = BoxFit.none,
      this.width,
      this.height,
      this.raw})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (url) {
      case 'black':
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
        );
      case 'white':
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        );
    }
    if (raw != null) {
      if (base64imageMap[raw!.length] == null) {
        base64imageMap[raw!.length] = raw;
      }
      return ExtendedImage.memory(
        base64imageMap[raw!.length]!,
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.medium,
      );
    }
    if (url == null || url!.isEmpty) return Container();
    if (url!.contains('data:image') && url!.contains('base64')) {
      if (base64imageMap[url!.length] == null) {
        base64imageMap[url!.length] =
            const Base64Decoder().convert(url!.split(',')[1]);
      }
      return ExtendedImage.memory(
        base64imageMap[url!.length]!,
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.medium,
      );
    }
    late ImageProvider imageProvider;
    if (url!.contains('images/')) {
      imageProvider = AssetImage(url!);
    } else if (url!.contains('http')) {
      return ExtendedImage.network(
        url ?? '',
        width: width,
        height: height,
        fit: fit,
        cache: true,
      );
    }
    return Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
