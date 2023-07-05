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
}
