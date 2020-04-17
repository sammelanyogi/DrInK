import 'package:DrInK/models/jsonwater.dart';
import 'package:DrInK/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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

List<InputData> inputs = [
  InputData(id: "ph", heading: "pH Value", textPlace: "Enter pH Value"),
  InputData(
      id: "ec",
      heading: "Electric Conductivity (EC)",
      textPlace: "Enter Electric Conductivity"),
  InputData(
      id: "temp",
      heading: "Temperature",
      textPlace: "Enter Temperature in degree celcius"),
  InputData(
      id: "tds",
      heading: "Total Dissolved Solids (TDS)",
      textPlace: "Enter TDS value"),
  InputData(
      id: "ntu", heading: "Turbidity (NTU)", textPlace: "Enter the NTU value"),
  InputData.radio(
      id: 'ecolis',
      options: ["Present", "Absent", "N/A"],
      heading: "Presence or Absence of Fecal Coliforms (E-Coli)",
      radio: true),
  InputData(
      id: "ecoli", heading: "E-Coli Count", textPlace: "Enter count value"),
  InputData(
      id: "frc",
      heading: "Free Residual Chlorine (FRC)",
      textPlace: "Enter FRC"),
  InputData.text(
      id: "other",
      heading: "Other Parameters",
      textPlace: "Specify if there are any other parameters"),
];

const waterUrl = "https://server.drinkclubs.com/waterdata";

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
  DataCol({this.water, this.successMsg});

  final VoidCallback successMsg;
  final dynamic water;

  @override
  _DataColState createState() => _DataColState();
}

