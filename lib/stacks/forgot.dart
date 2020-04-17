import 'package:DrInK/components/footer.dart';
import 'package:flutter/material.dart';
import 'package:DrInK/components/buildlogo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const resetUrl = "https://server.drinkclubs.com/reset-password";

Future<http.Response> resetRequest(String url, Map jsonMap) async {
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

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  http.Response resetReturn;
  bool _loading = false;
  String email;
  String _error;
  void _getValues() {
    setState(() {
      email = emailControl.text;
    });
  }

  Future<void> sendreset() async {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      setState(() {
        _error = "Please Enter a valid email.";
      });
    } else {
      setState(() {
        _loading = true;
      });
      resetReturn = await resetRequest(resetUrl, {'email': email});
      print(resetReturn.toString());
      setState(() {
        _loading = false;
      });
      if (resetReturn != null) {
        if (resetReturn.statusCode == 200) {
          SnackBar snackBar = SnackBar(
              content: Text("Recovery link sent. Check your email."),
              action: SnackBarAction(
                label: "Okay",
                onPressed: () {},
              ));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else if (resetReturn.statusCode == 400) {
          SnackBar snackBar = SnackBar(
              content: Text("Email not found. Please, sign up to DrInK."),
              action: SnackBarAction(
                label: "Okay",
                onPressed: () {},
              ));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else if (resetReturn.statusCode == 402) {
          SnackBar snackBar = SnackBar(
              content: Text("Error sending mail. Try again sometime later."),
              action: SnackBarAction(
                label: "Okay",
                onPressed: () {},
              ));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        } else if (resetReturn.statusCode == 401) {
          SnackBar snackBar = SnackBar(
              content: Text("Reset mail alreay sent. Check your mail."),
              action: SnackBarAction(
                label: "Okay",
                onPressed: () {},
              ));
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
      else{
        SnackBar snackBar = SnackBar(
              content: Text("Server Error. Try again later."),
              action: SnackBarAction(
                label: "Okay",
                onPressed: () {},
              ));
          _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

  final emailControl = TextEditingController();
  @override
  void dispose() {
    emailControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailControl.addListener(_getValues);
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar:
          Footer(text: "DrInK - Drinking Water Information Kit"),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          width: deviceWidth,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: paddingTop * 3,
              ),
              BuildLogo(),
              SizedBox(height: paddingTop * 2),
              Text(
                "Reset Password",
                style: GoogleFonts.poppins(fontSize: 25, color: Colors.black45),
              ),
              SizedBox(
                height: paddingTop * 1.5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailControl,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    errorText: _error,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _error = null;
                    });
                  },
                ),
              ),
              SizedBox(
                height: paddingTop * 1.5,
              ),
              FlatButton(
                color: Colors.green,
                child: _loading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        "Send Reset E-mail",
                        style: TextStyle(
                          fontFamily: 'Myriad',
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                onPressed: sendreset,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
