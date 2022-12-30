import 'models/items.dart';
import 'library_list.dart';
import 'dart:io';

class SliderMain {
  File assetPath = File('');
  String nameOfList = ''; //name of the list
  List itemsList = []; //The items currently on the list
  int index = 0;
  int maxIndex = 0; //50

  void start(String nameLibrary) {
    switch (nameLibrary) {
      case 'animals':
        nameOfList = nameLibrary;
        createLocalList(animals);
        maxIndex = itemsList.length;
        break;
      case 'objects':
        nameOfList = nameLibrary;
        createLocalList(everydayObjects);
        maxIndex = itemsList.length;
        break;
      case 'numbers':
        nameOfList = nameLibrary;
        createLocalList(numbers);
        maxIndex = itemsList.length;
        break;
      case 'alphabets':
        nameOfList = nameLibrary;
        createLocalList(alphabets);
        maxIndex = itemsList.length;
        break;
    }
  }

  void createLocalList(List listFromLibrary) {
    List<Items> newList = [];
    for (String x in listFromLibrary) {
      // Items items = Items();
      // items.name = x;
      // items.imagePath = assetPath.path + '/images/$nameOfList/$x.gif';
      // items.soundPath = assetPath.path + '/sounds/$nameOfList/$x.mp3';
      // newList.add(items);
    }

    itemsList = newList;
  }

  String getItemName() {
    return itemsList[index].name;
  }

  String getImagePath() {
    return itemsList[index].imagePath;
  }

  String getSoundPath() {
    return itemsList[index].soundPath;
  }

  void updateIndex(int value) {
    //
    // index += value;
    (index == null) ? index = 0 : index = index; //if index starts with null then index is 0
    ((index + value) >= maxIndex || (index + value) <= 0)
        ? index = 0
        : index += value; //if the index is going beyond 50 or less than 0 then set it back to 0
  }

  void setIndex(int indexNo) {
    (indexNo != null && indexNo <= maxIndex && indexNo >= 0) ? index = indexNo : print('index no $indexNo is invalid');
  }
}
