import 'package:flutter/material.dart';

class RegisterLast extends StatefulWidget {
  RegisterLast({this.getData});
  final Function(List<String>) getData;
  @override
  _RegisterLastState createState() => _RegisterLastState();
}

class _RegisterLastState extends State<RegisterLast> {
  List<String> _data;
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
              setState(() {
                _data[0] = value;
              });
              widget.getData(_data);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Verify Password',
            ),
            obscureText: !_passwordVisible,
            onChanged: (value) {
              setState(() {
                _data[1] = value;
              });
              widget.getData(_data);
            },
          ),
        ],
      ),
    );
  }
}
