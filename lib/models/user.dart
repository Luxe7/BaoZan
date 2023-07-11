class User {
  String? id;
  String? avatar;
  String? name;
  String? background;

  User({
    this.id,
    this.avatar,
    this.name,
    this.background,
  });

  User.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    avatar = json?['avatar'];
    name = json?['name'];
    background = json?['background'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar'] = avatar;
    data['name'] = name;
    data['background'] = background;
    return data;
  }
}
