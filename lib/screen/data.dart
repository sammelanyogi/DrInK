import 'dart:ffi';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/numdata.dart';
import 'package:flutter/material.dart';
import '../components/InputData.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:geolocator/geolocator.dart';

const waterUrl = "http://192.168.1.79:3000/waterdata";
Future<http.Response> submitWholeData(String url, Map jsonMap) async {
  http.Response response;
  print(json.encode(jsonMap));
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

class DataCol extends StatefulWidget {
  DataCol({this.scakey, this.inputs, this.waterParameters});
  final GlobalKey<ScaffoldState> scakey;
  final List<InputData> inputs;
  final Function(Map<String, dynamic>) waterParameters;
  @override
  _DataColState createState() => _DataColState();
}

String address;

class _DataColState extends State<DataCol> {
  double ph, ec, temp, tds, ntu, ecoli, frc;
  String other, ecolis;
  String address, supplyChain;
  String obDetails;
  bool loading = false;
  final storage = FlutterSecureStorage();
  void hereisData(dynamic data) {
    print("The value of ${data.id} is ${data.value}.");
    if (data.id == "ph") {
      print("HAHEHA");
      ph = double.parse(data.value);
      print(ph);
    }
    if (data.id == "ec") {
      ec = double.parse(data.value);
      print(ec);
    }
    if (data.id == "temp") {
      temp = double.parse(data.value);
      print(temp);
    }
    if (data.id == "tds") {
      tds = double.parse(data.value);
      print(tds);
    }
    if (data.id == "ntu") {
      ntu = double.parse(data.value);
      print(ntu);
    }
    if (data.id == "ecolis") {
      ecolis = data.value.toString();
      print(ecolis);
    }
    if (data.id == "ecoli") {
      ecoli = double.parse(data.value);
      print(ecoli);
    }
    if (data.id == "frc") {
      frc = double.parse(data.value);
      print(frc);
    }
    if (data.id == "other") {
      other = data.value.toString();
      print(other);
    }
  }

  http.Response dataB;
  String useremail;
  String error;
  Position _currentPosition;
  submitData() async {
    setState(() {
      loading = true;
    });
    var data = await storage.read(key: 'drinkUserInfo');
    useremail = json.decode(data)['email'];
    if (ph == null ||
        ec == null ||
        temp == null ||
        tds == null ||
        ntu == null ||
        ecoli == null ||
        frc == null ||
        other == null ||
        useremail == null ||
        address == null ||
        supplyChain == null ||
        obDetails == null) {
      setState(() {
        loading = false;
      });
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.pink,
        content: Text("Enter all data. Cannot submit now."),
        action: SnackBarAction(
          label: "Okay",
          onPressed: () {},
        ),
      );
      widget.scakey.currentState.showSnackBar(snackBar);
      error = "please fill up all data.";
    } else {
      dataB = await submitWholeData(waterUrl, {
        'status': {'location': address, 'supplyChain': supplyChain},
        'param': {'details': obDetails},
        'waterParam': {
          'ph': ph,
          'ec': ec,
          'temp': temp,
          'tds': tds,
          'ntu': ntu,
          'ecolis': ecolis,
          'ecoli': ecoli,
          'frc': frc,
          'other': other
        },
        'user': {'email': useremail}
      });
      if (dataB.statusCode == 200) {
        setState(() {
          loading = false;
        });
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text("Data Submitted Successfully."),
          action: SnackBarAction(
            label: "Okay",
            onPressed: () {},
          ),
        );
        widget.scakey.currentState.showSnackBar(snackBar);
      } else {
        setState(() {
          loading = false;
        });
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.pink,
          content: Text("There was an error while submiting data."),
          action: SnackBarAction(
            label: "Okay",
            onPressed: () {},
          ),
        );
        widget.scakey.currentState.showSnackBar(snackBar);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    Position position = await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    _currentPosition = position;
    print(_currentPosition);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(position.latitude, position.longitude));
    print(addresses.first.addressLine);
    locationCon.text =
        "${addresses.first.featureName}, ${addresses.first.locality}";
    address = "${addresses.first.featureName}, ${addresses.first.locality}";
  }

  void getTheLocation() {
    _getCurrentLocation();
  }

  File _image;

  Future getImageFromGallery() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    } catch (err) {
      print(err);
    }
  }

  TextEditingController locationCon = TextEditingController();
  Future openCameraForImage() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    List<InputData> inputs = widget.inputs;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: deviceHeight * 0.2,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Data Collection', style: GoogleFonts.merriweather(),),
            centerTitle: true,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: statusBarHeight*0.5,
                      vertical: statusBarHeight * 0.5),
                  child: Text(
                    "Status Parameters",
                    style: GoogleFonts.notoSerif(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: statusBarHeight * 0.5,
                      horizontal: statusBarHeight ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Survey Location",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: locationCon,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText:
                                    "Tap the icon if you are in the survey area.",
                              ),
                              onChanged: (value) {
                                address = value;
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: getTheLocation,
                            icon: Icon(Icons.location_searching),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: statusBarHeight * 0.5,
                      horizontal: statusBarHeight ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Water Supply Chain",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "eg. Nepal Water Supply Corporation (NWSC)",
                        ),
                        onChanged: (value) {
                          supplyChain = value;
                          print(supplyChain);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: statusBarHeight*0.5,
                      vertical: statusBarHeight * 0.5),
                  child: Text(
                    "Observation Parameters",
                    style: GoogleFonts.notoSerif(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: statusBarHeight ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Observation Details",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                maxLines: 8,
                                decoration: InputDecoration.collapsed(
                                  hintText:
                                      "Write about observation details based on colour, odour or presence of foreign elements.",
                                ),
                                onChanged: (value) {
                                  obDetails = value;
                                  print(obDetails);
                                },
                              ),
                            ),
                          ),
                          // Center(
                          //   child: Padding(
                          //     padding: EdgeInsets.symmetric(
                          //         vertical: statusBarHeight),
                          //     child: Column(
                          //       children: <Widget>[
                          //         Text(
                          //           "Select Image",
                          //           style:
                          //               TextStyle(fontWeight: FontWeight.w600),
                          //         ),
                          //         Container(
                          //           constraints: BoxConstraints(
                          //               maxWidth: deviceWidth * 0.7),
                          //           child: _image == null
                          //               ? Text("No Image Selected.")
                          //               : Image.file(_image),
                          //         ),
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: <Widget>[
                          //             IconButton(
                          //               icon: Icon(Icons.image),
                          //               onPressed: getImageFromGallery,
                          //             ),
                          //             IconButton(
                          //               icon: Icon(Icons.add_a_photo),
                          //               onPressed: openCameraForImage,
                          //             ),
                          //             IconButton(
                          //               icon: Icon(Icons.delete),
                          //               onPressed: () {
                          //                 setState(() {
                          //                   _image = null;
                          //                 });
                          //               },
                          //             ),
                          //           ],
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: statusBarHeight*0.5,
                      vertical: statusBarHeight * 0.5),
                  child: Text(
                    "Water Quality parameters",
                    style: GoogleFonts.notoSerif(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: statusBarHeight),
                  itemCount: inputs.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return NumData(
                      id: inputs[index].id,
                      textPlace: inputs[index].textPlace,
                      heading: inputs[index].heading,
                      radio: inputs[index].radio == null ? false : true,
                      options: inputs[index].radio == null
                          ? []
                          : inputs[index].options,
                      keyboardType: inputs[index].text,
                      dataBack: hereisData,
                    );
                  },
                ),
                Center(
                  child: FlatButton(
                    color: Colors.green,
                    child: loading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                    onPressed: submitData,
                  ),
                )
              ],
            )
          ]),
        ),
      ],
    );
  }
}
