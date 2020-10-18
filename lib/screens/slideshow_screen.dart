import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audio_cache.dart'; //this is for playing the sounds
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart'; //this is for the arrows
import 'package:flutter_first_words/slider_brain.dart';
import 'package:flutter_first_words/random_color_generator.dart';
import 'package:flutter_first_words/constants.dart';

import '../widgets.dart';

class SlideshowScreen extends StatefulWidget {
//TODO: Transfer the sliderBrain object from main screen to here
  final String libraryName;
  SlideshowScreen({this.libraryName});
  @override
  _SlideshowScreenState createState() => _SlideshowScreenState();
}

class _SlideshowScreenState extends State<SlideshowScreen> {
  bool volumeStatus = true;
  int index;
  int gridIconSize = 150;

  //UniqueColorGenerator colorGen = UniqueColorGenerator();

  Widget volume(bool status) {
    if (status) {
      return Icon(Icons.volume_up);
    } else
      return Icon(Icons.volume_off);
  }

  SliderMain slider = SliderMain();
  final player = AudioCache();
  ScrollController _controller; //for controlling the GridView Scrolling

  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController();
    slider.start(widget.libraryName);
    super.initState();
  }
  //TODO: Need to create a function to navigate to the slideshow screen passing on the argument of the selected button(abc, object etc)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Baby First Words',
          style: GoogleFonts.spicyRice(
              textStyle: TextStyle(
                  letterSpacing: 1.2, fontSize: 30, color: Colors.black87)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 20, 12, 5),
                    child: Text(
                      slider.nameOfList,
                      style: GoogleFonts.spicyRice(
                        textStyle: kGoogleStyle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 20, 55, 2),
                    child: Text(
                      slider.getItemName(),
                      style: GoogleFonts.spicyRice(
                        textStyle: kGoogleStyle.copyWith(
                            color: UniqueColorGenerator.getColor()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: GestureDetector(
                onTap: () {
                  //soundPath = slider.getSoundPath();
                  (volumeStatus) ? player.play(slider.getSoundPath()) : volumeStatus = volumeStatus;
                },
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(slider.getImagePath()),
                        fit: BoxFit.scaleDown),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 0, 10),
                    child: Text(
                      '${slider.index + 1}/ ${slider.itemsList.length - 1}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FlatButton(
                      child: volume(volumeStatus),
                      onPressed: () {
                        setState(() {
                          (volumeStatus)
                              ? volumeStatus = false
                              : volumeStatus = true;
                        });
                      }),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    child: ClipPath(
                      clipper: ArrowClipper(70, 90, Edge.LEFT),
                      child: Container(
                        height: 120,
                        width: 150,
                        color: Colors.orange,
                        child: Center(
                          child: Text(
                            "Previous",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spicyRice(
                              textStyle: kGoogleStyle.copyWith(
                                  color: Colors.black54, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        slider.updateIndex(-1);
                        (volumeStatus) ? player.play(slider.getSoundPath()) : volumeStatus = volumeStatus;
                        if(slider.index != 0) { //this will prevent it from offsetting after the first image
                          _controller.animateTo(
                              _controller.offset - gridIconSize,
                              curve: Curves.linear,
                              duration: Duration(milliseconds: 500));
                        }
                      });
                    }
                  ),
                  FlatButton(
                    child: ClipPath(
                      clipper: ArrowClipper(70, 90, Edge.RIGHT),
                      child: Container(
                        height: 120,
                        width: 150,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            "Next",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spicyRice(
                              textStyle: kGoogleStyle.copyWith(
                                  color: Colors.black54, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        slider.updateIndex(1);
                        (volumeStatus) ? player.play(slider.getSoundPath()) : volumeStatus = volumeStatus;

                        if(slider.index != 0){
                          _controller.animateTo(_controller.offset + gridIconSize,
                            curve: Curves.linear, duration: Duration(milliseconds: 500));
                        }
                      });
                    }
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,10,2,10),
                child: GridView.count(
                    controller: _controller,
                    crossAxisCount: 1,
                    childAspectRatio: 1,
                    scrollDirection: Axis.horizontal,
                    mainAxisSpacing: 10,
                    children: createButtons(),
                  addRepaintBoundaries: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  List <Widget> createButtons (){
  List<Widget> returningList = [];
    for(int x=0; x< slider.itemsList.length; x++){
      returningList.add(
          Container(
            width: 150,
            child: BigButton(
              assetImagePath: slider.itemsList[x].imagePath,
              onPress: (){
                setState(() {
                  slider.setIndex(x); //set the index to the new selected image
                  print('index set as $x in forLoop and actual item is now is ${slider.itemsList[x].imagePath} ');
                  (volumeStatus) ? player.play(slider.getSoundPath()) : volumeStatus = volumeStatus; //if volume status is not off then play its relevant file
                });

              },
              splashColor: UniqueColorGenerator.getColor(),
              lightShadowColor: Colors.lightGreenAccent,
              darkShadowColor: Colors.black26,
            ),
          ),
      );
    }
    return returningList;

  }
}





