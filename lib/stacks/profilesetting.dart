import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          backgroundColor: Color(0xff30cbef),
        ),
        body: Container(
          color: Colors.white,
        ));
  }
}
