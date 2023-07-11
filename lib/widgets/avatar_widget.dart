import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:wechat/models/user.dart';
import 'package:wechat/utils/index.dart';

import 'image_picture.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget(
      {super.key, required this.user, this.size = 32, this.radius = 4});

  final User? user;
  final double size;
  final double radius;

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(widget.radius),
      onTap: () {
        // 设置头像
        // 弹出选择框，选择头像库选择或者从相册选择，头像库选择展示images/avatar/中的所有图片，相册选择使用images_picker
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                children: [
                  // 标题
                  const ListTile(
                    title: Text('设置头像'),
                  ),
                  // 说明
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('头像库'),
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              children: [
                                // 标题
                                const ListTile(
                                  title: Text('选择头像'),
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 8,
                                      crossAxisSpacing: 8,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var path =
                                          '$folderPath/${(index + 1).toString().padLeft(3, '0')}.jpeg';

                                      return InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          // 更新头像
                                          setState(() {
                                            widget.user?.avatar = path;
                                          });
                                        },
                                        child: ImagePicture(
                                          url: path,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                    itemCount: 448,
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('相册'),
                    onTap: () {
                      Navigator.pop(context);
                      DuPicker.assets(context: context).then((list) {
                        if (list == null || list.isEmpty) return;
                        Uint8List byteData = list[0];
                        List<int> imageData = byteData.buffer.asUint8List();
                        String base64Image =
                            'data:image/png;base64,${base64Encode(imageData)}';

                        // 更新头像
                        setState(() {
                          widget.user?.avatar = base64Image;
                        });
                      });
                    },
                  ),
                ],
              );
            });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: ImagePicture(
          url: widget.user?.avatar,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
