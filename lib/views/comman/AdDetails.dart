import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:subset/models/CoachingCommentsPojo.dart';
import 'package:subset/models/coachingInfoPojo.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:http/http.dart' as http;
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';

class AdDetailsScreen extends StatefulWidget {
  final String coachingID;
  AdDetailsScreen(this.coachingID, {Key key}) : super(key: key);
  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  bool isFound = false;
  bool isLoading = true;
  bool isCLoading = true;
  bool isCFound = false;
  var coachingInfo = List<CoachingInfoPojo>();
  var comments = List<CoachingCommentsPojo>();

  @override
  void initState() {
    this._loadInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
      ),
      body: Container(
        child: Container(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : isFound
                    ? Center(
                        child: Text("Info not found",style: TextStyle(fontFamily: SubsetFonts().notfoundFont),),
                      )
                    : _details()),
      ),
    );
  }

  Widget _details() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _header(),
              _spacer(),
              _count(),
              _spacer(),
              _staffList(),
              _achievements(),
              _address(),
              _spacer(),
              _reviews(),
              _bottomSpacer()
            ],
          ),
        ),
      ],
    );
  }
  Widget _bottomSpacer(){
    return Container(
      height: 40.0,
    );
  }
  Widget _achievements() {
    return coachingInfo[0].achievements != null
        ? Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                  child: Text(
                    "Our achievements",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: SubsetFonts().titleFont,
                        color: CustomColors.Colors.primaryColor),
                  ),
                ),
                Divider(),
                Container(
                  padding:
                      EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                  child: Text(
                    coachingInfo[0].achievements,
                    style: TextStyle(fontSize: 16.0, color: Colors.black54,fontFamily: SubsetFonts().descriptionFont),
                  ),
                ),
                _spacer(),
              ],
            ),
          )
        : Container();
  }

  _staffList() {
    return coachingInfo[0].staff.length > 0
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
                  child: Text(
                    "Our staff",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: SubsetFonts().titleFont,
                        color: CustomColors.Colors.primaryColor),
                  ),
                ),
                Divider(),
                Container(
                  height: 110.0,
                  child: new ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: coachingInfo[0].staff.length,
                    itemBuilder: (context, index) => new Container(
                      alignment: Alignment.topCenter,
                      child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                customBorder: new CircleBorder(),
                                splashColor: Colors.red,
                                onTap: () {
                                  bootomBar(
                                      context, coachingInfo[0].staff[index]);
                                },
                                child: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: new NetworkImage(
                                            Constants().profileImage +
                                                coachingInfo[0]
                                                    .staff[index]
                                                    .image)),
                                  ),
                                  //margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                width: 60.0,
                                child: Text(
                                  coachingInfo[0].staff[index].username,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10.0),
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                ),
                _spacer(),
              ],
            ))
        : Container();
  }

  _spacer() {
    return Container(
      color: Colors.black12,
      height: 6.0,
    );
  }

  Widget _address() {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Address",
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: SubsetFonts().titleFont,
                color: CustomColors.Colors.primaryColor),
          ),
          Text(
            coachingInfo[0].address,
            style: TextStyle(fontSize: 15.0, color: Colors.black54,fontFamily: SubsetFonts().descriptionFont),
          )
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              coachingInfo[0].coachingName,
              style: TextStyle(fontSize: 25.0, fontFamily: SubsetFonts().titleFont),
            ),
          ),
          Container(
            child: Text(
              coachingInfo[0].tagline,
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: SubsetFonts().descriptionFont,
                  color: Colors.black54),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(
                    Constants().coachingimage + coachingInfo[0].image),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            child: Text(
              "Established on " + coachingInfo[0].establishmentat,
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: SubsetFonts().titleFont,
                  color: CustomColors.Colors.primaryColor),
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            child: Text(
              coachingInfo[0].coachingDescription,
              style: TextStyle(color: Colors.black54, fontSize: 16.0,fontFamily: SubsetFonts().descriptionFont),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviews() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15.0, top: 15.0,bottom: 10.0),
            child: Text(
              "Reviews by teachers and students",
              style: new TextStyle(
                  fontFamily: SubsetFonts().titleFont,
                  fontSize: 16.0,
                  color: CustomColors.Colors.primaryColor),
            ),
          ),
          Container(
              child: isCLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : isCFound
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Reviews not found",style: TextStyle(fontFamily: SubsetFonts().titleFont),),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                Divider(),
                                Container(
                                  margin: EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 30.0,
                                        width: 30.0,
                                        margin: EdgeInsets.only(
                                            bottom: 5.0),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              CustomColors.Colors.primaryColor,
                                          backgroundImage: NetworkImage(
                                              Constants().profileImage +
                                                  comments[index].image),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  comments[index].username,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: new TextStyle(
                                                      fontFamily:
                                                          SubsetFonts().titleFont,
                                                      color: Colors.grey,
                                                      fontSize: 13.0),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: 20.0),
                                                child: Text(
                                                  comments[index].comment,
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ))
        ],
      ),
    );
  }

  Widget _count() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 65.0,
                  padding: EdgeInsets.all(5.0),
                  child: Image.asset("assets/icons/student.png"),
                ),
                Container(
                  child: Text(
                    coachingInfo[0].scount.toString() + "\nSTUDENTS",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 65.0,
                  padding: EdgeInsets.all(5.0),
                  child: Image.asset("assets/icons/teacher.png"),
                ),
                Container(
                  child: Text(
                    coachingInfo[0].tcount.toString() + "\nTEACHERS",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  _loadInfo() async {
    Map<String, dynamic> jsondat = {
      "coaching_id": widget.coachingID,
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().fetchCoachingInfo,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        coachingInfo = (json.decode(response.body) as List)
            .map((data) => new CoachingInfoPojo.fromJson(data))
            .toList();
        if (coachingInfo.length > 0) {
          isLoading = false;
          this._loadComments();
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }

  _loadComments() async {
    Map<String, dynamic> jsondat = {
      "coaching_id": widget.coachingID,
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().fetchCoachingComments,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        comments = (json.decode(response.body) as List)
            .map((data) => new CoachingCommentsPojo.fromJson(data))
            .toList();
        if (comments.length > 0) {
          isCLoading = false;
        } else {
          isCLoading = false;
          isCFound = true;
        }
      });
    }
  }

  bootomBar(BuildContext context, Staff data) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5.0),
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                tooltip: "Close",
                                padding: EdgeInsets.only(bottom: 5.0),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: CustomColors.Colors.primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(19.0),
                              topRight: Radius.circular(19.0)),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 10.0, bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text("""TEACHER'S NAME""",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.username,
                              style: new TextStyle(
                                  color: Colors.black54, fontSize: 18.0)),
                        ),
                        Divider(),
                        Container(
                          child: Text("SUBJECTS",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.subjects,
                              style: new TextStyle(
                                  color: Colors.black54, fontSize: 18.0)),
                        ),
                        Divider(),
                        Container(
                          child: Text("EXPERIENCE",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.experience,
                              style: new TextStyle(
                                  color: Colors.black54, fontSize: 18.0)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _refresh() {
    coachingInfo.clear();
    comments.clear();
    this._loadInfo();
    this._loadComments();
  }
}
