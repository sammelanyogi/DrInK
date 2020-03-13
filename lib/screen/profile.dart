import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../stacks/profilesetting.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  Profile({this.logout});
  final VoidCallback logout;
  @override
  _ProfileState createState() => _ProfileState();
}

const apiUrl = "http://192.168.1.79:3000/dataCollected";
Future<http.Response> dataApi(String url, Map jsonMap) async {
  http.Response response;
  print(json.encode(jsonMap));
  try {
    response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: utf8.encode(
        json.encode(jsonMap),
      ),
    );
  } catch (e) {
    print(e.toString());
    response = null;
  }
  return response;
}

class _ProfileState extends State<Profile> {
  final storage = FlutterSecureStorage();
  void _logout() {
    widget.logout();
  }

  var userData;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserData();
    });
  }

  int dataCol;
  http.Response response;
  loadUserData() async {
    var data = await storage.read(key: 'drinkUserInfo');
    setState(() {
      userData = json.decode(data);
    });
    bringdata();
    print(userData);
  }

  bringdata() async {
    response = await dataApi(apiUrl, {'email': userData['email']});
    if (response != null) {
      print(response.body);
      setState(() {
        dataCol = json.decode(response.body)['number'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff30cbef), Colors.white],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: paddingTop,
            ),
            SizedBox(
              height: deviceHeight * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 65.0,
                        bottom:
                            deviceHeight > deviceWidth ? 0 : paddingTop * 3),
                    height: deviceHeight > deviceWidth
                        ? deviceHeight * 0.6
                        : deviceWidth * 0.8,
                    width: deviceHeight > deviceWidth
                        ? deviceWidth - paddingTop * 2
                        : deviceWidth - paddingTop * 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color(0xff000000).withOpacity(0.2),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: deviceWidth * 0.22,
                          ),
                          Text(
                            userData == null ? "..." : userData['name'],
                            style: GoogleFonts.poppins(
                              color: Color(0xfff7931e),
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            userData == null ? "..." : userData['type'],
                            style: GoogleFonts.poppins(
                              color: Color(0xff898989),
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.06,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                dataCol == null ? "..." : "$dataCol",
                                style: TextStyle(
                                  color: Color(0xff5b5b5b),
                                  fontSize: 40,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Data Collected",
                                    style: TextStyle(
                                      color: Color(0xff5b5b5b),
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    "More Information",
                                    style: TextStyle(
                                      color: Color(0xff30cbef),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: deviceHeight * 0.04,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.04,
                          ),
                          OutlineButton(
                            child: Text("Contact Us"),
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            onPressed: null,
                          ),
                          FlatButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.2),
                            onPressed: _logout,
                            color: Color(0xffFC8D87),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              "Log Out",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: deviceWidth * 0.4,
                    width: deviceWidth * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        height: deviceWidth * 0.36,
                        width: deviceWidth * 0.36,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Color(0xff000000).withOpacity(0.15),
                                spreadRadius: 2,
                              ),
                            ],
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/images/avatar.png'),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
