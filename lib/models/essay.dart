// 定义文章模型
class Essay {
  String? id;
  String? title;
  String? description;
  // 封面
  String? cover;
// 链接
  String? link;

  Essay({
    this.id,
    this.title,
    this.description,
    this.cover,
    this.link,
  });

  Essay.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    title = json?['title'];
    description = json?['description'];
    cover = json?['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['cover'] = cover;
    data['link'] = link;
    return data;
  }
}
