import 'package:flutter/material.dart';

class BuildLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    
    return Container(
      height: deviceHeight * 0.22,
      width: deviceHeight * 0.22,
      child: Image(image: AssetImage('assets/icon/logo.png')),
    );
  }
}
