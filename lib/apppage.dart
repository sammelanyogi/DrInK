import 'package:flutter/material.dart';
import './components/InputData.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'screen/profile.dart';
import 'screen/home.dart';
import 'screen/data.dart';

List<InputData> inputs = [
  InputData(id: "ph", heading: "pH Value", textPlace: "Enter pH Value"),
  InputData(
      id: "ec",
      heading: "Electric Conductivity (EC)",
      textPlace: "Enter Electric Conductivity"),
  InputData(
      id: "temp",
      heading: "Temperature",
      textPlace: "Enter Temperature in degree celcius"),
  InputData(
      id: "tds",
      heading: "Total Dissolved Solids (TDS)",
      textPlace: "Enter TDS value"),
  InputData(
      id: "ntu", heading: "Turbidity (NTU)", textPlace: "Enter the NTU value"),
  InputData(
      id: "ecoli", heading: "E-Coli Count", textPlace: "Enter count value"),
  InputData(
      id: "frc",
      heading: "Free Residual Chlorine (FRC)",
      textPlace: "Enter FRC"),
  InputData.text(
      id: "other",
      heading: "Other Parameter",
      textPlace: "Specify if there are any other parameters"),
];

class AppPage extends StatefulWidget {
  AppPage({this.logout});
  final VoidCallback logout;
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  void _logout() {
    widget.logout();
  }

  Widget buildFloatingButton() {
    if (keyboardOpen) {
      return SizedBox();
    }
    return _selectedIndex == 1
        ? SizedBox()
        // FloatingActionButton.extended(
        //   onPressed: submitData,
        //   label: Text("Submit"),
        //   icon: Icon(Icons.send),
        //   backgroundColor: Colors.green,
        // )
        : FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
                _myPage.jumpToPage(1);
              });
            },
            label: Text("Enter Data"),
            icon: Icon(Icons.add),
            backgroundColor: Color(0xff30cbef),
          );
  }

  Map<String, dynamic> allDatas;
  bool keyboardOpen = false;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() => keyboardOpen = visible);
      },
    );
  }

  waterParameters(Map<String, dynamic> parameters) {
    allDatas = parameters;
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
        onPageChanged: (int) {
          print('Page Changes to index $int');
        },
        children: <Widget>[
          Home(),
          DataCol(
            scakey: _scaffoldKey,
            inputs: inputs,
            waterParameters: waterParameters,
          ),
          Profile(logout: _logout),
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
              icon: Icon(Icons.home),
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
              icon: Icon(Icons.person),
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
