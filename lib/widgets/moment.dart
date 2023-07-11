import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/pages/index.dart';

import '../models/moment.dart';
import 'avatar_widget.dart';
import 'image_picture.dart';
import 'name_widget.dart';

class MomentWidget extends StatefulWidget {
  const MomentWidget(
      {super.key,
      required this.moment,
      this.onDelete,
      this.onDetail,
      this.onLike,
      this.onComment,
      this.isDetail = false});

  final Moment moment;
  // 删除事件
  final Function(Moment)? onDelete;
  // 进入详情页的事件
  final Function(Moment)? onDetail;
  // 点赞事件
  final Function(Moment)? onLike;
  // 评论事件
  final Function(Moment)? onComment;
  final bool isDetail;

  @override
  State<MomentWidget> createState() => _MomentWidgetState();
}

class _MomentWidgetState extends State<MomentWidget> {
  @override
  Widget build(BuildContext context) {
    var actionMap = {
      '点赞': widget.onLike,
      '评论': widget.onComment,
      '详情': widget.onDetail,
      '删除': widget.onDelete,
    };

    var container = [
      // 点赞列表
      Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).brightness == Brightness.light
              ? const Color(0xfff7f7f7)
              : const Color(0xff202020),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.moment.favorates?.isNotEmpty ?? false) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xff596b91)
                        : const Color(0xff808fa5),
                    fontSize: 14,
                  ),
                  child: widget.isDetail
                      ?
                      // 使用头像网格，每个头像32，间隔为4，外面套一层Row，左边是爱心右边是头像
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 6, right: 4.0),
                              child: Icon(
                                CupertinoIcons.heart,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? const Color(0xff596b91)
                                    : const Color(0xff808fa5),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: widget.moment.favorates!
                                    .map(
                                      (e) => ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: ImagePicture(
                                          url: e.avatar,
                                          width: 32,
                                          height: 32,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        )
                      : Text.rich(
                          // 优化性能，爱心要嵌入到Text中
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  CupertinoIcons.heart,
                                  size: 16,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? const Color(0xff596b91)
                                      : const Color(0xff808fa5),
                                ),
                              ),
                              ...widget.moment.favorates?.map((e) {
                                    return TextSpan(
                                      text: (e.name ?? '') +
                                          ((widget.moment.favorates
                                                      ?.indexOf(e) !=
                                                  (widget.moment.favorates
                                                              ?.length ??
                                                          0) -
                                                      1)
                                              ? '，'
                                              : ''),
                                      // 粗体
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList() ??
                                  [],
                            ],
                          ),
                        ),
                ),
              ),
            ],
            // 评论列表
            if (widget.moment.comments?.isNotEmpty ?? false) ...[
              // 线条
              Container(
                height: 0.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xffdedede)
                      : const Color(0xff2b2b2b),
                ),
              ),
              // 评论列表
              // 格式：名称：评论内容
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                child: ListBody(
                  children: widget.moment.comments?.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: e.user?.name ?? '',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xff596b91)
                                        : const Color(0xff808fa5),
                                    fontSize: 14,
                                    // 粗体
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: '：',
                                ),
                                TextSpan(
                                  text: e.content,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ]
          ],
        ),
      ),

      const SizedBox(height: 10),
    ];

    return Container(
      // 分割线
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xffe5e5e5)
                : const Color(0xff242424),
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像
              AvatarWidget(
                user: widget.moment.user,
                size: 40,
                radius: 3,
              ),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(3),
              //   child: ImagePicture(
              //     url: moment.user?.avatar ?? '',
              //     width: 40,
              //     height: 40,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              const SizedBox(width: 10),
              // 名称
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NameWidget(
                        user: widget.moment.user,
                        child: Text(
                          widget.moment.user?.name ?? '',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xff596b91)
                                    : const Color(0xff808fa5),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    // 判断moment.content是否为空字符串
                    const SizedBox(height: 5),
                    if (widget.moment.content?.isNotEmpty ?? false) ...[
                      // 内容
                      Text(
                        widget.moment.content ?? '',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                    ],
                    // 图片
                    if ((widget.moment.pictures?.length ?? 0) > 1)
                      Padding(
                        padding: const EdgeInsets.only(right: 48),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          // 不允许滑动
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => ImagePicture(
                            url: widget.moment.pictures![index],
                            fit: BoxFit.cover,
                          ),
                          itemCount: widget.moment.pictures?.length ?? 0,
                          gridDelegate: () {
                            // 2列
                            switch (widget.moment.pictures?.length ?? 0) {
                              case 2:
                              case 4:
                                return const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                );
                            }
                            // 3列
                            return const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            );
                          }(),
                          shrinkWrap: true,
                        ),
                      ),
                    if ((widget.moment.pictures?.length ?? 0) == 1)
                      Padding(
                        padding: const EdgeInsets.only(right: 48),
                        child: ImagePicture(
                          url: widget.moment.pictures![0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (widget.moment.essay != null)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? const Color(0xfff5f5f5)
                                  : const Color(0xff2a2a2a),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 图片
                            ImagePicture(
                              url: widget.moment.essay?.cover ?? '',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.moment.essay?.title ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1分钟前',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xffb3b3b3)
                                    : const Color(0xff5d5d5d),
                            fontSize: 14,
                          ),
                        ),
                        // 赞和评论的菜单按钮
                        // 菜单从左侧弹出，底色为#4c4c4c
                        PopupMenuButton(
                          onSelected: (value) {
                            actionMap[value]?.call(widget.moment);
                          },
                          itemBuilder: (context) {
                            // 使用actionMap
                            var actions = actionMap.keys.toList();
                            List<PopupMenuEntry<String>> items = [];
                            for (var item in actions) {
                              if (actionMap[item] != null) {
                                items.add(
                                  PopupMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ),
                                );
                              }
                            }
                            return items;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? const Color(0xfff7f7f7)
                                  : const Color(0xff202020),
                            ),
                            // 两个点的图形，而不是三个点
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xff596b91)
                                        : const Color(0xff808fa5),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xff596b91)
                                        : const Color(0xff808fa5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (!widget.isDetail) ...container
                  ],
                ),
              ),
            ],
          ),
          if (widget.isDetail) ...container
        ],
      ),
    );
  }
}