class _DataColState extends State<DataCol> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String address = "", supplyChain;
  String coordinate = "";
  String obDetails;
  bool loading = false, localLoading = false;
  final storage = FlutterSecureStorage();
  TextEditingController locationCon = TextEditingController();
  TextEditingController supplyController = TextEditingController();
  TextEditingController obDetailsController = TextEditingController();
  List<TextEditingController> numController =
      List.generate(9, (i) => TextEditingController());

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  success(String sck) {
    return SnackBar(
      backgroundColor: Colors.black87,
      content: Text(
        sck,
        style:
            TextStyle(color: Colors.green, fontSize: 18, fontFamily: 'Myriad'),
      ),
      action: SnackBarAction(
        label: "Okay",
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }

  snackError(String sck) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        sck,
        style: TextStyle(color: Colors.red, fontSize: 18, fontFamily: 'Myriad'),
      ),
      action: SnackBarAction(
        label: "Okay",
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }

  String useremail, userpassword;
  int dataCollected;

  @override
  void initState() {
    if (widget.water != null) {
      locationCon.text = widget.water['status']['location'];
      address = widget.water['status']['location'];
      coordinate = widget.water['status']['coordinates'];
      supplyController.text = widget.water['status']['supplyChain'];
      obDetailsController.text = widget.water['param']['details'];
      numController[0].text = widget.water['waterParam']['ph'];
      numController[1].text = widget.water['waterParam']['ec'];
      numController[2].text = widget.water['waterParam']['temp'];
      numController[3].text = widget.water['waterParam']['tds'];
      numController[4].text = widget.water['waterParam']['ntu'];
      numController[5].text = widget.water['waterParam']['ecolis'];
      numController[6].text = widget.water['waterParam']['ecoli'];
      numController[7].text = widget.water['waterParam']['frc'];
      numController[8].text = widget.water['waterParam']['other'];
    }
    supplyController.addListener(() {});
    obDetailsController.addListener(() {});
    for (int i in [0, 1, 2, 3, 4, 6, 7]) {
      numController[i].addListener(() {
        if (numController[i].text.trim() != "") {
          if (double.tryParse(numController[i].text) != null) {
            setState(() {
              error[i] = null;
            });
          } else {
            setState(() {
              error[i] = "Must be a numeric value";
            });
          }
        }
      });
    }

    numController[8].addListener(() {
      setState(() {});
    });
    numController[5].addListener(() {
      setState(() {});
    });

    locationCon.addListener(() {
      address = locationCon.text;
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var data = await storage.read(key: 'drinkUserInfo');
      useremail = json.decode(data)['email'];
      userpassword = json.decode(data)['password'];
      dataCollected = json.decode(data)['dataCollected'];
    });
  }

  @override
  void dispose() {
    locationCon.dispose();
    supplyController.dispose();
    obDetailsController.dispose();
    for (int i = 0; i < 9; i++) {
      numController[i].dispose();
    }
    super.dispose();
  }

  bool numdatavalidation = true;
  http.Response dataB;
  String base64Image;
  List error = List(9);
  var waterdata;
  Position _currentPosition;

  saveData() async {
    Navigator.of(context).pop();
    setState(() {
      localLoading = true;
    });

    if (_currentPosition != null) {
      coordinate = _currentPosition.latitude.toString() +
          ',' +
          _currentPosition.longitude.toString();
    }
    if (locationCon.text.trim() == "" || coordinate.trim() == "") {
      setState(() {
        localLoading = false;
      });
      _scaffoldKey.currentState
          .showSnackBar(snackError("Please set location."));
      return;
    }
    waterdata = {
      'status': {
        'coordinates': coordinate,
        'location': address,
        'supplyChain': supplyController.text
      },
      'param': {
        'details': obDetailsController.text,
        'image': base64Image == null ? "" : base64Image
      },
      'waterParam': {
        'ph': numController[0].text,
        'ec': numController[1].text,
        'temp': numController[2].text,
        'tds': numController[3].text,
        'ntu': numController[4].text,
        'ecolis': numController[5].text,
        'ecoli': numController[6].text,
        'frc': numController[7].text,
        'other': numController[8].text
      },
      'createdAt': DateTime.now().toString()
    };
    var i;
    if (widget.water == null) {
      WaterData water = WaterData(jsonWater: json.encode(waterdata));
      i = await databaseHelper.insertWater(water);
      print(i);
    }

    if (widget.water != null) {
      WaterData water =
          WaterData(id: widget.water['id'], jsonWater: json.encode(waterdata));
      i = await databaseHelper.updateWater(water);
      print(i);
    }
    if (i >= 0) {
      _scaffoldKey.currentState
          .showSnackBar(success("Data Saved Successfully."));
    } else {
      _scaffoldKey.currentState.showSnackBar(snackError("Error Saving Data."));
    }
    setState(() {
      localLoading = false;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Save Data?"),
          content: new Text("Are you sure you want to save this data locally?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                saveData();
              },
            ),
          ],
        );
      },
    );
  }

  submitData() async {
    address = locationCon.text;
    if (error.where((test) => test != null).length != 0) {
      _scaffoldKey.currentState
          .showSnackBar(snackError("Check for Error in data."));
      return;
    }
    for (int i = 0; i < 0; i++) {
      if (!isNumeric(numController[i].text)) {
        numdatavalidation = false;
      }
    }
    setState(() {
      loading = true;
    });
    if (_image != null) base64Image = base64Encode(_image.readAsBytesSync());

    if (_currentPosition != null) {
      coordinate = _currentPosition.latitude.toString() +
          ',' +
          _currentPosition.longitude.toString();
    }
    if (!numdatavalidation ||
        useremail == null ||
        address == null ||
        address.trim() == "" ||
        supplyController.text == null ||
        supplyController.text.trim() == "" ||
        obDetailsController.text == null ||
        obDetailsController.text.trim() == "") {
      setState(() {
        loading = false;
      });

      _scaffoldKey.currentState
          .showSnackBar(snackError("Enter all data. Cannot submit now."));
      return;
    } else {
      dataB = await submitWholeData(waterUrl, {
        'waterdata': {
          'status': {
            'coordinates': coordinate,
            'location': address,
            'supplyChain': supplyController.text
          },
          'param': {
            'details': obDetailsController.text,
            'image': base64Image == null ? "" : base64Image
          },
          'waterParam': {
            'ph': numController[0].text,
            'ec': numController[1].text,
            'temp': numController[2].text,
            'tds': numController[3].text,
            'ntu': numController[4].text,
            'ecolis': numController[5].text,
            'ecoli': numController[6].text,
            'frc': numController[7].text,
            'other': numController[8].text
          },
          'user': {'email': useremail},
          'createdAt': widget.water == null
              ? DateTime.now().toString()
              : widget.water['createdAt']
        },
        'password': userpassword,
        'dataCollected': dataCollected,
      });
      setState(() {
        loading = false;
      });
      if (dataB == null) {
        _scaffoldKey.currentState.showSnackBar(snackError("Server Error."));
      } else if (dataB.statusCode == 200) {
        if (widget.water != null) {
          await databaseHelper.deleteWater(widget.water['id']);
          Navigator.pop(context);
          widget.successMsg();
        }
        _image = null;
        for (var i in numController) {
          i.text = "";
        }

        _scaffoldKey.currentState
            .showSnackBar(success("Data Submitted Successfully."));
      } else {
        print(dataB.statusCode);
        _scaffoldKey.currentState
            .showSnackBar(snackError("Unknown Error Occurred"));
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    Position position = await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    _currentPosition = position;
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
      Coordinates(position.latitude, position.longitude),
    );
    locationCon.text =
        "${addresses.first.featureName}, ${addresses.first.locality}";
    setState(() {
      coordinate = "${position.latitude}, ${position.longitude}";
    });
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
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Data Collection',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
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
                        horizontal: statusBarHeight * 0.5,
                        vertical: statusBarHeight * 0.5),
                    child: Text(
                      "Status Parameters",
                      style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: statusBarHeight * 0.5,
                        horizontal: statusBarHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Survey Location",
                          style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
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
                              onPressed: _getCurrentLocation,
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
                        horizontal: statusBarHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Coordinates: [$coordinate]",
                          style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: statusBarHeight * 0.5,
                        horizontal: statusBarHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Water Supply Chain",
                          style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        TextFormField(
                          controller: supplyController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText:
                                "eg. Nepal Water Supply Corporation (NWSC)",
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
                        horizontal: statusBarHeight * 0.5,
                        vertical: statusBarHeight * 0.5),
                    child: Text(
                      "Observation Parameters",
                      style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: statusBarHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: statusBarHeight * 0.5),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: statusBarHeight * 0.5),
                                      child: Text(
                                        "Select Image",
                                        style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: deviceWidth * 0.8,
                                        maxHeight: deviceHeight * 0.35,
                                      ),
                                      child: _image == null
                                          ? Text("No Image Selected.")
                                          : Image.file(_image),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.image),
                                          onPressed: getImageFromGallery,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add_a_photo),
                                          onPressed: openCameraForImage,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              _image = null;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              "Observation Details",
                              style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: obDetailsController,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: statusBarHeight * 0.5,
                        vertical: statusBarHeight * 0.5),
                    child: Text(
                      "Water Quality parameters",
                      style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
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
                        error: error[index],
                        contro: numController[index],
                        id: inputs[index].id,
                        textPlace: inputs[index].textPlace,
                        heading: inputs[index].heading,
                        radio: inputs[index].radio == null ? false : true,
                        options: inputs[index].radio == null
                            ? []
                            : inputs[index].options,
                        keyboardType: inputs[index].text,
                      );
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton.icon(
                            color: Colors.blueGrey,
                            icon: localLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Icon(
                                    Icons.save,
                                    color: Colors.white,
                                  ),
                            label: Text(
                              "Save Locally",
                              style: TextStyle(
                                  fontFamily: 'Myriad',
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            onPressed: _showDialog,
                          ),
                          FlatButton.icon(
                            color: Colors.green,
                            icon: loading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Icon(
                                    IconData(
                                      0xf382,
                                      fontFamily: CupertinoIcons.iconFont,
                                      fontPackage:
                                          CupertinoIcons.iconFontPackage,
                                    ),
                                    color: Colors.white,
                                  ),
                            label: Text(
                              "Submit",
                              style: TextStyle(
                                  fontFamily: 'Myriad',
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            onPressed: submitData,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
