import 'package:DrInK/components/footer.dart';
import 'package:DrInK/components/socialbuttons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'components/buildlogo.dart';
import 'components/question.dart';
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
    continueWithSocial("Google");
  }

  void socialTypeFacebook() {
    continueWithSocial("Facebook");
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
          checkCredentials: checkForCredentials,
          goToRegister: goToRegister,
        ),
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/precover.jpg'),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white60,
        body: Container(
          width: deviceWidth,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: paddingTop * 3,
              ),
              BuildLogo(),
              Container(
                margin: EdgeInsets.only(top: paddingTop * 2),
                width: deviceWidth * 0.65,
                child: SocialButtons(
                  google: socialTypeGoogle,
                  facebook: socialTypeFacebook,
                ),
              ),
              SizedBox(
                child: Divider(color: Colors.black.withOpacity(0.5)),
                width: deviceWidth * 0.7,
                height: deviceHeight * 0.08,
              ),
              FlatButton(
                child: Text(
                  "Create an Account",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: goToRegister,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              Question(question: "Already have an Account?"),
              FlatButton(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blueAccent,
                  ),
                ),
                onPressed: goToLogin,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:  EdgeInsets.all(20.0),
                    child: Text(
                      "DrInK - Drinking Water Information Kit",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
