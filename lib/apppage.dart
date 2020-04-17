import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'screen/profile.dart';
import 'screen/home.dart';
import 'screen/data.dart';

class AppPage extends StatefulWidget {
  AppPage({this.logout});
  final VoidCallback logout;
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  bool keyboardOpen = false;
  int _selectedIndex = 0;

  Widget buildFloatingButton() {
    if (keyboardOpen) {
      return SizedBox();
    }
    return _selectedIndex == 1
        ? SizedBox()
        : FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
                _myPage.jumpToPage(1);
              });
            },
            label: Text(
              "Enter Data",
              style:
                  TextStyle(fontFamily: 'Gilroy', fontWeight: FontWeight.w500),
            ),
            icon: Icon(
              IconData(
                0xf37e,
                fontFamily: CupertinoIcons.iconFont,
                fontPackage: CupertinoIcons.iconFontPackage,
              ),
            ),
            backgroundColor: Color(0xff30cbef),
          );
  }


  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() => keyboardOpen = visible);
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _myPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    Color getColor(int index) {
      return _selectedIndex == index
          ? Colors.blue
          : Color(0xff898989).withOpacity(0.69);
    }

    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        controller: _myPage,
        children: <Widget>[
          Home(),
          DataCol(),
          Profile(logout: widget.logout),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildFloatingButton(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              color: getColor(0),
              iconSize: 35,
              padding: const EdgeInsets.all(10.0),
              icon: Icon(
                IconData(
                  0xf391,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage,
                ),
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                  _myPage.jumpToPage(0);
                });
              },
            ),
            IconButton(
              color: getColor(2),
              iconSize: 35,
              padding: const EdgeInsets.all(10.0),
              icon: Icon(
                IconData(
                  0xf419,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage,
                ),
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                  _myPage.jumpToPage(2);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
