import 'package:flutter/material.dart';
import '../stacks/profilesetting.dart';

class Profile extends StatefulWidget {
  Profile({this.logout});
  final VoidCallback logout;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _logout() {
    widget.logout();
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Settings(),
                          ));
                    },
                  ),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 65.0, bottom: deviceHeight > deviceWidth? 0: paddingTop*3),
                    height: deviceHeight > deviceWidth
                        ? deviceHeight * 0.6
                        : deviceWidth*0.8,
                    width: deviceHeight > deviceWidth? deviceWidth - paddingTop * 2: deviceWidth-paddingTop*6,
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
                            "Jane Doe",
                            style: TextStyle(
                              color: Color(0xfff7931e),
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "Youth",
                            style: TextStyle(
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
                                "95",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "Data Not Synced",
                                style: TextStyle(
                                  color: Color(0xffe0342f),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "Sync Data",
                                style: TextStyle(
                                  color: Color(0xff39bf4a),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: deviceHeight * 0.04,
                          ),
                          OutlineButton(
                            child: Text("Contact Us"),
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: null,
                          ),
                          FlatButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.2),
                            onPressed: _logout,
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                                color: Color(0xff000000).withOpacity(0.2),
                                spreadRadius: 2,
                              ),
                            ],
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
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
