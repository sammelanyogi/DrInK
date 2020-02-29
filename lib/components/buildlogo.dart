import 'package:flutter/material.dart';

class BuildLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: deviceWidth * 0.4,
      width: deviceWidth * 0.4,
      child: Image(image: AssetImage('assets/icon/logo.png')),
    );
  }
}
