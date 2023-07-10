import 'package:wechat/models/user.dart';
import 'package:wechat/utils/index.dart';

class Favorates {
  List<User> users = [];
  List<String> selectedNicknames = [];
  List<String> selectedAvatar = [];

  Favorates(collectedNumber) {
    selectedNicknames = createNicknames(collectedNumber);
    selectedAvatar = createAvatar(collectedNumber);

    for (var i = 0; i < collectedNumber; i++) {
      var temp = User(
        id: i.toString(),
        avatar: selectedAvatar[i],
        name: selectedNicknames[i],
      );
      users.add(temp);
    }
  }
  List<User> getList() {
    return users;
  }
}
