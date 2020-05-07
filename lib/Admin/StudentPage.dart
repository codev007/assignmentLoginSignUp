import 'dart:convert';
import 'dart:io';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:flutter/material.dart';
import 'package:subset/models/StudentRequestPojo.dart';
import 'package:http/http.dart' as http;
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/comman/testList.dart';
import 'package:subset/views/helperViews/nointernet.dart';
import 'package:subset/views/student/studentAttendance.dart';

class StudentViewList extends StatefulWidget {
  final String coachingID;
  final String batchID;
  StudentViewList(this.coachingID, this.batchID, {Key key}) : super(key: key);
  @override
  _StudentViewListState createState() => _StudentViewListState();
}

class _StudentViewListState extends State<StudentViewList> {
  var listView = List<StudentRequestPojo>();
  bool isLoading = true;
  bool isFound = false;

  @override
  void initState() {
    this.getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Students",style: TextStyle(fontFamily: SubsetFonts().toolbarFonts),),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isFound
                ? Center(
                    child: InkWell(
                        onTap: _refresh,
                        child: Text("Student Found\nTab here to refresh",style: TextStyle(fontFamily: SubsetFonts().notfoundFont),)),
                  )
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      itemCount: listView.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: CustomColors.Colors.primaryColor,
                            backgroundImage: NetworkImage(
                                Constants().profileImage +
                                    listView[index].image),
                          ),
                          title: Text(listView[index].username,style: TextStyle(fontFamily: SubsetFonts().titleFont),),
                          subtitle: Text(listView[index].batchName,style: TextStyle(fontFamily: SubsetFonts().descriptionFont)),
                          onTap: () {
                            _bootomBar(context, listView[index]);
                          },
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
      isFound = false;
    });
    listView.clear();
    this.getList();
  }

  getList() async {
    Map<String, dynamic> jsondat = {
      "coaching_id": widget.coachingID,
      "batch_id": widget.batchID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(Constants().fetchStudent,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          listView = (json.decode(response.body) as List)
              .map((data) => new StudentRequestPojo.fromJson(data))
              .toList();
          if (listView.length > 0) {
            isLoading = false;
          } else {
            isLoading = false;
            isFound = true;
          }
        });
      }
    } on SocketException {
      Navigator.of(context)
          .push(FadeRouteBuilder(page: NoInternetScreen()));
    }
  }

  _bootomBar(BuildContext context, StudentRequestPojo data) {
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
                        Container(
                          child: Text("USERNAME",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.username,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
                        ),
                        Divider(),
                        Container(
                          child: Text("STUDENT'S MOBILE",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.mobile,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
                        ),
                        Divider(),
                        Container(
                          child: Text("FATHER'S NAME",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.fatherName,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
                        ),
                        Divider(),
                        Container(
                          child: Text("SCHOOL NAME",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.schoolName,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
                        ),
                        Divider(),
                        Container(
                          child: Text("CLASS AND BATCH",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.className + " - " + data.batchName,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
                        ),
                        Divider(),
                        Container(
                          child: Text("ADMISSION DATE",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.admissionDate,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
                        ),
                        Divider(),
                        Container(
                          child: Text("ADDRESS",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.address,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
                        ),
                        Divider(),
                        Container(
                          child: Text("PARENT'S MOBILE NUMBER",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.parentsMobile,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        FadeRouteBuilder(
                                            page: TextListView(
                                                data.classId.toString(),
                                                data.batchId.toString(),
                                                2,
                                                data.userUid)),
                                      );
                                    },
                                    child: Text(
                                      "RESULT DETAILS",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color:
                                              CustomColors.Colors.primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        FadeRouteBuilder(
                                            page: StudentAttendance(
                                                data.userUid)),
                                      );
                                    },
                                    child: Text(
                                      "ATTENDANCE",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color:
                                              CustomColors.Colors.primaryColor),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
