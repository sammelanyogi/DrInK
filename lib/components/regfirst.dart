import 'package:flutter/material.dart';

class RegisterFirst extends StatefulWidget {
  RegisterFirst({this.getData, this.error});
  final Function(List<String>) getData;
  final String error;
  @override
  _RegisterFirstState createState() => _RegisterFirstState();
}

enum UserType { youth, technician, general }

class _RegisterFirstState extends State<RegisterFirst> {
  UserType _userType;
  List<String> _types = ["Youth", "Tech", "General"];

  List<String> _data = [null, null, null];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Full Name',
            ),
            onChanged: (value) {
              setState(() {
                _data[0] = value;
              });
              widget.getData(_data);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Email',
              errorText: widget.error
            ),
            onChanged: (value) {
              setState(() {
                _data[1] = value;
              });
              widget.getData(_data);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              for (var option in _types)
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Radio(
                          value: UserType.values[_types.indexOf(option)],
                          groupValue: _userType,
                          onChanged: (UserType value) {
                            setState(() {
                              _userType = value;
                              print(_userType);
                            });
                            if(_userType == UserType.general){
                              _data[2]="General";
                            }
                            else if(_userType == UserType.technician){
                              _data[2]="Tech";
                            }
                            else {
                              _data[2]= "Youth";
                            }
                            widget.getData(_data);
                          },
                        ),
                      ),
                      Text(option),
                    ],
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
