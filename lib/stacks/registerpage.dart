import 'package:flutter/material.dart';
import '../components/buildlogo.dart';

class Register extends StatefulWidget {
  Register({this.goToLogin});
  final VoidCallback goToLogin;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;

    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: paddingTop*1.5,
              ),
              BuildLogo(),
              SizedBox(height: deviceHeight * 0.06),
              Container(
                padding: EdgeInsets.only(bottom: paddingTop),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                      ),
                    ),
                  ],
                ),
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(horizontal: deviceHeight * 0.1),
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                onPressed: (){},
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
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                padding: EdgeInsets.only(top: deviceHeight * 0.02),
              ),
              FlatButton(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueAccent,
                  ),
                ),
                onPressed: (){
                  Navigator.pop(context);
                  widget.goToLogin();
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
