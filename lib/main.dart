import 'package:baby_f_words/managers/app_config.dart';
import 'package:baby_f_words/screens/lobby/lobby_view.dart';
import 'package:baby_f_words/screens/lobby/lobby_view_model.dart';
import 'package:baby_f_words/screens/slideshow/slideshow_view.dart';
import 'package:baby_f_words/screens/slideshow/slideshow_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await AppConfig.init(AppFlavor.dev);
  runApp(const FirstWords());
}

class FirstWords extends StatelessWidget {
  const FirstWords({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MultiProvider(providers: [
              Provider<LobbyViewModel>(
                create: (_) => LobbyViewModel(),
              ),
            ], child: const LobbyView()),
        '/slideshow': (context) => MultiProvider(providers: [
              Provider<SlideShowViewModel>(
                create: (_) => SlideShowViewModel(),
              ),
            ], child: const SlideshowView()),
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
