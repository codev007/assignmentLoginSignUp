import 'dart:async';
import 'package:flutter/material.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/views/ChooseScreen.dart';
import 'package:subset/views/MainScreen.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/views/comman/AdScreen.dart';

class FlashScreen extends StatefulWidget {
  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  bool isLogin;
  bool isVerified;
  String userID;
  String userType;
  String locationID;

  _data() async {
    bool islogin = await SharedDatabase().getLogin();
    bool isverified = await SharedDatabase().getVerified();
    String id = await SharedDatabase().getID();
    String type = await SharedDatabase().getTypeID();

    setState(() {
      isLogin = islogin;
      isVerified = isverified;
      userType = type;
      userID = id;

    });
    if (isLogin != null) {
      if (isLogin) {
        Timer(
            Duration(seconds: 1),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => MainScreen())));
      } else {
        if (isVerified != null) {
          if (isVerified) {
            Timer(
                Duration(seconds: 1),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChooseScreen(userID, userType))));
          } else {
            Timer(
                Duration(seconds: 1),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => AdScreenView(false))));
          }
        } else {
          Timer(
              Duration(seconds: 1),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => AdScreenView(false))));
        }
      }
    } else {
      Timer(
          Duration(seconds: 1),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => AdScreenView(false))));
    }
  }

  @override
  void initState() {
    this._data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              height: 100.0,
              width: 100.0,
              child: Image.asset(
                "assets/icons/icon.png",
              ),
            ),
            Container(
              child: Text(
                "S U B S E T",
                style: TextStyle(
                    textBaseline: TextBaseline.alphabetic,
                    color: CustomColors.Colors.primaryColor,
                    fontSize: 20.0,
                    fontFamily: 'RobotoMedium'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
