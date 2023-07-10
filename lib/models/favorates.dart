import 'package:wechat/models/user.dart';
import 'package:wechat/utils/index.dart';

class Favorates {
  List<User> users = [];
  List<String> selectedNicknames = [];

  Favorates(collectedNumber) {
    selectedNicknames = createFavorates(collectedNumber);

    for (var i = 0; i < collectedNumber; i++) {
      var temp = User(
        id: i.toString(),
        avatar: 'https://picsum.photos/250?image=9',
        name: selectedNicknames[i],
      );
      users.add(temp);
    }
  }
  List<User> getList() {
    return users;
  }
}
