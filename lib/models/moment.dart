class Moment {
  String? id;
  String? content;
  List<String>? pictures;

  Moment({
    this.id,
    this.content,
    this.pictures,
  });

  Moment.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    content = json?['content'];
    pictures = json?['pictures'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['pictures'] = pictures;
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
      ),
      Moment(
        id: '2',
        content: '今天天气真好',
        pictures: <String>[
          'https://picsum.photos/250?image=21',
          'https://picsum.photos/250?image=22',
        ],
      ),
      Moment(
        id: '3',
        content: '今天天气真好',
        pictures: <String>[
          'https://picsum.photos/250?image=33',
          'https://picsum.photos/250?image=34',
          'https://picsum.photos/250?image=35',
        ],
      ),
      Moment(
        id: '4',
        content: '今天天气真好',
        pictures: <String>[
          'https://picsum.photos/250?image=37',
          'https://picsum.photos/250?image=38',
          'https://picsum.photos/250?image=39',
          'https://picsum.photos/250?image=40',
        ],
      ),
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
      ),
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
      ),
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
      ),
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
      ),
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
      ),
    ];
  }
}
