import 'package:flutter/material.dart';

class BuildLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: deviceWidth * 0.4,
      width: deviceWidth * 0.4,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Color(0xff000000).withOpacity(0.2),
              spreadRadius: 2,
            ),
          ],
          color: Colors.white,
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.scaleDown,
            image: AssetImage('assets/images/logo.png'),
          )),
    );
  }
}
