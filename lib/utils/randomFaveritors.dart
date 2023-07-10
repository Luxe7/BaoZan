import 'dart:math';

import 'package:wechat/models/user.dart';

List<String> _nicknames = '''阿汐汐汐汐
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
    .split('\n');

List<String> createFavorates(collectedNumber) {
  List<String> selectedNicknames =
      getRandomNicknames(_nicknames, collectedNumber);
  return selectedNicknames;
}

List<String> getRandomNicknames(
    List<String> nicknames, int numberOfNicknamesToSelect) {
  // 从nicknames中随机抽取numberOfNicknamesToSelect个元素到selectedNicknames
  List<String> selectedNicknames = [];
  List<String> tempNicknames = [...nicknames];
  // for (var i = 0; i < numberOfNicknamesToSelect; i++) {
  //   if (tempNicknames.isEmpty) {
  //     break;
  //   }
  //   var randomIndex = Random().nextInt(tempNicknames.length);
  //   selectedNicknames.add(tempNicknames[randomIndex]);
  //   tempNicknames.removeAt(randomIndex);
  // }
  // 更高效的写法
  // for (var i = 0; i < numberOfNicknamesToSelect; i++) {
  //   var randomIndex = Random().nextInt(tempNicknames.length);
  //   selectedNicknames.add(tempNicknames[randomIndex]);
  //   tempNicknames[randomIndex] = tempNicknames[tempNicknames.length - 1];
  //   tempNicknames.removeLast();
  // }
  // 再高效一点，不用removeLast
  for (var i = 0; i < numberOfNicknamesToSelect; i++) {
    var randomIndex = Random().nextInt(tempNicknames.length - i);
    selectedNicknames.add(tempNicknames[randomIndex]);
    tempNicknames[randomIndex] = tempNicknames[tempNicknames.length - i - 1];
  }
  // 继续改进

  return selectedNicknames;
}
