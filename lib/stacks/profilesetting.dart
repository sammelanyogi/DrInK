import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  Settings({this.photo, this.name});
  final String photo, name;
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.name;
    nameController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: deviceWidth / 1.6,
            actions: <Widget>[
              IconButton(
                color: Colors.black54,
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                onPressed: null,
              )
            ],
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/avatar.png'),
                  ),
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl: widget.photo,
                  errorWidget: (context, err, obj) => SizedBox(
                    height: 0,
                    width: 0,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
                vertical: paddingTop, horizontal: paddingTop * 2),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter Your Name",
                  ),
                ),
                RaisedButton(color: Colors.green,
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontFamily: 'Myriad',
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                  onPressed: (){},
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
