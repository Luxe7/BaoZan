class User {
  String? id;
  String? avatar;
  String? name;

  User({
    this.id,
    this.avatar,
    this.name,
  });

  User.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    avatar = json?['avatar'];
    name = json?['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar'] = avatar;
    data['name'] = name;
    return data;
  }
}
