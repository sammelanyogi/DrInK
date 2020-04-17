import 'package:DrInK/components/footer.dart';
import 'package:DrInK/components/question.dart';
import 'package:DrInK/components/regfirst.dart';
import 'package:DrInK/components/registerbutton.dart';
import 'package:DrInK/components/reglast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/buildlogo.dart';

const registerUrl = "https://server.drinkclubs.com/register";

Future<http.Response> registerToDrink(String url, Map jsonMap) async {
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

class Register extends StatefulWidget {
  Register({this.goToLogin, this.scakey});
  final VoidCallback goToLogin;
  final GlobalKey<ScaffoldState> scakey;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  http.Response regBack;
  String _error1;
  bool loading = false;
  String _error2;
  String fullname, email, userType, password;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  getPageData(List<String> data) {
    print(data.toString());
    fullname = data[0];
    email = data[1];
    userType = data[2];
    setState(() {
      _error1 = null;
    });
  }
  @override
  void initState(){
    super.initState();
  }

  getPassData(List<String> data) {
    if (data[1] == null || data[0] == null) {
      setState(() {
        _error2 = null;
      });
    }
    if (data[0] == data[1]) {
      password = data[0];
    } else {
      password = null;
    }
  }

  goBack() {
    setState(() {
      switcher = false;
    });
  }

  Future<void> registerData() async {
    if (password == null) {
      setState(() {
        _error2 = "Password Mismatch.";
      });
    } else if (password.length < 8) {
      setState(() {
        _error2 = "Password must be at least 8 character long.";
      });
    } else {
      setState(() {
        loading = true;
      });

      regBack = await registerToDrink(registerUrl, {
        'email': email,
        'name': fullname,
        'type': userType,
        'password': password
      });
      
      if (regBack == null) {
        print("couldnot connect");
        SnackBar snackBar = SnackBar(
            content: Text("Couldnot connect to the server."),
            action: SnackBarAction(
              label: "Okay",
              onPressed: () {},
            ));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else if (regBack.statusCode == 401) {
        setState(() {
          _error2 = "User already registered.";
          loading = false;
        });
      } else if (regBack.statusCode == 402) {
        setState(() {
          _error2 = "Cannot Connect to database.";
          loading = false;
        });
      } else if (regBack.statusCode == 200) {
        Navigator.of(context).pop();
        SnackBar snackBar = SnackBar(
            content: Text("Account created successfully. Please Verify."),
            action: SnackBarAction(
              label: "Okay",
              onPressed: () {},
            ));
        widget.scakey.currentState.showSnackBar(snackBar);
        
      }

      setState(() {
        loading = false;
      });
    }
  }


  bool switcher = false;
  void checkForError() {
    if (fullname == null ||
        email == null ||
        fullname.length == 0 ||
        email.length == 0) {
      setState(() {
        _error1 = "Name and email cannot be empty.";
        print(_error1);
      });
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      setState(() {
        _error1 = "There is an error in email field.";
      });
    } else if (userType == null) {
      setState(() {
        _error1 = "Please select user type below.";
      });
    } else {
      setState(() {
        switcher = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          width: deviceWidth,
          child: Column(
            children: [
              SizedBox(
                height: paddingTop * 3,
              ),
              BuildLogo(),
              SizedBox(height: deviceHeight * 0.06),
              !switcher
                  ? Column(
                      children: <Widget>[
                        RegisterFirst(
                          getData: getPageData,
                          error: _error1,
                        ),
                        FlatButton(
                          child: Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: checkForError,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        RegisterLast(
                          getPassData: getPassData,
                          error: _error2,
                        ),
                        RegisterButton(
                          back: goBack,
                          register: registerData,
                          loading: loading,
                        ),
                      ],
                    ),
              SizedBox(
                child: Divider(color: Colors.black.withOpacity(0.3)),
                width: MediaQuery.of(context).size.width * 0.7,
                height: deviceHeight * 0.04,
              ),
              Question(question: "Already have an Account?"),
              FlatButton(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: 'Myriad',
                    fontSize: 20,
                    color: Colors.blueAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.goToLogin();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(
        text: "DrInK - Drinking Water Information Kit",
      ),
    );
  }
}
