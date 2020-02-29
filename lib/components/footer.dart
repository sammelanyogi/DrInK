import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  Footer({this.text, this.color});
  final String text;
  final Color color;
  @override
  FooterState createState() => FooterState();
}

class FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top:25, bottom:20),
        child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 15,
          color: widget.color==null? Colors.black.withOpacity(0.2): widget.color,
        ),
      ),
    );
  }
}
