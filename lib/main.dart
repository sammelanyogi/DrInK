import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'prepage.dart';
import 'apppage.dart';

void main() => runApp(MyApp());
const loginUrl = "https://server.omhit.com/login";

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _auth = false;
  Future<http.Response> login;

  void _signInDone() {
    setState(() {
      _auth = true;
    });
  }

  void _signOutDone() {
    setState(() {
      _auth = false;
    });
  }

  Widget getPage() {
    if (_auth)
      return AppPage(logout: _signOutDone);
    else
      return LoginPage(signedIn: _signInDone);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: getPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
