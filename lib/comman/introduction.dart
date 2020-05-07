import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/style/string.dart';
import 'package:subset/style/style.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/views/LoginScreen.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subset Introduction",
            style: new TextStyle(color: CustomColors.Colors.primaryColor,fontFamily: SubsetFonts().toolbarFonts)),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //----intro one------------------------
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 200.0,
                        child: Image.asset("assets/icons/main.png"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Subset ?",
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: SubsetFonts().titleFont),
                      ),
                    ),
                    Container(
                      child: Text(
                        StringData().subsetIntro,
                        style: TextStyle(fontSize: 15.0,fontFamily: SubsetFonts().descriptionFont),
                      ),
                    ),
                  ],
                ),
              ),
              Style().spacer(),
              //----intro one------------------------
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 200.0,
                        child: Image.asset("assets/icons/connect.png"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 7.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Easy Communication ",
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: SubsetFonts().titleFont),
                      ),
                    ),
                    Container(
                      child: Text(
                        StringData().connectIntro,
                        style: TextStyle(fontSize: 15.0,fontFamily: SubsetFonts().descriptionFont),
                      ),
                    ),
                  ],
                ),
              ),
              Style().spacer(),
              //----intro one------------------------
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 200.0,
                        child: Image.asset("assets/icons/report.png"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Report Card ",
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: SubsetFonts().titleFont),
                      ),
                    ),
                    Container(
                      child: Text(
                        StringData().reportIntro,
                        style: TextStyle(fontSize: 15.0,fontFamily: SubsetFonts().descriptionFont),
                      ),
                    ),
                  ],
                ),
              ),
              Style().spacer(),
              //----intro one------------------------
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 200.0,
                        child: Image.asset("assets/icons/doubt.png"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Doubt Session ",
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: SubsetFonts().titleFont),
                      ),
                    ),
                    Container(
                      child: Text(
                        StringData().subsetIntro,
                        style: TextStyle(fontSize: 15.0,fontFamily: SubsetFonts().descriptionFont),
                      ),
                    ),
                  ],
                ),
              ),
              Style().spacer(),
              //----intro one------------------------
              Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200.0,
                      child: Image.asset("assets/icons/notice.png"),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Subset Notes",
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: SubsetFonts().titleFont),
                      ),
                    ),
                    Container(
                      child: Text(
                        StringData().noticIntro,
                        style: TextStyle(fontSize: 15.0,fontFamily: SubsetFonts().descriptionFont),
                      ),
                    ),
                  ],
                ),
              ),
              Style().spacer(),
              Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    color: CustomColors.Colors.primaryColor,
                    onPressed: () {
                      Navigator.of(context)
                          .push(FadeRouteBuilder(page: LoginScreen("A")));
                    },
                    child: Text(
                      "Continue".toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
