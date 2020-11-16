import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_first_words/screens/welcome_screen.dart';
import './screens/slideshow_screen.dart';
import 'package:firebase_core/firebase_core.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(FirstWords());
}

class FirstWords extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      initialRoute: '/',
      routes: {
        '/' : (context) => LobbyScreen(),
        '/slideshow' : (context)=> SlideshowScreen()
      },
      debugShowCheckedModeBanner: false,
      title: 'Baby First Words',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: SlideshowScreen(),
    );
  }
}



