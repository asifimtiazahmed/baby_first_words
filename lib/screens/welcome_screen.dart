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
              BigButton(assetImagePath: 'images/abc.png', onPress: ()=> Navigator.pushNamed(context, '/slideshow'), darkShadowColor: Colors.blue, lightShadowColor: Colors.yellow,),
              BigButton(assetImagePath: 'images/animals.png', onPress: ()=> null, darkShadowColor: Colors.blue, lightShadowColor: Colors.yellow,),
              BigButton(assetImagePath: 'images/obj.png', onPress: ()=> null, darkShadowColor: Colors.blue, lightShadowColor: Colors.yellow,),
              BigButton(assetImagePath: 'images/123.png', onPress: ()=> null, darkShadowColor: Colors.blue, lightShadowColor: Colors.yellow,),
            ],
            padding: EdgeInsets.only(top: 150, left: 20, right: 20),

          ),
        ),
      ),
    );
  }
}