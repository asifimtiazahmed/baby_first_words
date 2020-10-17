import 'package:flutter/material.dart';
import 'package:flutter_first_words/screens/slideshow_screen.dart';
import '../widgets.dart';
import 'package:flutter_first_words/slider_brain.dart';
import 'package:flutter_first_words/library_list.dart';
import 'package:google_fonts/google_fonts.dart';

class LobbyScreen extends StatelessWidget {
  final SliderMain slide = SliderMain();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xFFF1F8E9),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1,
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              Center(
                  child: Text(
                'Baby First ',
                style: GoogleFonts.spicyRice(
                  textStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 60,
                      fontWeight: FontWeight.w400,
                      textBaseline: TextBaseline.ideographic),
                ),
                textAlign: TextAlign.end,
              )),
              Center(
                child: Text('Words',
                    style: GoogleFonts.spicyRice(
                      textStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 60,
                          fontWeight: FontWeight.w400),
                    ),
                    textAlign: TextAlign.start),
              ),
              BigButton(
                assetImagePath: 'assets/images/ABC.png',
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SlideshowScreen(libraryName: 'letters',),
                  ),);
                  //slide.nameOfList = 'letters';
                },
                darkShadowColor: Colors.blue,
                lightShadowColor: Colors.yellow,
                splashColor: Colors.orangeAccent,
              ),
              BigButton(
                assetImagePath: 'assets/images/animals.png',
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SlideshowScreen(libraryName: 'animals',),
                  ),);
                  //slide.nameOfList = 'letters';
                },
                darkShadowColor: Colors.blue,
                lightShadowColor: Colors.yellow,
                splashColor: Colors.deepOrange,
              ),
              BigButton(
                assetImagePath: 'assets/images/obj.png',
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SlideshowScreen(libraryName: 'objects',),
                  ),);
                  //slide.nameOfList = 'letters';
                },
                darkShadowColor: Colors.blue,
                lightShadowColor: Colors.yellow,
                splashColor: Colors.lightBlue,
              ),
              BigButton(
                assetImagePath: 'assets/images/123.png',
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SlideshowScreen(libraryName: 'numbers',),
                  ),);
                  //slide.nameOfList = 'letters';
                },
                darkShadowColor: Colors.blue,
                lightShadowColor: Colors.yellow,
                splashColor: Colors.green,
              ),
            ],
            padding: EdgeInsets.only(top: 120, left: 20, right: 20),
          ),
        ),
      ),
    );
  }
}
