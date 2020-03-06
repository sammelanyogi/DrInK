import 'package:DrInK/components/footer.dart';
import 'package:flutter/material.dart';
import '../components/buildlogo.dart';
import '../components/question.dart';

class Login extends StatefulWidget {
  Login({this.checkCredentials, this.goToRegister});
  final Function(List<String>) checkCredentials;
  final VoidCallback goToRegister;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _loading = false;
  int statusCode;
  String _error;
  bool _passwordVisible = false;
  _togglePass() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _login() async {
    statusCode = await widget.checkCredentials([email, password]);
    setState(() {
      _loading = false;
    });
    if (statusCode == 1000) {
      print("connection error");
      SnackBar snackBar = SnackBar(
          content: Text("Please Connect to the internet."),
          action: SnackBarAction(
            label: "Okay",
            onPressed: () {},
          ));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    if (statusCode == 400 || statusCode == 401) {
      print("There was an error");
      _error = "Error in Email or Password.";
    }

    if (statusCode == 200) {
      Navigator.pop(context);
    }
  }

  String email, password;
  final emailControl = TextEditingController();
  final passControl = TextEditingController();
  void _getValues() {
    setState(() {
      email = emailControl.text;
      password = passControl.text;
    });
  }

  void createAccountController() {}
  @override
  void dispose() {
    emailControl.dispose();
    passControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailControl.addListener(_getValues);
    passControl.addListener(_getValues);
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailControl,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _error = null;
                        });
                      },
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passControl,
                        decoration: InputDecoration(
                          errorText: _error,
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: _togglePass,
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        onChanged: (value) {
                          setState(() {
                            _error = null;
                          });
                        }),
                  ],
                ),
              ),
              FlatButton(
                child: Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onPressed: null,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(horizontal: deviceHeight * 0.1),
                child: _loading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                onPressed: () {
                  setState(() {
                    _loading = true;
                  });
                  _login();
                },
                color: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              SizedBox(
                child: Divider(color: Colors.black.withOpacity(0.3)),
                width: MediaQuery.of(context).size.width * 0.7,
                height: deviceHeight * 0.04,
              ),
              Question(
                question: "Don't have an account yet?",
              ),
              FlatButton(
                child: Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.goToRegister();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          Footer(text: "DrInK - Drinking Water Information Kit"),
    );
  }
}
