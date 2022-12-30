// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/cupertino.dart';
// //import 'package:audioplayers/audio_cache.dart'; //this is for playing the sounds
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'; //this is for the arrows
// import 'package:flutter_first_words/slider_brain.dart';
// import 'package:flutter_first_words/random_color_generator.dart';
// import 'package:flutter_first_words/constants.dart';
// import '../slider_brain.dart';
// import '../big_button.dart';
// import 'package:firebase_admob/firebase_admob.dart';
// import 'package:flutter_first_words/admob.dart';
//
// class SlideshowScreen extends StatefulWidget {
//   final String libraryName;
//   final File assetPathFile;
//   SlideshowScreen({required this.libraryName, required this.assetPathFile});
//
//   @override
//   _SlideshowScreenState createState() => _SlideshowScreenState();
// }
//
// class _SlideshowScreenState extends State<SlideshowScreen> {
//   bool volumeStatus = true;
//   double gridIconSize = 100;
//   String soundPath = '';
//   double width = 0; //screen width for calculating the carousal movement
//   double height = 0; // screen height
//   AdMobService ams = AdMobService();
//   static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//     childDirected: true,
//     testDevices: <String>['Mobile_Id'], // Android emulators are considered test devices
//   );
//
//   BannerAd _bannerAd = BannerAd(
//     // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//     // https://developers.google.com/admob/android/test-ads
//     // https://developers.google.com/admob/ios/test-ads
//     adUnitId: BannerAd.testAdUnitId,
//     size: AdSize.smartBanner,
//     targetingInfo: targetingInfo,
//     listener: (MobileAdEvent event) {
//       print("BannerAd event is $event");
//     },
//   );
//
//   Widget volume(bool status) {
//     if (status) {
//       return Icon(Icons.volume_up);
//     } else
//       return Icon(Icons.volume_off);
//   }
//
//   SliderMain slider = SliderMain();
//   //final player = AudioCache();
//   AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
//   //final player = AudioCache(prefix: '');
//   ScrollController _controller = ScrollController(); //for controlling the GridView Scrolling
//
//   @override
//   void initState() {
//     _controller = ScrollController();
//     slider.assetPath = widget.assetPathFile;
//     slider.start(widget.libraryName);
//     soundPath = slider.getSoundPath();
//     try {
//       playLocal(soundPath);
//     } catch (e) {
//       print(e);
//     }
//     FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId); //ams.getAdMobAppId()
//     _bannerAd
//       ..load()
//       ..show(anchorType: AnchorType.bottom, anchorOffset: -10);
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _bannerAd.dispose();
//     super.dispose();
//   }
//
//   void prevCallback() {
//     setState(() {
//       slider.updateIndex(-1);
//       soundPath = slider.getSoundPath();
//       try {
//         (volumeStatus) ? playLocal(soundPath) : volumeStatus = volumeStatus;
//       } catch (e) {
//         print(e);
//       }
//       if (slider.index > 0) {
//         //this will prevent it from offsetting after the first image
//         _controller.animateTo(_controller.offset - gridIconSize,
//             curve: Curves.linear, duration: Duration(milliseconds: 500));
//       }
//     });
//   }
//
//   void nextCallback() {
//     setState(() {
//       slider.updateIndex(1);
//       soundPath = slider.getSoundPath();
//       try {
//         (volumeStatus) ? playLocal(soundPath) : volumeStatus = volumeStatus;
//       } catch (e) {
//         print(e);
//       }
//
//       if (slider.index > 1) {
//         _controller.animateTo(_controller.offset + gridIconSize,
//             curve: Curves.linear, duration: Duration(milliseconds: 500));
//       } else if (slider.index == 0) {
//         _controller.animateTo(_controller.offset - gridIconSize * slider.itemsList.length,
//             curve: Curves.linear, duration: Duration(milliseconds: 500));
//       }
//     });
//   }
//
//   void playLocal(String inputSoundPath) async {
//     int result = await audioPlayer.play(inputSoundPath, isLocal: true);
//     print('AUDIO PLAYER WAS CALLED AND THE RESULT IS $result');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     height = MediaQuery.of(context).size.height;
//     //print('the height of the screen is $height and the width of the device is $width');
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               'Baby First Words',
//               style:
//                   GoogleFonts.spicyRice(textStyle: TextStyle(letterSpacing: 1.2, fontSize: 25, color: Colors.black87)),
//             ),
//             ElevatedButton(
//                 child: volume(volumeStatus),
//                 onPressed: () {
//                   setState(() {
//                     (volumeStatus) ? volumeStatus = false : volumeStatus = true;
//                   });
//                 }),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               flex: 2,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(35, 8, 12, 5),
//                     child: Text(
//                       slider.nameOfList,
//                       style: GoogleFonts.spicyRice(
//                         textStyle: kGoogleStyle,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(2, 8, 55, 2),
//                     child: Text(
//                       slider.getItemName(),
//                       style: GoogleFonts.spicyRice(
//                         textStyle: kGoogleStyle.copyWith(color: UniqueColorGenerator.getColor()),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ), // Name of Library + Current Name
//             Expanded(
//               flex: 9,
//               child: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
//                 GestureDetector(
//                     onHorizontalDragEnd: (details) {
//                       if (details.primaryVelocity > 0) {
//                         prevCallback();
//                       }
//                       if (details.primaryVelocity < 0) {
//                         nextCallback();
//                       }
//                     },
//                     onTap: () {
//                       soundPath = slider.getSoundPath();
//                       try {
//                         (volumeStatus) ? playLocal(soundPath) : volumeStatus = volumeStatus;
//                       } catch (e) {
//                         print(e);
//                       }
//                     },
//                     child: Image.file(File(slider.getImagePath()))
//                     // AnimatedContainer(
//                     //   duration: const Duration(milliseconds: 400),
//                     //   //width: double.infinity,
//                     //   constraints: BoxConstraints.expand(),
//                     //   decoration: BoxDecoration(
//                     //     image: DecorationImage(
//                     //         image: AssetImage('images/alphabets/a.gif'),
//                     //         fit: BoxFit.scaleDown),
//                     //   ),
//                     // ),
//                     ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     '${slider.index + 1}/ ${slider.itemsList.length}',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                       backgroundColor: Color(0x66FFFFFF),
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//             Expanded(
//               flex: 3,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                       child: ClipPath(
//                         clipper: ArrowClipper(70, 90, Edge.LEFT),
//                         child: Container(
//                           height: 120,
//                           width: 150, //this is the size I specified for each of the carousal pictures,
//                           color: Colors.orange,
//                           child: Center(
//                             child: Text(
//                               "Previous",
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.spicyRice(
//                                 textStyle: kGoogleStyle.copyWith(color: Colors.black54, fontSize: 25),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       onLongPress: () {
//                         Duration delay = Duration(seconds: 2);
//                         Future.delayed((delay), () {
//                           prevCallback();
//                         });
//                       },
//                       onPressed: () {
//                         prevCallback();
//                       }),
//                   TextButton(
//                       child: ClipPath(
//                         clipper: ArrowClipper(70, 90, Edge.RIGHT),
//                         child: Container(
//                           height: 120,
//                           width: 150,
//                           color: Colors.green,
//                           child: Center(
//                             child: Text(
//                               "Next",
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.spicyRice(
//                                 textStyle: kGoogleStyle.copyWith(color: Colors.black54, fontSize: 25),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       onLongPress: () {
//                         Duration delay = Duration(seconds: 2);
//                         Future.delayed((delay), () {
//                           nextCallback();
//                         });
//                       },
//                       onPressed: () {
//                         nextCallback();
//                       }),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 4,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 10, 2, 10),
//                 child: GridView.count(
//                   controller: _controller,
//                   crossAxisCount: 1,
//                   childAspectRatio: 1,
//                   scrollDirection: Axis.horizontal,
//                   mainAxisSpacing: 10,
//                   children: createButtons(),
//                   addRepaintBoundaries: true,
//                 ),
//               ),
//             ), //List Slider
//             SizedBox(height: 100.0),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<Widget> createButtons() {
//     List<Widget> returningList = [];
//     for (int x = 0; x < slider.itemsList.length; x++) {
//       returningList.add(
//         Container(
//           child: BigButton(
//             useAssetImage: false,
//             fileImagePath: slider.itemsList[x].imagePath,
//             onPress: () {
//               setState(() {
//                 slider.setIndex(x); //set the index to the new selected image
//                 //   print('index set as $x in forLoop and actual item is now is ${slider.itemsList[x].imagePath} ');
//                 try {
//                   (volumeStatus) ? playLocal(slider.getSoundPath()) : volumeStatus = volumeStatus;
//                 } catch (e) {
//                   print(e);
//                 } //if volume status is not off then play its relevant file
//               });
//             },
//             splashColor: UniqueColorGenerator.getColor(),
//             lightShadowColor: Colors.lightGreenAccent,
//             darkShadowColor: Colors.black26,
//           ),
//         ),
//       );
//     }
//     return returningList;
//   }
// }
