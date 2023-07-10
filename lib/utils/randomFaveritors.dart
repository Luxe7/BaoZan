import 'dart:math';

import 'package:wechat/models/user.dart';

List<String> nicknames = [
  '''阿汐汐汐汐
百合
夏时
Minty！
情伤
章叔叔
李阿姨
王伯伯
王婶婶
志祥表哥
涟子天一'''
];

List<String> createFavorates(collectedNumber) {
  List<String> selectedNicknames =
      getRandomNicknames(nicknames, collectedNumber);
  return selectedNicknames;
}

List<String> getRandomNicknames(
    List<String> nicknames, int numberOfNicknamesToSelect) {
  List<String> selectedNicknames = [];

  Random random = Random();

  while (selectedNicknames.length < numberOfNicknamesToSelect) {
    int randomIndex = random.nextInt(nicknames.length);
    String selectedNickname = nicknames[randomIndex];
    if (!selectedNicknames.contains(selectedNickname)) {
      selectedNicknames.add(selectedNickname);
    }
  }

  return selectedNicknames;
}
