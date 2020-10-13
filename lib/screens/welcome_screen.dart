import 'package:flutter/material.dart';
import '../widgets.dart';


class LobbyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1,
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              BigButton(assetImagePath: 'images/abc_main.webp', onPress: ()=> null, darkShadowColor: Colors.blue, lightShadowColor: Colors.yellow,),
              Text('Container 2'),
              Text('Container 3'),
              Text('Container 4'),
            ],
            padding: EdgeInsets.only(top: 150),

          ),
        ),
      ),
    );
  }
}