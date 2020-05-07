import 'dart:convert';
import 'package:subset/Admin/update.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/CoachingCommentsPojo.dart';
import 'package:subset/models/coachingInfoPojo.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:http/http.dart' as http;
import 'package:subset/views/FirebaseMessagingService.dart';

class CoachingDetails extends StatefulWidget {
  final String coachingID;
  CoachingDetails(this.coachingID, {Key key}) : super(key: key);
  @override
  _CoachingDetailsState createState() => _CoachingDetailsState();
}

class _CoachingDetailsState extends State<CoachingDetails> {
  bool isLoading = true;
  bool isFound = false;
  bool isCLoading = true;
  bool isCFound = false;
  bool isSubmitting = false;
  String userType;
  bool isChoosen = false;
  var coachingInfo = List<CoachingInfoPojo>();
  var comments = List<CoachingCommentsPojo>();
  bool isActive = false;
  String userID;
  TextEditingController commentController = new TextEditingController();
  String userName;
  String userImage;

  _data() async {
    String id = await SharedDatabase().getID();
    String name = await SharedDatabase().getName();
    String type = await SharedDatabase().getTypeID();
    String image = await SharedDatabase().getImage();

    setState(() {
      userID = id;
      userName = name;
      userType = type;
      userImage = image;
    });
    this._loadInfo();
    this._loadComments();
  }

  @override
  void initState() {
    this._data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          userType == 'A'
              ? FlatButton(
                  onPressed: () {
                    updateBottomBar();
                  },
                  child: Text(
                    "UPDATE",
                    style: TextStyle(fontFamily: SubsetFonts().toolbarFonts),
                  ),
                )
              : IconButton(
                  tooltip: "Write your review",
                  onPressed: () {
                    _writeAnswerBottomSheet();
                  },
                  icon: Icon(Icons.insert_comment),
                )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Container(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : isFound
                    ? Center(
                        child: Text(
                          "Info not found".toUpperCase(),
                          style:
                              TextStyle(fontFamily: SubsetFonts().notfoundFont),
                        ),
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
              _staffList(),
              _spacer(),
              _achievements(),
              _spacer(),
              _address(),
              _spacer(),
              _reviews()
            ],
          ),
        ),
      ],
    );
  }

  Widget _achievements() {
    return coachingInfo[0].achievements != null
        ? Container(
            padding: EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
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
                  child: Text(
                    coachingInfo[0].achievements,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                        fontFamily: SubsetFonts().descriptionFont),
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  _staffList() {
    return new Container(
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
                              bootomBar(context, coachingInfo[0].staff[index]);
                            },
                            child: Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: new NetworkImage(Constants()
                                            .profileImage +
                                        coachingInfo[0].staff[index].image)),
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
          ],
        ));
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
            style: TextStyle(fontSize: 15.0, color: Colors.black54),
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
              style: TextStyle(
                  fontSize: 25.0, fontFamily: SubsetFonts().titleFont),
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
          Divider(),
          Container(
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
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontFamily: SubsetFonts().descriptionFont),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviews() {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Reviews",
              style: new TextStyle(
                  fontFamily: SubsetFonts().titleFont,
                  fontSize: 16.0,
                  color: CustomColors.Colors.primaryColor),
            ),
          ),
          Divider(),
          Container(
              child: isCLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : isCFound
                      ? Center(
                          child: Text("Reviews not found"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 30.0,
                                        width: 30.0,
                                        margin: EdgeInsets.only(
                                            bottom: 5.0, top: 10.0),
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
                                              left: 10.0, top: 10.0),
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
                                                      fontFamily: SubsetFonts()
                                                          .usernameFont,
                                                      color: CustomColors
                                                          .Colors.primaryColor,
                                                      fontSize: 17.0),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: 20.0),
                                                child: Text(
                                                  comments[index].comment,
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black54,
                                                      fontFamily: SubsetFonts()
                                                          .descriptionFont),
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

  _writeAnswerBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    child: SingleChildScrollView(
                  child: Wrap(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  padding: EdgeInsets.all(5.0),
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
                              Expanded(
                                child: Text(""),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    right: 10.0, top: 5.0, bottom: 5.0),
                                child: isSubmitting
                                    ? Container(
                                        child: SizedBox(
                                          height: 15.0,
                                          width: 15.0,
                                          child: Center(
                                            child:
                                                new CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    : isActive
                                        ? FlatButton(
                                            color: Colors.white,
                                            onPressed: () async {
                                              setStates(() {
                                                isSubmitting = true;
                                              });
                                              _addComment(
                                                  commentController.text);
                                            },
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                            //          alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                top: 5.0,
                                                bottom: 5.0),
                                            //            width: MediaQuery.of(context).size.width,
                                            child: Text(
                                              "submit".toUpperCase(),
                                              style: new TextStyle(
                                                  color: CustomColors
                                                      .Colors.primaryColor,
                                                  fontSize: 12.0),
                                            ),
                                          )
                                        : Text(""),
                              )
                            ],
                          ),
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: CustomColors.Colors.primaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(19.0),
                                topRight: Radius.circular(19.0)),
                          )),
                      Container(
                        margin: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(userImage),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      userName,
                                      style: new TextStyle(
                                          fontSize: 17.0,
                                          fontFamily: "RobotoMedium"),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 25.0),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                        ),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 10,
                          autofocus: false,
                          obscureText: false,
                          controller: commentController,
                          onChanged: (String value) {
                            if (value.length > 0) {
                              setStates(() {
                                isActive = true;
                              });
                            } else {
                              setStates(() {
                                isActive = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Write your comment here',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                )));
          });
        });
  }

  updateBottomBar() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
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
                Container(
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10.0, bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateCoaching(widget.coachingID, 1),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                          ),
                          child: Text("UPDATE LOGO",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateCoaching(widget.coachingID, 2),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                          ),
                          child: Text("UPDATE IMAGE",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateCoaching(widget.coachingID, 3),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                          ),
                          child: Text("UPDATE ACIEVEMENT",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
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
                          child: Text("TEACHER NAME",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.username,
                              style: new TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18.0,
                                  fontFamily: SubsetFonts().titleFont)),
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
                                  color: Colors.black87,
                                  fontSize: 18.0,
                                  fontFamily: SubsetFonts().titleFont)),
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
                                  color: Colors.black87,
                                  fontSize: 18.0,
                                  fontFamily: SubsetFonts().titleFont)),
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

  _addComment(String comment) async {
    Map<String, dynamic> jsondat = {
      "coaching_id": widget.coachingID,
      "user_id": userID,
      "comment": comment,
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().addcoachingcomment,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        var body = json.decode(response.body);
        if (!body['error']) {
          setState(() {
            isCLoading = true;
          });
          Navigator.of(context).pop();
          commentController.clear();
          comments.clear();
          this._loadComments();
          String title =
              userName + ' added new review on ' + coachingInfo[0].coachingName;
          sendAndRetrieveMessage(
              title, comment, '/topics/' + widget.coachingID);
        }
        setState(() {
          isSubmitting = false;
        });
      });
    }
  }

  _refresh() {
    coachingInfo.clear();
    comments.clear();
    this._loadInfo();
    this._loadComments();
  }
}
