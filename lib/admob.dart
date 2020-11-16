import 'dart:io';

class AdMobService {

  String getAdmobAppId(){
    if(Platform.isIOS){
      return 'need-to-set-this-key';
    } else if (Platform.isAndroid){
      return 'ca-app-pub-9426901076429008~4298694319';
    }
    return null;
  }


  String getBannerAdId(){
    if(Platform.isIOS){
      return 'need-to-set-this-key';
    } else if (Platform.isAndroid){
      return 'ca-app-pub-9426901076429008/6381932174'; //Change this key for production release
    }
    return null;
  }



}