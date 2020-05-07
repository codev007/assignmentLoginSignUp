import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/comman/Search.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/AdmissionCoachingList.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/StartScreen.dart';
import 'package:subset/views/comman/AdDetails.dart';
import 'package:subset/style/colors.dart' as CustomColors;

class AdScreenView extends StatefulWidget {
  final bool isLogin;
  AdScreenView(this.isLogin, {Key key}) : super(key: key);

  @override
  _AdScreenViewState createState() => _AdScreenViewState();
}

class _AdScreenViewState extends State<AdScreenView> {
  bool isFound = false;
  bool isLoading = true;
  var coachingList = List<AdmissionCoachingList>();
  String locationID;

  _data() async {
    String loc = await SharedDatabase().getLocationID();
    setState(() {
      if (loc == null) {
        locationID = "MP13";
      } else {
        locationID = loc;
      }
    });
    this.getCoachingListFromApi();
  }

  @override
  void initState() {
    _data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Subset",
            style: new TextStyle(
                fontFamily: SubsetFonts().toolbarFonts,
                color: CustomColors.Colors.primaryColor)),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: CustomColors.Colors.primaryColor,
              ),
              onPressed: () {
                _navigateAndDisplaySelection(context);
              })
        ],
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isFound
                ? Center(
                    child: Text(
                      "coaching not added yet\nwe will be here soon"
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontFamily: SubsetFonts().notfoundFont,
                          color: Colors.black,
                          fontSize: 17.0),
                    ),
                  )
                : RefreshIndicator(
                    child: ListView.builder(
                        itemCount: coachingList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(FadeRouteBuilder(
                                  page: AdDetailsScreen(
                                      coachingList[index].coachingId)));
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
                                                Constants().coachinglogo +
                                                    coachingList[index].logo),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context).size.width-80,
                                                child: Text(
                                                  coachingList[index]
                                                      .coachingName,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: new TextStyle(
                                                      fontFamily: SubsetFonts().titleFont,
                                                      color: Colors.black,
                                                      fontSize: 17.0),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width-80,
                                                child: Text(
                                                  coachingList[index].address,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: new TextStyle(
                                                      color: Colors.black38,
                                                      fontSize: 14.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10.0, right: 10.0, bottom: 16.0),
                                    child: Text(
                                      coachingList[index].coachingDescription,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: new TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: SubsetFonts().descriptionFont,
                                          color: Colors.black87),
                                    ),
                                  ),
                                  _spacer(),
                                ],
                              ),
                            ),
                          );
                        }),
                    onRefresh: _refresh),
      ),
      floatingActionButton: widget.isLogin
          ? Container()
          : FloatingActionButton.extended(
              icon: Icon(Icons.input),
              onPressed: () {
                Navigator.of(context).push(FadeRouteBuilder(page: StartPage()));
              },
              label: Text("LOG IN")),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    coachingList.clear();
    this.getCoachingListFromApi();
  }

  getCoachingListFromApi() async {
    setState(() {
      isLoading = true;
      isFound = false;
    });

    Map<String, dynamic> jsondat = {"mobile": locationID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().chooseCoachingList,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        coachingList = (json.decode(response.body) as List)
            .map((data) => new AdmissionCoachingList.fromJson(data))
            .toList();
        if (coachingList.length > 0) {
          isFound = false;
        } else {
          isFound = true;
        }
        isLoading = false;
      });
    }
  }

  _spacer() {
    return Container(
      color: Colors.black12,
      height: 6.0,
    );
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
    if (result != null) {
      setState(() {
        locationID = result;
      });
      _refresh();
    }
  }
}
