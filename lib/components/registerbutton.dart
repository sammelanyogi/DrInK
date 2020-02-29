import 'package:flutter/material.dart';

class RegisterButton extends StatefulWidget {
  RegisterButton({this.back, this.register});
  final VoidCallback back, register;
  @override
  _RegisterButtonState createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: widget.back,
            color: Colors.blue,
          ),
          FlatButton(
            child: Text(
              "Register",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: widget.register,
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }
}
