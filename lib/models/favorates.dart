import 'package:wechat/models/user.dart';
import 'package:wechat/utils/index.dart';

class Favorates {
  List<User>? favorates;
  List<String> selectedNicknames = [];

  Favorates(collectedNumber) {
    selectedNicknames = createFavorates(collectedNumber);

    for (var i = 0; i < collectedNumber; i++) {
      User(
        id: i.toString(),
        avatar: 'https://picsum.photos/250?image=9',
        name: selectedNicknames[i],
      );
    }
  }
}
