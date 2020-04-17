import 'package:flutter/material.dart';

class Question extends StatefulWidget {
  Question({this.question});
  final String question;
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Text(
        widget.question,
        style: TextStyle(
          fontFamily: 'Gilroy',
          fontSize: 18,
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
    );
  }
}
