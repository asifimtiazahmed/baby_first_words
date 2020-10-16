import 'package:flutter/material.dart';
import './screens/slideshow_screen.dart';
import 'widgets.dart';
import './screens/welcome_screen.dart';

void main() {
  runApp(FirstWords());
}

class FirstWords extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context)=> LobbyScreen(),
        '/slideshow' : (context)=> SlideshowScreen()
      },
      debugShowCheckedModeBanner: false,
      title: 'Baby First Words',
      theme: ThemeData(

        primarySwatch: Colors.lightBlue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: SlideshowScreen(),
    );
  }
}



