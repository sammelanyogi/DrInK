import 'package:DrInK/components/footer.dart';
import 'package:DrInK/components/question.dart';
import 'package:DrInK/components/regfirst.dart';
import 'package:DrInK/components/registerbutton.dart';
import 'package:DrInK/components/reglast.dart';
import 'package:flutter/material.dart';
import '../components/buildlogo.dart';

class Register extends StatefulWidget {
  Register({this.goToLogin});
  final VoidCallback goToLogin;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _error1;
  String fullname, email, userType;
  getPageData(List<String> data) {
    print(data.toString());
    fullname = data[0];
    email = data[1];
    userType = data[2];
    setState(() {
      _error1 = null;
    });
  }

  goBack() {
    setState(() {
      _firstPass = false;
    });
  }

  registerData() {}
  @override
  void initState() {
    super.initState();
    print("THis is called.");
  }

  getPassData(List<String> data) {}
  bool _firstPass = false;
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
        _firstPass = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: deviceWidth,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: paddingTop * 3,
              ),
              BuildLogo(),
              SizedBox(height: deviceHeight * 0.06),
              !_firstPass
                  ? RegisterFirst(
                      getData: getPageData,
                      error: _error1,
                    )
                  : RegisterLast(
                      getData: getPassData,
                    ),
              !_firstPass
                  ? FlatButton(
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
                  : RegisterButton(
                      back: goBack,
                      register: registerData,
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
                    fontSize: 20,
                    color: Colors.blueAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.goToLogin();
                },
              ),
              Footer(text: "DrInK - Drinking Water Information Toolkit")
            ],
          ),
        ),
      ),
    );
  }
}
