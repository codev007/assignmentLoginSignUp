import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/comman/state.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/ChooseCoaching.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/FirebaseMessagingService.dart';
import 'package:subset/widget/ListWidgets/CoachingList.dart';
import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:http/http.dart' as http;

class ChooseScreen extends StatefulWidget {
  final String userID;
  final String userType;
  ChooseScreen(this.userID, this.userType, {Key key}) : super(key: key);
  @override
  _ChooseScreenState createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  var coachingList = new List<ChooseCoaching>();
  String userTypeName = "";
  String userImage = "";
  String userName = "";
  bool isLoading = true;

  getUserProfileData() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> jsondat = {
      "user_id": widget.userID,
      "user_type": widget.userType
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().profile,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      setState(() {
        userImage = body['image'];
        userName = body['username'];
        SharedDatabase().setUserData(
            body['username'],
            body['mobile'],
            body['address'],
            body['birth'],
            body['gender'],
            body['father_name'],
            body['image'],
            body['school_subject'],
            body['parents_experience'],
            body['token']);
      });
      this.getCoachingListFromApi();
    }
  }

  getCoachingListFromApi() async {
    Map<String, dynamic> jsondat = {
      "user_id": widget.userID,
      "user_type": widget.userType
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().chooseCoachingToContinue,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        coachingList = (json.decode(response.body) as List)
            .map((data) => new ChooseCoaching.fromJson(data))
            .toList();
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  update() async {
    if (widget.userType == 'S' || widget.userType == 'T') {
      Map<String, dynamic> jsondat = {
        "user_id": widget.userID,
        "type": widget.userType,
        "token": await firebaseMessaging.getToken()
      };
      Map<String, String> headers = {"Content-Type": "application/json"};
      final response = await http.post(Constants().updateToken,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {}
    }
    this.getUserProfileData();
  }

  callfunctions() {
    if (widget.userType == "S") {
      setState(() {
        userTypeName = "As Student";
      });
    }
    if (widget.userType == "T") {
      setState(() {
        userTypeName = "As Teacher";
      });
    }
    if (widget.userType == "P") {
      setState(() {
        userTypeName = "As Parents";
      });
    }
    this.update();
  }

  @override
  void initState() {
    this.callfunctions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          elevation: 1.0,
          title: Text("Select Coaching ",
              style: new TextStyle(
                  fontFamily: SubsetFonts().toolbarFonts,
                  color: CustomColors.Colors.primaryColor)),
        ),
        body: isLoading
            ? Center(
                child: SpinKitDoubleBounce(
                color: CustomColors.Colors.primaryColor,
              ))
            : Container(child: _lis()),
        floatingActionButton: new FloatingActionButton(
          onPressed: () => this.callfunctions(),
          child: Icon(Icons.refresh),
        ),
      ),
      onWillPop: () async {
        exit(0);
        return true;
      },
    );
  }

  //-----------------ALL WIDGETS TO BE USE IN UI--------------------------------------

  Widget _usercard() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.all(15.0),
            width: 50.0,
            height: 50.0,
            decoration: new BoxDecoration(
              color: const Color(0xff7c94b6),
              image: new DecorationImage(
                image: new NetworkImage(Constants().profileImage + userImage),
                fit: BoxFit.cover,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
              border: new Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.7,
                  child: Text(userName,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: new TextStyle(
                        fontSize: 20.0,fontFamily: SubsetFonts().titleFont,
                        color: Colors.black,
                      )),
                ),
                Container(
                  child: Text(userTypeName,
                      style:
                          new TextStyle(fontSize: 15.0, color: Colors.black54)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _lis() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                height: 6.0,
                color: Colors.black12,
              ),
              _usercard(),
              Container(
                height: 6.0,
                color: Colors.black12,
              ),
              _chooose(),
              Divider(),
              CoachingList().coachingList(context, coachingList),
              _newAdmission()
            ],
          ),
        ),
      ],
    );
  }

  _chooose() {
    return Container(
      child: Text(
        "Choose Your Coaching To Continue ".toUpperCase(),
        style: new TextStyle(color: Colors.black87),
      ),
      margin: EdgeInsets.only(left: 15.0, right: 15.0,top: 10.0),
    );
  }

  _newAdmission() {
    return Container(
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).push(FadeRouteBuilder(
              page: StateListScreen(widget.userID, widget.userType,widget.userID)));
        },

        child: Text("register into your coaching".toUpperCase(),
            style: new TextStyle(
                fontSize: 15.0, color: CustomColors.Colors.primaryColor)),
      ),
    );
  }
}
