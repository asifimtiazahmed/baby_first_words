import 'package:audioplayers/audioplayers.dart';
import 'package:baby_f_words/managers/assets.dart';
import 'package:baby_f_words/managers/data_manager.dart';
import 'package:baby_f_words/managers/firebase_storage_manager.dart';
import 'package:baby_f_words/managers/local_storage_manager.dart';
import 'package:baby_f_words/models/items.dart';
import 'package:baby_f_words/models/slideshow.dart';
import 'package:flutter/material.dart';
import 'package:baby_f_words/big_button.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:recase/recase.dart';

import 'package:baby_f_words/random_color_generator.dart';
import 'package:baby_f_words/managers/admob.dart';

class LobbyViewModel with ChangeNotifier {
  bool isLoading = true;
  final _firebaseManager = FirebaseStorageManager();
  final _dataManager = GetIt.I<DataManager>();
  final _storageManager = StorageManager();
  List<BigButton> listOfButtons = [];
  List<SlideshowItem> slideshowItems = [];
  List<String> listOfFolders = [];
  final logger = Logger();
  bool isLoadingButton = true;
  final audioPlayer = AudioPlayer();
  BannerAd? banner;

  LobbyViewModel() {
    init();
    createBannerAd();
  }

  createBannerAd() {
    banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService().getBannerAdId(),
        listener: AdMobService.bannerListener,
        request: const AdRequest())
      ..load();
  }

  init() async {
    await audioPlayer.setSource(AssetSource(Assets.startUpMusic));
    await audioPlayer.resume();
    listOfFolders = await _firebaseManager.generateFileList(); //Folders on the firestore_storageManager.
    listOfButtons.clear();
    _dataManager.bigButtonList.clear();
    bool folderNeedsDownload = false;
    //MAIN Loop to create the buttons
    for (var item in listOfFolders) {
      folderNeedsDownload = false;

      String slideshowName = item.titleCase;

      List<String> imagePaths =
          await _firebaseManager.getListOfFilesAtPath(pathComponents: [item, FirebaseStorageFolders.images.pathName]);
      List<String> soundPaths =
          await _firebaseManager.getListOfFilesAtPath(pathComponents: [item, FirebaseStorageFolders.sounds.pathName]);
      List<String> baseAssets = await _firebaseManager.getListOfFilesAtPath(pathComponents: [item]);

      folderNeedsDownload = await needToDownload(slideshowName, imagePaths);

      String soundPath = '';
      String fileImagePath = '';
      if (imagePaths.isNotEmpty && soundPaths.isNotEmpty) {
        if (baseAssets.first.split('.')[1] == 'mp3' || baseAssets.first.split('.')[1] == 'wav') {
          soundPath = baseAssets.first;
          fileImagePath = baseAssets.last;
        } else {
          soundPath = baseAssets.last;
          fileImagePath = baseAssets.first;
        }
        //GETS AND STORES THE LIST OF ASSETS ON EACH OF THE STORAGE FOLDERS
        soundPath = await _firebaseManager.getDownloadUrl(soundPath);
        fileImagePath = await _firebaseManager.getDownloadUrl(fileImagePath);

        Slideshow slideshow;
        if (!folderNeedsDownload) {
          slideshow = await _storageManager.readSlideshow(slideshowName: slideshowName);
        } else {
          //The items are missing, they will be setup properly after buttons are rendered
          slideshow = Slideshow(
            slideshowName: slideshowName,
            coverImagePath: fileImagePath,
            coverSoundPath: soundPath,
          );

          //Creating the slideshowItem to be stored and later processed
          SlideshowItem slideshowItem =
              SlideshowItem(name: slideshowName, imageList: imagePaths, soundList: soundPaths);
          slideshowItems.add(slideshowItem);
        }
        BigButton bigButton = BigButton(
          soundPath: soundPath,
          fileImagePath: fileImagePath,
          name: slideshowName,
          slideshow: slideshow,
          isLoading: (folderNeedsDownload) ? isLoadingButton : !isLoadingButton,
          textColor: UniqueColorGenerator.getColor(),
        );

        listOfButtons.add(bigButton);
        _dataManager.bigButtonList.add(bigButton);
        logger.i('added $slideshowName to library, current library size: ${listOfButtons.length}');
      }
    }

    await audioPlayer.stop();
    isLoading = false;
    notifyListeners();
    if (folderNeedsDownload) {
      await addSlideshowAndCompleteButtons();
    }
  }

  addSlideshowAndCompleteButtons() async {
    for (var i = 0; i < listOfButtons.length; i++) {
      int index = slideshowItems.indexWhere((slideshowElement) => slideshowElement.name == listOfButtons[i].name);
      listOfButtons[i].slideshow?.items =
          await generateItemListObjects(slideshowItems[index].imageList, slideshowItems[index].soundList, i);
      await _storageManager.writeSlideshow(listOfButtons[i].slideshow!);
    }
  }

  Future<bool> needToDownload(String slideshowName, List<String> imageNames) async {
    Slideshow slideshow = await _storageManager.readSlideshow(slideshowName: slideshowName);
    try {
      if (slideshow.slideshowName == null || slideshow.items == null) {
        return true;
      } else if (slideshow.items != null && slideshow.items!.length != imageNames.length) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e('Error with looking up slideshow in local storage $e');
      return true;
    }
  }

  Future<List<Item>> generateItemListObjects(
      List<String> imagePaths, List<String> soundPaths, int indexOfButtonInButtonList) async {
    List<Item> generateItems = [];
    //Both the lists should be the same
    int? itemIndex = 0;
    int totalNumberOfItemsToProcess = imagePaths.length + soundPaths.length;
    double completed = 0.0;
    int increment = 0;
    bool containsNumericSort = false;
    for (int i = 0; i < imagePaths.length; i++) {
      String imageName = imagePaths[i].split('/').last.split('.').first;
      for (int j = 0; j < soundPaths.length; j++) {
        String soundName = soundPaths[j].split('/').last.split('.').first;
        itemIndex = 0;
        if (soundName == imageName) {
          if (imageName.contains('#')) {
            containsNumericSort = true;
            String newImageName = imageName.split('#')[1];
            itemIndex = int.tryParse(imageName.split('#')[0]);
            imageName = newImageName;
          }
          String imageUrl = await _firebaseManager.getDownloadUrl(imagePaths[i]);

          increment++;
          completed = increment / totalNumberOfItemsToProcess;
          updateButton(indexOfButtonInButtonList, completed);

          String soundUrl = await _firebaseManager.getDownloadUrl(soundPaths[j]);

          Item item = Item(
            name: imageName,
            soundPath: soundUrl,
            imagePath: imageUrl,
            itemIndex: itemIndex,
          );
          generateItems.add(item);

          increment++;
          completed = increment / totalNumberOfItemsToProcess;
          updateButton(indexOfButtonInButtonList, completed);
          notifyListeners();
        }
      }
    }
    //Sort
    if (containsNumericSort) {
      generateItems.sort((a, b) => a.itemIndex!.compareTo(b.itemIndex!));
    } else {
      generateItems.sort((a, b) => a.name!.compareTo(b.name!));
    }
    return generateItems;
  }

  updateButton(int index, double percentage) {
    listOfButtons[index];
    bool isLoading = percentage != 1 ? true : false;
    BigButton bigButton = BigButton(
      name: listOfButtons[index].name,
      soundPath: listOfButtons[index].soundPath,
      fileImagePath: listOfButtons[index].fileImagePath,
      isLoading: isLoading,
      progressValue: percentage,
      slideshow: listOfButtons[index].slideshow,
      topRightColor: Colors.blue.withOpacity(0.3),
      bottomLeftColor: Colors.purple.withOpacity(0.3),
      textColor: listOfButtons[index].textColor,
      //volume: listOfButtons[index].volume, //max
    );
    listOfButtons[index] = bigButton;
    notifyListeners();
  }
}

class SlideshowItem {
  String name;
  List<String> imageList;
  List<String> soundList;

  SlideshowItem({required this.name, required this.imageList, required this.soundList});
}
