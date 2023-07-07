import 'package:wechat/models/user.dart';

class Moment {
  String? id;

  String? content;
  List<String>? pictures;
  User? user;

  Moment({
    this.id,
    this.content,
    this.pictures,
    this.user,
  });

  Moment.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];

    content = json?['content'];
    pictures = json?['pictures'].cast<String>();
    user = json?['user'] != null ? User.fromJson(json?['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    data['content'] = content;
    data['pictures'] = pictures;
    if (user != null) {
      data['user'] = user?.toJson();
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
          )),
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
}
