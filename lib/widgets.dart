import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import  'dart:io';

class BigButton extends StatelessWidget {
  final String fileImagePath;
  final Function onPress;
  final String soundPath;
  final Color darkShadowColor;
  final Color lightShadowColor;
  final Color splashColor;
  final bool useAssetImage;

  BigButton(
      {@required this.fileImagePath, @required this.onPress, this.soundPath, this.darkShadowColor, this.lightShadowColor, this.splashColor, this.useAssetImage});
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          depth: 2,
          lightSource: LightSource.topLeft,
          shadowDarkColor: darkShadowColor,
          shadowLightColor: lightShadowColor,
          color: Colors.white,
      ),
      child: FlatButton(
        splashColor: splashColor,
        child: (useAssetImage == false) ? Image.file(File(fileImagePath)) :
        Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(fileImagePath),
                fit: BoxFit.scaleDown
            ),
          ),
        ),
        onPressed: onPress,
      ),
    );
  }
}

