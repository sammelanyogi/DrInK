import 'package:DrInK/components/socialbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'components/buildlogo.dart';
import 'components/question.dart';
import 'stacks/loginpage.dart';
import 'stacks/registerpage.dart';

const loginUrl = "https://server.drinkclubs.com/login";
const googleSign = "https://server.drinkclubs.com/socialuser";

Future<http.Response> loginRequest(String url, Map jsonMap) async {
  http.Response response;
  try {
    response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jsonMap),
    );
  } catch (e) {
    print(e.toString());
    response = null;
  }
  return response;
}

class LoginPage extends StatefulWidget {
  LoginPage({this.signedIn, this.userData});

  final VoidCallback signedIn;
  final Function(List<String>) userData;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  var loginReturn, googleReturn, fbReturn;
  final storage = FlutterSecureStorage();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      "https://www.googleapis.com/auth/userinfo.profile",
    ],
  );
  FacebookLogin fbLogin = FacebookLogin();

  checkForCredentials(List<String> credentials) async {
    loginReturn = await loginRequest(
      loginUrl,
      {'email': credentials[0], 'password': credentials[1]},
    );
    if (loginReturn == null) {
      return 1000;
    }
    if (loginReturn.statusCode == 200) {
      storage.write(key: 'drinkUserInfo', value: loginReturn.body);
      widget.signedIn();
    }
    return loginReturn.statusCode;
  }

  SnackBar goSnack(String snackString) {
    return SnackBar(
        content: Text(snackString),
        action: SnackBarAction(
          label: "Okay",
          onPressed: () {},
        ));
  }

  socialTypeGoogle() async {
    var googleData = await _googleSignIn.signIn();
    if (googleData == null) {
      _scaffoldKey.currentState.showSnackBar(goSnack("Network Error."));
      return;
    }
    setState(() {
      loading = true;
    });
    googleReturn = await loginRequest(googleSign, {
      'email': googleData.email,
      'name': googleData.displayName,
      'type': "General",
      'photo': googleData.photoUrl,
      'social': 'google'
    });
    setState(() {
      loading = false;
    });
    if (googleReturn == null) {
      _scaffoldKey.currentState.showSnackBar(goSnack("Network Error."));
    } else if (googleReturn.statusCode == 400) {
      _scaffoldKey.currentState.showSnackBar(goSnack("Server Error."));
    } else if (googleReturn.statusCode == 200) {
      print(googleReturn.body.toString());
      storage.write(key: 'drinkUserInfo', value: googleReturn.body);
      widget.signedIn();
    } else {
      _scaffoldKey.currentState.showSnackBar(goSnack("Unknown Server Error."));
    }
  }

  void socialTypeFacebook() async {
    var fbData = await fbLogin.logIn(['email', 'public_profile']);
    switch (fbData.status) {
      case FacebookLoginStatus.error:
        _scaffoldKey.currentState.showSnackBar(goSnack("Facebook Error."));
        break;
      case FacebookLoginStatus.cancelledByUser:
        _scaffoldKey.currentState.showSnackBar(goSnack("Cancelled by user."));
        break;
      case FacebookLoginStatus.loggedIn:
        {
          setState(() {
            loading = true;
          });
          var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,email,picture.width(400)&access_token=${fbData.accessToken.token}',
          );
          if (graphResponse == null) {
            print("cannot continue with facebook");
          } else {
            var profile = json.decode(graphResponse.body);
            print(profile.toString());
            fbReturn = await loginRequest(googleSign, {
              'email': profile['email'],
              'name': profile['name'],
              'type': "General",
              'photo': profile['picture']['data']['url'],
              'social': 'facebook'
            });
            setState(() {
              loading = false;
            });
            if (fbReturn == null) {
              _scaffoldKey.currentState.showSnackBar(goSnack("Network Error."));
            } else if (fbReturn.statusCode == 400) {
              _scaffoldKey.currentState.showSnackBar(goSnack("Server Error."));
            } else if (fbReturn.statusCode == 200) {
              print(fbReturn.body.toString());
              storage.write(key: 'drinkUserInfo', value: fbReturn.body);
              widget.signedIn();
            } else {
              _scaffoldKey.currentState
                  .showSnackBar(goSnack("Unknown Server Error."));
            }
          }
        }
        break;
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
      MaterialPageRoute(
        builder: (context) => Register(
          goToLogin: goToLogin,
          scakey: _scaffoldKey,
        ),
      ),
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
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white70,
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
                    fontFamily: 'Myriad',
                    fontSize: 18,
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
                    fontFamily: 'Myriad',
                    fontSize: 24,
                    color: Colors.blueAccent,
                  ),
                ),
                onPressed: goToLogin,
              ),
              Container(
                child: loading ? CircularProgressIndicator() : SizedBox(),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "DrInK - Drinking Water Information Kit",
                      style: TextStyle(fontFamily: 'Myriad' ,color: Colors.black45),
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
