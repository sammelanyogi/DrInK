import 'dart:convert';

import 'package:DrInK/stacks/alldata.dart';
import 'package:DrInK/stacks/profilesetting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:DrInK/utils/database_helper.dart';

const apiUrl = "https://server.drinkclubs.com/metadata";

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

class Profile extends StatefulWidget {
  Profile({this.logout});

  final VoidCallback logout;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final storage = FlutterSecureStorage();

  openContact() async {
    const contactUrl = 'https://drinkclubs.com/contactus';
    if (await canLaunch(contactUrl)) {
      await launch(contactUrl);
    } else {
      throw 'Could not launch $contactUrl';
    }
  }

  DatabaseHelper helper = DatabaseHelper();
  int a;
  var data, userData, response;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      data = await storage.read(key: 'drinkUserInfo');
      print(data);
      a = await helper.getCount();
      if (this.mounted) {
        setState(() {

          userData = json.decode(data);
          no = a;
        });
        
      }
    });
  }

  moreInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllData(
          email: userData['email'],
          password: userData['password'],
        ),
      ),
    );
  }

  goToSetting() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Settings(
          photo: userData['photo'],
          name: userData['name'],
        ),
      ),
    );
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int no = 0;

  Future<void> refreshPage() async {
    response = await dataApi(
      apiUrl,
      {
        'email': userData['email'],
        'password': userData['password'],
      },
    );
    if (response != null) {
      setState(() {
        userData = json.decode(response.body);
      });
    }
    if (!mapEquals(userData, json.decode(data))) {
      storage.write(key: 'drinkUserInfo', value: json.encode(userData));
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: refreshPage,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: deviceWidth * 0.33 + paddingTop * 3.1,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black54,
                  ),
                  onPressed: goToSetting,
                )
              ],
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 1,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  userData == null ? "..." : userData['name'],
                  style: GoogleFonts.poppins(
                    color: Color(0xfff7931e),
                  ),
                ),
                background: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: paddingTop * 2.5),
                    height: deviceWidth * 0.33,
                    width: deviceWidth * 0.33,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                      margin: EdgeInsets.all(deviceWidth * 0.01),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Color(0xff000000).withOpacity(0.15),
                            spreadRadius: 2,
                          ),
                        ],
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/images/avatar.png'),
                        ),
                      ),
                      child: userData != null
                          ? userData['photo'].trim()!= "" 
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(deviceWidth * 0.1),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    imageUrl: userData['photo'],
                                  ),
                                )
                              : null
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: paddingTop),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.1, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "User Type",
                            style: TextStyle(
                              color: Color(0xff5b5b5b),
                              fontFamily: 'Gilroy',
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            userData == null ? "..." : "${userData['type']}",
                            style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'Myriad',
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Data Collected",
                            style: TextStyle(
                              color: Color(0xff5b5b5b),
                              fontFamily: 'Gilroy',
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            userData == null
                                ? "..."
                                : "${userData['dataCollected']}",
                            style: TextStyle(
                              color: Color(0xff5b5b5b),
                              fontSize: 30,
                              fontFamily: 'Myriad',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Data Locally Saved",
                            style: TextStyle(
                              color: Color(0xff5b5b5b),
                              fontFamily: 'Gilroy',
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "$no",
                            style: TextStyle(
                              color: Color(0xff5b5b5b),
                              fontSize: 30,
                              fontFamily: 'Myriad',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: paddingTop),
                      child: Divider(
                        thickness: 8,
                      ),
                    ),
                    InkWell(
                      onTap: moreInfo,
                      child: ListTile(
                        leading: Icon(
                          IconData(
                            0xf44c,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage,
                          ),
                          color: Colors.blue,
                        ),
                        title: Text("Data Information"),
                      ),
                    ),
                    InkWell(
                      onTap: openContact,
                      child: ListTile(
                        leading: Icon(
                          IconData(
                            0xf3fb,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage,
                          ),
                          color: Colors.green,
                        ),
                        title: Text("Contact Us"),
                      ),
                    ),
                    InkWell(
                      onTap: openContact,
                      child: ListTile(
                        leading: Icon(
                          IconData(
                            0xf445,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage,
                          ),
                          color: Colors.orange,
                        ),
                        title: Text("About and FAQ"),
                      ),
                    ),
                    InkWell(
                      onTap: widget.logout,
                      child: ListTile(
                        leading: Icon(
                          IconData(
                            0xf385,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage,
                          ),
                          color: Colors.red,
                        ),
                        title: Text("Log Out"),
                      ),
                    ),
                    SizedBox(
                      height: deviceWidth * 0.33 + paddingTop * 3.1,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
