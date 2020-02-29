import 'package:flutter/material.dart';

class SocialButtons extends StatefulWidget {
  SocialButtons({this.google, this.facebook});
  final VoidCallback google, facebook;
  @override
  _SocialButtonsState createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlineButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/google.png'),
                height: 20,
                width: 20,
              ),
              Text(
                "Sign in with Google",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black38
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: widget.google,
        ),
        FlatButton(
          color: Color(0xff3b5998),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/facebook.jpg'),
                height: 20,
                width: 20,
              ),
              Text(
                "Sign in with Facebook",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: widget.facebook,
        ),
      ],
    );
  }
}
