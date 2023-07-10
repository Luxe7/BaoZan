import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

List<String> avatars = [];

String folderPath = 'images/avatar';

void count(collectedNumber) async {
  for (int i = 1; i <= collectedNumber; i++) {
    String filePath = '$folderPath/${i.toString().padLeft(3, '0')}.jpeg';
    avatars.add(filePath);
  }
}

// Future<String> preconditioning(String imagePath) async {
//   File imageFile = File(imagePath);
//   Uint8List imageBytes = await imageFile.readAsBytes();
//   String base64String = base64Encode(imageBytes);
//   return base64String;
// }

List<String> createAvatar(collectedNumber) {
  count(collectedNumber);
  List<String> selectedAvatar = getRandomAvatar(avatars, collectedNumber);
  return selectedAvatar;
}

List<String> getRandomAvatar(
    List<String> avatars, int numberOfNicknamesToSelect) {
  // 从nicknames中随机抽取numberOfNicknamesToSelect个元素到selectedNicknames
  List<String> selectedNicknames = [];
  List<String> tempavatars = [...avatars];
  for (var i = 0; i < numberOfNicknamesToSelect; i++) {
    //var randomIndex = Random().nextInt(tempavatars.length - i);
    var randomIndex = Random().nextInt(tempavatars.length - i);
    selectedNicknames.add(tempavatars[randomIndex]);
    tempavatars[randomIndex] = tempavatars[tempavatars.length - i - 1];
  }
  // 继续改进

  return selectedNicknames;
}
