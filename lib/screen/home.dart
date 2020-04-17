import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class WaterInfo {
  String title;
  String subtitle;
  String description;
  WaterInfo({this.title, this.subtitle, this.description});
}

List<WaterInfo> waterInfo = [
  WaterInfo(
    title: "ph",
    subtitle: "For Normal Water: 6.5-8.5",
    description:
        "The pH of pure water is 7. In general, water with a pH lower than 7 is considered acidic, and with a pH greater than 7 is considered basic. The normal range for pH in surface water systems is 6.5 to 8.5, and the pH range for groundwater systems is between 6 to 8.5.",
  ),
  WaterInfo(
    title: "Electrical Conductivity",
    subtitle: "",
    description:
        "EC or Electrical Conductivity of water is its ability to conduct an electric current. Salts or other chemicals that dissolve in water can break down into positively and negatively charged ions. These free ions in the water conduct electricity, so the water electrical conductivity depends on the concentration of ions.",
  ),
  WaterInfo(
    title: "Turbidity Range",
    description:
        "Many drinking water utilities strive to achieve levels as low as 0.1 NTU. The European standards for turbidity state that it must be no more than 4 NTU. The World Health Organization, establishes that the turbidity of drinking water should not be more than 5 NTU, and should ideally be below 1 NTU.",
  ),
  WaterInfo(
    title: "Total Dissolved Solids",
    description:
        "TDS are dissolved organic and inorganic substances in water. The lesser level is better for drinking. But an average TDS level of drinking water can be 300 - 500 mg/liter. If reading is more than that I suggest you don't drink that water.",
  ),
  WaterInfo(
    title: "Ecoli in water",
    description:
        "E. coli is currently the most reliable indicator of fecal bacterial contamination of surface waters in the U.S. according to water quality standards set by the EPA. EPA bacterial water quality standards are based on a level of E. coli in water above which the health risk from waterborne illness is unacceptably high.",
  ),
  WaterInfo(
    title: "Free Residual Chlorine",
    description:
        "Presence of FRC in water ensures germ-free water for consumption. Low FRC value (less than 0.2mg per litre) means incomplete destruction of germs in water making it unsafe for drinking.",
  )
];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _openLearnMore() async {
    const homeUrl = 'https://drinkclubs.com';
    if (await canLaunch(homeUrl)) {
      await launch(homeUrl);
    } else {
      throw 'Could not launch $homeUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 5,
            title: Row(
              children: <Widget>[
                Image(
                  image: AssetImage('assets/icon/logo.png'),
                  height: 25,
                ),
                Text(
                  "rink",
                  style: TextStyle(
                    fontFamily: 'VagBold',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff30cbef),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              IconButton(
                onPressed: null,
                iconSize: 30,
                icon: Icon(
                  IconData(
                    0xf2d9,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage,
                  ),
                  color: Colors.black54,
                ),
              )
            ],
            floating: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.only(top: paddingTop * 0.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0.5,
                        color: Color(0xff000000).withOpacity(0.2),
                        spreadRadius: 0.5,
                      ),
                    ],
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/cover.png'),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: paddingTop,
                      left: paddingTop,
                      right: paddingTop,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white.withOpacity(0.6), Colors.white],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Welcome",
                              style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'Gilroy',
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              "to DrInK",
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Drinking Water Information Kit",
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: paddingTop * 0.5),
                          child: Text(
                            "This platform is designed to collect, store, transfer and share information on drinking water supply and quality monitoring.",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: paddingTop),
                          child: FlatButton(
                            onPressed: _openLearnMore,
                            color: Colors.green,
                            child: Text(
                              "Learn more about DrInK",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: paddingTop * 0.5),
                  physics: ClampingScrollPhysics(),
                  separatorBuilder: (context, ind) {
                    return SizedBox(
                      height: paddingTop * 0.5,
                    );
                  },
                  shrinkWrap: true,
                  itemCount: waterInfo.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: paddingTop,
                          vertical: paddingTop,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0.5,
                              color: Color(0xff000000).withOpacity(0.2),
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${waterInfo[index].title}",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                            Text(
                              "${waterInfo[index].description}",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18,
                                  fontFamily: 'Gilroy'),
                            ),
                          ],
                        ));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
