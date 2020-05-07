import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/models/TeacherRequestPojo.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:http/http.dart' as http;
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/helperViews/nointernet.dart';

class TeacherList extends StatefulWidget {
  final String coachingID;
  TeacherList(this.coachingID, {Key key}) : super(key: key);
  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  var listView = List<TeacherRequestPojo>();
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
        title: Text("Teachers",style: TextStyle(fontFamily: SubsetFonts().toolbarFonts),),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isFound
                ? Center(
                    child: Text("Teacher Found :(",style: TextStyle(fontFamily: SubsetFonts().notfoundFont),),
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
                          subtitle: Text(listView[index].batchName,style: TextStyle(fontFamily: SubsetFonts().descriptionFont),),
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
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(Constants().fetchTeacher,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          listView = (json.decode(response.body) as List)
              .map((data) => new TeacherRequestPojo.fromJson(data))
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

  _bootomBar(BuildContext context, TeacherRequestPojo data) {
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
                        child: Text("TEACHER'S NAME",
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
                        child: Text("TEACHER'S MOBILE",
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
                        child: Text("FATHER'S OR HUSBAND'S NAME",
                            style: new TextStyle(
                                color: Colors.grey, fontSize: 12.0)),
                      ),
                      Container(
                        child: Text(data.fatherHusband,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
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
                        child: Text("CLASS AND BATCH",
                            style: new TextStyle(
                                color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
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
                        child: Text("TEACHER'S ADDRESS",
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
                        child: Text("TEACHING EXPERIENCE",
                            style: new TextStyle(
                                color: Colors.grey, fontSize: 12.0)),
                      ),
                      Container(
                        child: Text(data.experience,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
