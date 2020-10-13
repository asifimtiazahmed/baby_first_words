import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BigButton extends StatelessWidget {
  final String assetImagePath;
  final Function onPress;
  final String soundPath;
  final Color darkShadowColor;
  final Color lightShadowColor;

  BigButton(
      {@required this.assetImagePath, @required this.onPress, this.soundPath, this.darkShadowColor, this.lightShadowColor});
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
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(assetImagePath),
                fit: BoxFit.scaleDown
            ),
          ),
        ),
        onPressed: onPress,
      ),
    );
  }
}
