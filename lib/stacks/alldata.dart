import 'package:DrInK/models/jsonwater.dart';
import 'package:DrInK/screen/data.dart';
import 'package:DrInK/stacks/datadetails.dart';
import 'package:DrInK/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

const apiUrl = "https://server.drinkclubs.com/metadata/waterdata";

Future<http.Response> dataApi(String url, Map jsonMap) async {
  http.Response response;
  print(json.encode(jsonMap));
  try {
    response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: utf8.encode(
        json.encode(jsonMap),
      ),
    );
  } catch (e) {
    print(e.toString());
    response = null;
  }
  return response;
}

class AllData extends StatefulWidget {
  AllData({this.email, this.password});

  final String email, password;

  @override
  _AllDataState createState() => _AllDataState();
}

class _AllDataState extends State<AllData> {
  http.Response response;
  List<WaterData> waterlist;
  DatabaseHelper helper = DatabaseHelper();
  String footer;
  Color color;
  List waterData;
  List onlineData = [];
  var savedData;
  final year = new DateFormat('yyyy-MM-dd');
  final clock = new DateFormat.Hm();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      refreshList();
    });
  }

  showSuccess() {
    setState(() {
      color = Colors.green;
      footer = "Data Saved Successfully.";
    });
  }

  var temp;

  edit(dynamic water) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataCol(water: water, successMsg: showSuccess),
      ),
    );
  }

  Future<void> refreshList() async {
    waterlist = await helper.getWaterList();
    savedData = List(waterlist.length);
    for (var i = 0; i < waterlist.length; i++) {
      temp = json.decode(waterlist[i].jsonWater);
      temp['id'] = waterlist[i].id;
      savedData[i] = temp;
      print(savedData[i]);
    }
    response = await dataApi(apiUrl, {
      'email': widget.email,
      'password': widget.password,
    });
    if (response != null) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        onlineData = json.decode(response.body)['data'];
        setState(() {
          footer = null;
          color = null;
          waterData = [...onlineData, ...savedData];
        });
      } else {
        setState(() {
          color = null;
          footer = "Internal server error.";
          waterData = savedData;
        });
      }
    } else {
      setState(() {
        color = null;
        footer = "Please check your internet Connection.";
        waterData = savedData;
      });
    }
  }

  void openData(int ind) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataDetail(
          data: waterData[ind],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: <Widget>[
        footer != null
            ? Text(
                footer,
                style: TextStyle(color: color != null ? color : Colors.red),
              )
            : null
      ],
      appBar: AppBar(
        backgroundColor: Color(0xff30cbef),
        title: Text(
          "All Submitted Data",
          style: TextStyle(
              fontFamily: 'Gilroy', color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: Container(
            child: waterData == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: waterData.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).padding.top * 0.5,
                            vertical: MediaQuery.of(context).padding.top * 0.25,
                          ),
                          elevation: 1,
                          child: ListTile(
                            leading: !onlineData.contains(
                                    waterData[waterData.length - index - 1])
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      IconData(
                                        0xf459,
                                        fontFamily: CupertinoIcons.iconFont,
                                        fontPackage:
                                            CupertinoIcons.iconFontPackage,
                                      ),
                                      color: Colors.white,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      IconData(
                                        0xf3ff,
                                        fontFamily: CupertinoIcons.iconFont,
                                        fontPackage:
                                            CupertinoIcons.iconFontPackage,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                            title: Text(
                              "${waterData[waterData.length - index - 1]['status']['location']}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  color: Colors.black45),
                            ),
                            subtitle: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text:
                                      "${year.format(DateTime.parse(waterData[waterData.length - index - 1]['createdAt']))} |",
                                  style: TextStyle(
                                    fontFamily: 'Myriad',
                                    color: Colors.black45,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " ${clock.format(DateTime.parse(waterData[waterData.length - index - 1]['createdAt']))} ",
                                  style: TextStyle(
                                    fontFamily: 'Myriad',
                                    color: Colors.blue,
                                  ),
                                ),
                                !onlineData.contains(
                                        waterData[waterData.length - index - 1])
                                    ? TextSpan(
                                        text: " | Not Submitted.",
                                        style: TextStyle(
                                          fontFamily: 'Myriad',
                                          color: Colors.red,
                                        ),
                                      )
                                    : TextSpan(),
                              ]),
                            ),
                            onTap: () {
                              if (!onlineData.contains(
                                  waterData[waterData.length - index - 1])) {
                                edit(waterData[waterData.length - index - 1]);
                              } else {
                                openData(waterData.length - index - 1);
                              }
                            },
                          ));
                    },
                  )),
      ),
    );
  }
}
