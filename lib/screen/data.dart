import '../components/numdata.dart';
import 'package:flutter/material.dart';
import '../components/InputData.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:geolocator/geolocator.dart';

class DataCol extends StatefulWidget {
  DataCol({this.submitData, this.inputs, this.waterParameters});
  final VoidCallback submitData;
  final List<InputData> inputs;
  final Function(Map<String, dynamic>) waterParameters;
  @override
  _DataColState createState() => _DataColState();
}

class _DataColState extends State<DataCol> {
  void hereisData(dynamic data) {
    print("The value of ${data.id} is ${data.value}.");
  }

  Position _currentPosition;

  void _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentPosition = position;
      print(_currentPosition.toString());
    }).catchError((e) {
      print(e);
    });
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
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: deviceHeight * 0.2,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Data Collection'),
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
                        horizontal: statusBarHeight,
                        vertical: statusBarHeight * 0.5),
                    child: Text(
                      "Status Parameters",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: statusBarHeight * 0.5,
                        horizontal: statusBarHeight * 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Survey Location",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText:
                                      "Tap the icon if you are in the survey area.",
                                ),
                                onChanged: (value) {},
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
                        horizontal: statusBarHeight * 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Water Supply Chain",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText:
                                "eg. Nepal Water Supply Corporation (NWSC)",
                          ),
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: statusBarHeight,
                        vertical: statusBarHeight * 0.5),
                    child: Text(
                      "Observation Parameters",
                      style: TextStyle(
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
                            horizontal: statusBarHeight * 1.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Observation Details",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  maxLines: 8,
                                  decoration: InputDecoration.collapsed(
                                      hintText:
                                          "Write about observation details based on colour, odour or presence of foreign elements."),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: statusBarHeight),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Select Image",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: deviceWidth * 0.7),
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: statusBarHeight,
                        vertical: statusBarHeight * 0.5),
                    child: Text(
                      "Water Quality parameters",
                      style: TextStyle(
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
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
