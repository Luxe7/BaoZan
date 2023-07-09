import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/utils/index.dart';

import '../models/moment.dart';
import 'image_picture.dart';

class MomentWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var actionMap = {
      '点赞': onLike,
      '评论': onComment,
      '详情': onDetail,
      '删除': onDelete,
    };

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
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: ImagePicture(
                  url: moment.user?.avatar ?? '',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              // 名称
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moment.user?.name ?? '',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color(0xff596b91)
                            : const Color(0xff808fa5),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // 判断moment.content是否为空字符串
                    const SizedBox(height: 5),
                    if (moment.content?.isNotEmpty ?? false) ...[
                      // 内容
                      Text(
                        moment.content ?? '',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                    ],
                    // 图片
                    if ((moment.pictures?.length ?? 0) > 1)
                      Padding(
                        padding: const EdgeInsets.only(right: 48),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          // 不允许滑动
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => ImagePicture(
                            url: moment.pictures![index],
                            fit: BoxFit.cover,
                          ),
                          itemCount: moment.pictures?.length ?? 0,
                          gridDelegate: () {
                            // 2列
                            switch (moment.pictures?.length ?? 0) {
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
                    if ((moment.pictures?.length ?? 0) == 1)
                      Padding(
                        padding: const EdgeInsets.only(right: 48),
                        child: ImagePicture(
                          url: moment.pictures![0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (moment.essay != null)
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
                              url: moment.essay?.cover ?? '',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                moment.essay?.title ?? '',
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
                            actionMap[value]?.call(moment);
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
                          if (moment.favorates?.isNotEmpty ?? false) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? const Color(0xff596b91)
                                      : const Color(0xff808fa5),
                                  fontSize: 14,
                                ),
                                child: Wrap(
                                  children: moment.favorates?.map((e) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (moment.favorates?.indexOf(e) ==
                                                0) ...[
                                              Icon(
                                                CupertinoIcons.heart,
                                                size: 14,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? const Color(0xff596b91)
                                                    : const Color(0xff808fa5),
                                              ),
                                              const SizedBox(width: 5),
                                            ],
                                            Text(
                                              (e.name ?? '') +
                                                  ((moment.favorates
                                                              ?.indexOf(e) !=
                                                          (moment.favorates
                                                                      ?.length ??
                                                                  0) -
                                                              1)
                                                      ? '，'
                                                      : ''),
                                              // 粗体
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ],
                          if (moment.comments?.isNotEmpty ?? false) ...[
                            // 线条
                            Container(
                              height: 0.5,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
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
                                children: moment.comments?.map((e) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2),
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: e.user?.name ?? '',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                              .brightness ==
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
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
