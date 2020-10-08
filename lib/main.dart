import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(FirstWords());
}

class FirstWords extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baby First Words',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightBlue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: SlideshowScreen(),
      home: LobbyScreen(),
    );
  }
}

class SlideshowScreen extends StatefulWidget {
  @override
  _SlideshowScreenState createState() => _SlideshowScreenState();
}

class _SlideshowScreenState extends State<SlideshowScreen> {
  bool volStat = true;
  Widget volume(bool status){
    if(status){
      return Icon(Icons.volume_up);
    } else
       return Icon(Icons.volume_off);
  }
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
                    child: volume(volStat),
                    onPressed: () {
                      setState(() {
                        (volStat) ? volStat = false : volStat = true;
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

class LobbyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Text('Everyday Objects'),
                      constraints: BoxConstraints.expand(width: 100, height: 100),
                    ),
                    Container(
                      constraints: BoxConstraints.expand(width: 100, height: 100),
                      child: Text('Animals'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(width: 100, height: 100),
                      child: Text('ABC',),
                    ),
                    Container(
                      constraints: BoxConstraints.expand(width: 100, height: 100),
                      child: Text('123 Numbers'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



