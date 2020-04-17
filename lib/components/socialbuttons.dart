import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        RaisedButton(
          onPressed: widget.facebook,
          color: Color(0xff3b5998),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.facebookF,
                color: Colors.white,
              ),
              Text(
                "Sign in with Facebook",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        RaisedButton(
          onPressed: widget.google,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 20,
                child: Image(
                  image: AssetImage("assets/images/google.png"),
                ),
              ),
              Text(
                "Sign in with Google",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
