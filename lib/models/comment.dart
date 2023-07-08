import 'package:wechat/models/user.dart';

class Comment {
  String? id;
  User? user;
  String? content;

  Comment({
    this.id,
    this.user,
    this.content,
  });

  Comment.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    user = json?['user'] != null ? User.fromJson(json?['user']) : null;
    content = json?['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user?.toJson();
    }
    data['content'] = content;
    return data;
  }
}
