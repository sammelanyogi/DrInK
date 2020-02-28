import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'stacks/loginpage.dart';
import 'stacks/registerpage.dart';

const loginUrl = "https://server.omhit.com/login";

class LoginPage extends StatefulWidget {
  LoginPage({this.signedIn});
  final VoidCallback signedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

Future<http.Response> loginRequest(String url, Map jsonMap) async {
  http.Response response;
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

class _LoginPageState extends State<LoginPage> {
  http.Response loginReturn;
  int userType = 3;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  Future<int> checkForCredentials(List<String> credentials) async {
    loginReturn = await loginRequest(
        loginUrl, {'email': credentials[0], 'password': credentials[1]});
    if (loginReturn == null) {
      return 1000;
    }
    print(loginReturn.body);
    print("The Status code is " + loginReturn.statusCode.toString());
    if (loginReturn.statusCode == 200) {
      _goToMain();
    }
    return loginReturn.statusCode;
  }

  void _goToMain() {
    widget.signedIn();
  }

  void socialTypeGoogle() {
    showAlertDialog("Google");
  }

  void socialTypeFacebook() {
    showAlertDialog("Facebook");
  }

  void showAlertDialog(String socialType) {
    Widget youth = FlatButton(
      child: Text("Youth"),
      onPressed: () {
        setState(() {
          userType = 0;
        });
        Navigator.of(context).pop();
        continueWithSocial(socialType);
      },
    );
    Widget technician = FlatButton(
      child: Text("Technician"),
      onPressed: () {
        setState(() {
          userType = 1;
        });
        Navigator.of(context).pop();
        continueWithSocial(socialType);
      },
    );
    Widget general = FlatButton(
      child: Text("General User"),
      onPressed: () {
        setState(() {
          userType = 2;
        });
        Navigator.of(context).pop();
        continueWithSocial(socialType);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Select User Type"),
      content: Text("Select which of the type of user are you?"),
      actions: [
        youth,
        technician,
        general,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> continueWithSocial(String type) async {
    if (type == "Google") {
      try {
        await _googleSignIn.signIn();
        print("Sammelan");
      } catch (err) {
        print(err);
      }
    } else if (type == "Facebook") {
      _goToMain();
    }
  }

  void goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(
            checkCredentials: checkForCredentials, goToRegister: goToRegister),
      ),
    );
  }

  void goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register(goToLogin: goToLogin)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: paddingTop,
            ),
            SizedBox(
              height: deviceHeight * 0.1,
            ),
            Container(
              height: deviceWidth * 0.4,
              width: deviceWidth * 0.4,
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
                  fit: BoxFit.scaleDown,
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            SizedBox(height: deviceHeight * 0.06),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: deviceWidth * 0.65,
                    child: OutlineButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/images/google.png'),
                            height: 18,
                            width: 18,
                          ),
                          Text(
                            "  Continue with Google",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: socialTypeGoogle,
                    ),
                  ),
                  SizedBox(
                    width: deviceWidth * 0.65,
                    child: OutlineButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/images/facebook.jpg'),
                            height: 18,
                            width: 18,
                          ),
                          Text(
                            "  Continue with Facebook",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: socialTypeFacebook,
                    ),
                  ),
                  SizedBox(
                    child: Divider(color: Colors.black.withOpacity(0.3)),
                    width: deviceWidth * 0.7,
                    height: deviceHeight * 0.06,
                  ),
                  FlatButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: deviceWidth * 0.1,
                      ),
                      child: Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: goToRegister,
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  Padding(
                    child: Text(
                      "Already Have an Account?",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    padding: EdgeInsets.only(top: deviceHeight * 0.04),
                  ),
                  FlatButton(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: goToLogin,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: paddingTop),
                  child: Text(
                    "DrInK - Drinking Information Kit",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
