import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/style/string.dart';
import 'package:subset/views/LoginScreen.dart';
import 'package:subset/style/colors.dart' as CustomColors;

class ChooseRole extends StatefulWidget {
  @override
  _ChooseRoleState createState() => _ChooseRoleState();
}

_textStyle() {
  return TextStyle(
      fontSize: 15.0,
      color: CustomColors.Colors.primaryColor,
      fontFamily: SubsetFonts().descriptionFont);
}

class _ChooseRoleState extends State<ChooseRole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 1.0,
        title: Text(
          "Choose",
          style: TextStyle(
              color: CustomColors.Colors.primaryColor,
              fontFamily: SubsetFonts().toolbarFonts),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                  child: Container(
                    height: 200.0,
                    child: Image.asset("assets/icons/connect.png"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    StringData().chooseroleText.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                        fontFamily: SubsetFonts().titleFont),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  FadeRouteBuilder(page: LoginScreen("S")));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 65.0,
                                    padding: EdgeInsets.all(10.0),
                                    child:
                                        Image.asset("assets/icons/student.png"),
                                  ),
                                  Container(
                                    child: Text(
                                      "Student".toUpperCase(),
                                      style: _textStyle(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  FadeRouteBuilder(page: LoginScreen("T")));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 65.0,
                                    padding: EdgeInsets.all(10.0),
                                    child:
                                        Image.asset("assets/icons/teacher.png"),
                                  ),
                                  Container(
                                    child: Text(
                                      "Teacher".toUpperCase(),
                                      style: _textStyle(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  FadeRouteBuilder(page: LoginScreen("P")));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 65.0,
                                    padding: EdgeInsets.all(10.0),
                                    child:
                                        Image.asset("assets/icons/parent.png"),
                                  ),
                                  Container(
                                    child: Text(
                                      "Parents".toUpperCase(),
                                      style: _textStyle(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
