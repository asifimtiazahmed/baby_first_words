import 'items.dart';
import 'library_list.dart';

class SliderMain{

  String nameOfList; //name of the list
  List itemsList; //The items currently on the list
  int index=0;


  void start(String nameLibrary){
    switch(nameLibrary) {
      case 'animals':
        nameOfList = nameLibrary;
        createList(animals);
        break;
      case 'objects' :
        nameOfList = nameLibrary;
        createList(everydayObjects);
        break;
      case 'number':
        nameOfList = nameLibrary;
        createList(numbers);
        break;
      case 'alphabets':
        nameOfList = nameLibrary;
        createList(alphabets);
        break;
    }
  }

  void createList(List listFromLibrary){
    List<Items> newList = [];
    for(String x in listFromLibrary){
    Items items = Items();
      items.name = x;
      items.imagePath = 'assets/images/$nameOfList/$x.gif';
      items.soundPath = 'sounds/$x.mp3';
    //print('${items.name}\n${items.imagePath}\n${items.soundPath}');
      newList.add(items);
    }
    for(int x = 0; x< newList.length; x++){
      print('${newList[x].soundPath}, ${newList[x].imagePath}, ${newList[x].name}\n');
    }
    itemsList = newList;
  }

  String getItemName(){
    return itemsList[index].name;
  }

  String getImagePath(){
    return itemsList[index].imagePath;
  }

  String getSoundPath(){
    return itemsList[index].soundPath;
  }

  void updateIndex(int value){
    index += value;
    (index==null) ? index=0:index=index; //if index starts with null then index is 0
    (index > 50 || index < 0) ? index = 0 : index = index; //if the index is going beyond 50 or less than 0 then set it back to 0
  }

  void setIndex(int indexNo){
    (indexNo != null && indexNo <= 50 && indexNo >= 0) ? index = indexNo : print('index no $indexNo is invalid');
  }





}