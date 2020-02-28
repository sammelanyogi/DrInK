import 'package:flutter/material.dart';
import '../components/buildlogo.dart';

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
      _error = "Username and password mismatch.";
      // SnackBar snackBar = SnackBar(
      //     content: Text("Error in username or password."),
      //     action: SnackBarAction(
      //       label: "Okay",
      //       onPressed: () {},
      //     ));
      // _scaffoldKey.currentState.showSnackBar(snackBar);
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
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: paddingTop,
              ),
              SizedBox(
                height: deviceHeight * 0.1,
              ),
              BuildLogo(),
              SizedBox(height: deviceHeight * 0.06),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailControl,
                      decoration: InputDecoration(
                        hintText: 'Phone number/Email',
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
              Padding(
                child: Text(
                  "Don't have an account yet?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                padding: EdgeInsets.only(top: deviceHeight * 0.02),
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
              Text(
                "DrInK - Drinking Information Kit",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}