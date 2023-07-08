import 'dart:convert';

import 'package:wechat/models/user.dart';

import 'comment.dart';

class Moment {
  String? id;

  String? content;
  List<String>? pictures;
  User? user;
  List<User>? favorates;
  List<Comment>? comments;

  Moment({
    this.id,
    this.content,
    this.pictures,
    this.user,
    this.favorates,
    this.comments,
  });

  Moment.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];

    content = json?['content'];
    pictures = json?['pictures'].cast<String>();
    user = json?['user'] != null ? User.fromJson(json?['user']) : null;
    if (json?['favorates'] != null) {
      favorates = <User>[];
      json?['favorates'].forEach((dynamic v) {
        favorates?.add(User.fromJson(v));
      });
    }
    if (json?['comments'] != null) {
      comments = <Comment>[];
      json?['comments'].forEach((dynamic v) {
        comments?.add(Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    data['content'] = content;
    data['pictures'] = pictures;
    if (user != null) {
      data['user'] = user?.toJson();
    }
    if (favorates != null) {
      data['favorates'] = favorates?.map((v) => v.toJson()).toList();
    }
    if (comments != null) {
      data['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<Moment> mocks() {
    return <Moment>[
      Moment(
          id: '1',
          content: '今天天气真好',
          pictures: <String>[
            'https://picsum.photos/250?image=9',
          ],
          user: User(
            id: '1',
            avatar: 'https://picsum.photos/250?image=9',
            name: '张三',
          ),
          favorates: [
            User(
              id: '1',
              avatar: 'https://picsum.photos/250?image=9',
              name: '张三',
            ),
            User(
              id: '2',
              avatar: 'https://picsum.photos/250?image=21',
              name: '李四',
            ),
            User(
              id: '3',
              avatar: 'https://picsum.photos/250?image=33',
              name: '王五',
            ),
            User(
              id: '4',
              avatar: 'https://picsum.photos/250?image=37',
              name: '赵六',
            ),
          ],
          comments: [
            Comment(
              id: '1',
              user: User(
                id: '1',
                avatar: 'https://picsum.photos/250?image=9',
                name: '张三',
              ),
              content: '今天天气真好',
            ),
            Comment(
              id: '2',
              user: User(
                id: '2',
                avatar: 'https://picsum.photos/250?image=21',
                name: '李四',
              ),
              content: '今天天气真好',
            ),
            Comment(
              id: '3',
              user: User(
                id: '3',
                avatar: 'https://picsum.photos/250?image=33',
                name: '王五',
              ),
              content: '今天天气真好',
            ),
            Comment(
              id: '4',
              user: User(
                id: '4',
                avatar: 'https://picsum.photos/250?image=37',
                name: '赵六',
              ),
              content: '今天天气真好',
            ),
          ]),
      Moment(
          id: '2',
          content: '今天天气真好',
          pictures: <String>[
            'https://picsum.photos/250?image=21',
            'https://picsum.photos/250?image=22',
          ],
          user: User(
            id: '2',
            avatar: 'https://picsum.photos/250?image=21',
            name: '李四',
          )),
      Moment(
          id: '3',
          content: '今天天气真好',
          pictures: <String>[
            'https://picsum.photos/250?image=33',
            'https://picsum.photos/250?image=34',
            'https://picsum.photos/250?image=35',
          ],
          user: User(
            id: '3',
            avatar: 'https://picsum.photos/250?image=33',
            name: '王五',
          )),
      Moment(
          id: '4',
          content: '今天天气真好',
          pictures: <String>[
            'https://picsum.photos/250?image=37',
            'https://picsum.photos/250?image=38',
            'https://picsum.photos/250?image=39',
            'https://picsum.photos/250?image=40',
          ],
          user: User(
            id: '4',
            avatar: 'https://picsum.photos/250?image=37',
            name: '赵六',
          )),
      Moment(
          id: '5',
          content: '今天天气真好',
          pictures: <String>[
            'https://picsum.photos/250?image=41',
            'https://picsum.photos/250?image=42',
            'https://picsum.photos/250?image=43',
            'https://picsum.photos/250?image=44',
            'https://picsum.photos/250?image=45',
          ],
          user: User(
            id: '5',
            avatar: 'https://picsum.photos/250?image=41',
            name: '孙七',
          )),
      Moment(
          id: '6',
          content: '今天天气真好',
          pictures: <String>[
            'https://picsum.photos/250?image=41',
            'https://picsum.photos/250?image=42',
            'https://picsum.photos/250?image=43',
            'https://picsum.photos/250?image=44',
            'https://picsum.photos/250?image=45',
            'https://picsum.photos/250?image=46',
          ],
          user: User(
            id: '6',
            avatar: 'https://picsum.photos/250?image=41',
            name: '周八',
          )),
      Moment(
          id: '7',
          content: '今天天气真好',
          pictures: <String>[
            'https://picsum.photos/250?image=41',
            'https://picsum.photos/250?image=42',
            'https://picsum.photos/250?image=43',
            'https://picsum.photos/250?image=44',
            'https://picsum.photos/250?image=45',
            'https://picsum.photos/250?image=46',
            'https://picsum.photos/250?image=47',
          ],
          user: User(
            id: '7',
            avatar: 'https://picsum.photos/250?image=41',
            name: '吴九',
          )),
      Moment(
          id: '8',
          content: '今天天气真好',
          pictures: <String>[
            'https://picsum.photos/250?image=41',
            'https://picsum.photos/250?image=42',
            'https://picsum.photos/250?image=43',
            'https://picsum.photos/250?image=44',
            'https://picsum.photos/250?image=45',
            'https://picsum.photos/250?image=46',
            'https://picsum.photos/250?image=47',
            'https://picsum.photos/250?image=48',
          ],
          user: User(
            id: '8',
            avatar: 'https://picsum.photos/250?image=41',
            name: '郑十',
          )),
      Moment(
          id: '9',
          content: '今天天气真好',
          pictures: <String>[
            'https://picsum.photos/250?image=41',
            'https://picsum.photos/250?image=42',
            'https://picsum.photos/250?image=43',
            'https://picsum.photos/250?image=44',
            'https://picsum.photos/250?image=45',
            'https://picsum.photos/250?image=46',
            'https://picsum.photos/250?image=47',
            'https://picsum.photos/250?image=48',
            'https://picsum.photos/250?image=49',
          ],
          user: User(
            id: '9',
            avatar: 'https://picsum.photos/250?image=41',
            name: '钱十一',
          )),
    ];
  }

  static List<String> encode(List<Moment> moments) {
    return moments.map((Moment moment) => jsonEncode(moment.toJson())).toList();
  }

  static List<Moment> decode(List<String> jsons) {
    return jsons
        .map((String json) => Moment.fromJson(jsonDecode(json)))
        .toList();
  }
}
