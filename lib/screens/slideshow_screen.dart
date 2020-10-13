import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class SlideshowScreen extends StatefulWidget {
  @override
  _SlideshowScreenState createState() => _SlideshowScreenState();
}

class _SlideshowScreenState extends State<SlideshowScreen> {
  bool volumeStatus = true;
  Widget volume(bool status){
    if(status){
      return Icon(Icons.volume_up);
    } else
      return Icon(Icons.volume_off);
  }

  //TODO: Need to create a function to navigate to the slideshow screen passing on the argument of the selected button(abc, object etc)


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Baby First Words',
          style: GoogleFonts.sansita(
              textStyle: TextStyle(letterSpacing: 0.8, fontSize: 30)
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget> [
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FlatButton(
                    child: Text('< Back'),
                    //TODO: this back should pop this window and take us to the main window to Select the Library to view
                    onPressed: ()=> null,
                  ),
                  Text('Everyday Objects'), //ToDo: This should show the name of the library
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: GestureDetector(
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/animals/rabbit.gif'),
                        fit: BoxFit.scaleDown
                    ),
                  ),
                  child: Text('Image.asset() here'), //Clickable image asset here
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('index no / total'),
                  FlatButton(
                      child: volume(volumeStatus),
                      onPressed: () {
                        setState(() {
                          (volumeStatus) ? volumeStatus = false : volumeStatus = true;
                          //TODO: need to link this to the sound getter so that it does not play sound
                        });
                      }
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    child: Container(child: Text('<--BtnLeft'),
                        width: 150.0,
                        height: double.infinity),
                    onPressed: ()=> null,),
                  FlatButton(
                    child: Container(child: Text('Btnright-->'),
                        width: 150.0,
                        height: double.infinity),
                    onPressed: ()=> null,),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                  'List View for all the images in the list'
              ),
            ),
          ],
        ),
      ),
    );
  }
}