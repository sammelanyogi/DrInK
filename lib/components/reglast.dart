import 'package:flutter/material.dart';

class RegisterLast extends StatefulWidget {
  RegisterLast({this.getPassData, this.error});
  final String error;
  final Function(List<String>) getPassData;
  @override
  _RegisterLastState createState() => _RegisterLastState();
}

class _RegisterLastState extends State<RegisterLast> {
  List<String> pass;
  String pass1, pass2;
  String error;
  bool _passwordVisible = false;
  _togglePass() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.top),
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Choose a Password',
              suffixIcon: IconButton(
                onPressed: _togglePass,
                icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            obscureText: !_passwordVisible,
            onChanged: (value) {
              pass1= value;
              widget.getPassData([pass1, pass2]);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                hintText: 'Verify Password', errorText: widget.error),
            obscureText: !_passwordVisible,
            onChanged: (value) {
              pass2= value;
              widget.getPassData([pass1, pass2]);
            },
          ),
        ],
      ),
    );
  }
}
