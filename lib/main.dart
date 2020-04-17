import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'prepage.dart';
import 'apppage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();
  String jwt;
  bool _auth;
  bool loading = true;
  Future<bool> auth() async {
    jwt = await storage.read(key: 'drinkUserInfo');
    return jwt==null?  false: true;
  }

  void _signInDone() async {
    setState(() {
      _auth = true;
    });
  }

  _signOutDone() {
    storage.delete(key: 'drinkUserInfo');

    setState(() {
      _auth = false;
    });
  }

  Future<Widget> getPage() async {
    _auth = await auth();
    return _auth ? AppPage(logout: _signOutDone):LoginPage(signedIn: _signInDone);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<Widget>(
          future: getPage(),
          builder: ( context,  snapshot) {
            
            if (snapshot.hasData) {
              return snapshot.data;
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    )
                  ],
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}
