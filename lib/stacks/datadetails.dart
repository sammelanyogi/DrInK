import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DataDetail extends StatefulWidget {
  DataDetail({this.data});
  final Map<String, dynamic> data;
  @override
  _DataDetailState createState() => _DataDetailState();
}

class _DataDetailState extends State<DataDetail> {
  void openWaterImage(String link) async {
    var photoUrl = link;
    if (await canLaunch(photoUrl)) {
      await launch(photoUrl);
    } else {
      throw 'Could not launch $photoUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Data Details",
        style:
            TextStyle(fontFamily: 'Gilroy', color: Colors.white),
      )),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Status",
                style: TextStyle(
                    fontFamily: 'Gilroy', fontSize: 25, color: Colors.blue),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        "Location:  ${widget.data['status']['location']}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        "Coordinates: [${widget.data['status']['coordinates']}]",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        "Water Supply Chain:  ${widget.data['status']['supplyChain']}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Water Parameter:",
                style: TextStyle(
                    fontFamily: 'Gilroy', fontSize: 25, color: Colors.blue),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "pH Value: ${widget.data['waterParam']['ph']}",
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Electric Conductivity: ${widget.data['waterParam']['ec']}",
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Temperature: ${widget.data['waterParam']['temp']}",
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Total Dissolved Solids(TDS): ${widget.data['waterParam']['tds']}",
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Turbidity: ${widget.data['waterParam']['ntu']}",
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Fecal Coliforms: ${widget.data['waterParam']['ecolis']}",
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "E-Coli: ${widget.data['waterParam']['ecoli']}",
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Free Residual Chlorine: ${widget.data['waterParam']['frc']}",
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Other Parameters: ${widget.data['waterParam']['other']}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Observation:",
                style: TextStyle(
                    fontFamily: 'Gilroy', fontSize: 25, color: Colors.blue),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Details:  ${widget.data['param']['details']}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Myriad',
                            fontSize: 18,
                            color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Image:  ",
                            style: TextStyle(
                                fontFamily: 'Myriad',
                                fontSize: 18,
                                color: Colors.black54),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                if(widget.data['param']['image'].trim()!="")
                                openWaterImage(widget.data['param']['image']);
                              },
                              child: Text(
                                "${widget.data['param']['image']}",
                                // overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Myriad',
                                    fontSize: 18,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
