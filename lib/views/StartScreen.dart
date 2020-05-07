import 'package:subset/anim/scale_anim.dart';
import 'package:flutter/material.dart';
import 'package:subset/comman/introduction.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/views/comman/ChooseRole.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  String userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/icons/doodle.png",
              fit: BoxFit.fitWidth,
            ),
          ),
          Opacity(
            opacity: 0.80,
            child: Container(
              color: CustomColors.Colors.primaryColor,
            ),
          ),
          Positioned(
            top: 30.0,
            bottom: 5.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Text("Lets",
                        style: new TextStyle(
                            color: CustomColors.Colors.white,
                            fontSize: 30.0,
                            fontFamily: "RobotoThin")),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Text("Dive into subset",
                        style: new TextStyle(
                            color: CustomColors.Colors.white,
                            fontSize: 30.0,
                            fontFamily: "RobotoThin")),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0, bottom: 0.0),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () {
                        // _chooseRoleBottomBar(context);
                        Navigator.of(context)
                            .push(FadeRouteBuilder(page: ChooseRole()));
                      }, // ,
                      padding: EdgeInsets.all(12),
                      color: CustomColors.Colors.white,
                      child: Text('SIGN IN',
                          style: TextStyle(
                              color: CustomColors.Colors.primaryColor)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                            .push(FadeRouteBuilder(page: IntroductionScreen()));
                        },
                        child: Text("register your coaching into subset"
                            .toUpperCase(),style: TextStyle(color: Colors.white,fontFamily: "RobotoRegular"),)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
