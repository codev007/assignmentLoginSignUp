import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:subset/Admin/sendNotification.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/NoticePojo.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/style/fonts.dart';
import 'package:subset/style/subset_icons.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/HomeDetails.dart';
import 'package:subset/views/TeacherViews/AddNotice.dart';
import 'package:http/http.dart' as http;
import 'package:subset/views/helperViews/nointernet.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isFound = false;
  String userID;
  String userUUID;
  String userType;
  String yearID;
  String coachingID;
  String batchID;
  bool isListFinish = false;
  ScrollController _scrollController = ScrollController();
  var noticeList = List<NoticePojo>();
  int page = 1;
  void _onTap() {
    Navigator.of(context).push(FadeRouteBuilder(page: AddNotice()));
  }

  _userdata() async {
    String id = await SharedDatabase().getID();
    String uid = await SharedDatabase().getUID();
    String type = await SharedDatabase().getTypeID();
    String yearid = await SharedDatabase().getYearID();
    String cid = await SharedDatabase().getCoachingID();
    String batchid = await SharedDatabase().getBatchID();

    setState(() {
      userID = id;
      userUUID = uid;
      userType = type;
      yearID = yearid;
      coachingID = cid;
      batchID = batchid;
    });
    this.loadItems(page);
  }

  @override
  void initState() {
    this._userdata();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isListFinish) {
          _loadMoreItems();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        //   backgroundColor: CustomColors.Colors.primaryColor,
        title: Text("Subset",
            style: new TextStyle(
                fontFamily: SubsetFonts().toolbarFonts,
                color: CustomColors.Colors.primaryColor)),
        actions: <Widget>[
          userType == "T"
              ? IconButton(
                  tooltip: "Add Notice or Assignment",
                  onPressed: _onTap,
                  padding: EdgeInsets.all(12.0),
                  icon: Icon(
                    Icons.add_circle_outline,
                  ))
              : Container(),
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context).push(
                    FadeRouteBuilder(page: SendNotification(coachingID, 2)));
              })
        ],
      ),
      body: homepageListPagination(context), //HomeList().homepageList(context),
    );
  }

  homepageListPagination(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              child: isFound
                  ? Center(
                      child: InkWell(
                          onTap: _refresh,
                          child: Text(
                              "Data not added yet\nTap here to refresh"
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: SubsetFonts().notfoundFont))),
                    )
                  : Container(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == noticeList.length) {
                            return isListFinish
                                ? Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      "No more data",
                                      style: TextStyle(
                                          fontFamily:
                                              SubsetFonts().notfoundFont),
                                    ))
                                : Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(15.0),
                                    child: CupertinoActivityIndicator());
                          }
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(FadeRouteBuilder(
                                  page: HomeDetails(noticeList[index].id)));
                            },
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              bottom: 5.0,
                                              top: 10.0),
                                          child: CircleAvatar(
                                            backgroundColor: CustomColors
                                                .Colors.primaryColor,
                                            backgroundImage: NetworkImage(
                                                Constants().profileImage +
                                                    noticeList[index].image),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 200,
                                              child: Text(
                                                noticeList[index].name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: new TextStyle(
                                                    fontFamily: SubsetFonts()
                                                        .usernameFont,
                                                    color: Colors.black,
                                                    fontSize: 17.0),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                noticeList[index].time,
                                                overflow: TextOverflow.ellipsis,
                                                style: new TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily:
                                                        SubsetFonts().timeFont),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.only(right: 15.0),
                                          child: noticeList[index].type == "N"
                                              ? Icon(
                                                  Subset.notice,
                                                  size: 18.0,
                                                  color: CustomColors
                                                      .Colors.primaryColor,
                                                )
                                              : Icon(
                                                  Icons.assignment,
                                                  size: 18.0,
                                                  color: CustomColors
                                                      .Colors.primaryColor,
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10.0, right: 10.0, bottom: 2.0),
                                    child: Text(
                                      noticeList[index].title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontFamily: SubsetFonts().titleFont),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10.0, right: 10.0, bottom: 16.0),
                                    child: Text(
                                      noticeList[index].description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: new TextStyle(
                                          fontSize: 15.0,
                                          fontFamily:
                                              SubsetFonts().descriptionFont,
                                          color: Colors.black54),
                                    ),
                                  ),
                                  _spacer()
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: noticeList.length + 1,
                      ),
                    ),
              onRefresh: _refresh,
            ),
    );
  }

  _spacer() {
    return Container(
      color: Colors.black12,
      height: 6.0,
    );
  }

  Future<bool> _loadMoreItems() async {
    setState(() {
      page++;
    });
    loadItems(page);
    return true;
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
      isFound = false;
    });
    noticeList.clear();
    setState(() {
      page = 1;
    });
    loadItems(page);
  }

  void loadItems(int page) async {
    var tempList = List<NoticePojo>();
    Map<String, dynamic> jsondat;
    String import;
    if (userType == 'T') {
      import = Constants().noticeListTeacher;
      jsondat = {
        "coaching_id": coachingID,
        "user_type": userType,
        "year_id": yearID,
        "page": page
      };
    } else {
      import = Constants().noticeListStudent;

      jsondat = {
        "batch_id": batchID,
        "user_type": userType,
        "year_id": yearID,
        "page": page
      };
    }
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      final response =
          await http.post(import, headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          tempList = (json.decode(response.body) as List)
              .map((data) => new NoticePojo.fromJson(data))
              .toList();
          if (tempList.length > 0) {
            noticeList.addAll(tempList);
            if (tempList.length < 10) {
              isListFinish = true;
            } else {
              isListFinish = false;
            }
            isLoading = false;
          } else {
            if (noticeList.length > 0) {
              isLoading = false;
              isFound = false;
            } else {
              isLoading = false;
              isFound = true;
            }
            isListFinish = true;
          }
        });
      }
    } on SocketException {
      Navigator.of(context).push(FadeRouteBuilder(page: NoInternetScreen()));
    }
  }
}
