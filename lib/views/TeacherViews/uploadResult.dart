import 'dart:convert';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:subset/models/Attendance.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/FirebaseMessagingService.dart';
import 'package:subset/views/helperViews/successful.dart';

class UploadRestView extends StatefulWidget {
  final String batchID;
  final String subjectID;
  final String classID;
  final String testID;
  UploadRestView(this.batchID, this.classID, this.subjectID, this.testID,
      {Key key})
      : super(key: key);
  @override
  _UploadRestViewState createState() => _UploadRestViewState();
}

class _UploadRestViewState extends State<UploadRestView> {
  String yearID;
  bool isLoading = true;
  bool isFound = false;
  bool isSubmitting = false;
  bool isActive = false;
  var userList = List<AttendancePojo>();
  List<String> userIDs = [];
  List<String> values = [];
  String _totalMarks;
  _data() async {
    String year = await SharedDatabase().getYearID();

    setState(() {
      yearID = year;
    });

    this.fetchStudentList();
  }

  @override
  void initState() {
    this._data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Upload result",
          style: TextStyle(fontFamily: SubsetFonts().toolbarFonts),
        ),
        actions: <Widget>[
          isLoading
              ? Container()
              : isFound
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        _writeAnswerBottomSheet();
                      },
                      icon: new Icon(
                        Icons.check_circle_outline,
                        color: CustomColors.Colors.primaryColor,
                      ),
                    )
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
                      "STUDENTS LIST NOT FOUND",
                      style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                    ),
                  )
                : ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new ListTile(
                        title: new Text(
                          userList[index].username,
                          style: TextStyle(fontFamily: SubsetFonts().titleFont),
                        ),
                        subtitle: new Text(
                          userList[index].fatherName,
                          style: TextStyle(
                              fontFamily: SubsetFonts().descriptionFont),
                        ),
                        trailing: Container(
                          width: 60.0,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (String value) {
                              if (value.length > 0) {
                                values[index] = value;
                              } else {
                                values[index] = "A";
                              }
                            },
                            decoration: InputDecoration(hintText: "Marks"),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  fetchStudentList() async {
    Map<String, dynamic> jsondat = {
      "batch_id": widget.batchID,
      "year_id": yearID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().studentListForAttendance,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        userList = (json.decode(response.body) as List)
            .map((data) => new AttendancePojo.fromJson(data))
            .toList();
        if (userList.length > 0) {
          for (int i = 0; i < userList.length; i++) {
            userIDs.add(userList[i].userUid);
            values.add(userList[i].value);
          }
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }

  uploadResult() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> jsondat = {
      "user_uid": userIDs,
      "test_id": widget.testID,
      "subject_id": widget.subjectID,
      "batch_id": widget.batchID,
      "marks": values,
      "total": _totalMarks
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().submitResult,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (!body['error']) {
        String title = 'Result uploaded';
        sendAndRetrieveMessage(title, "Check your result now",
            '/topics/' + widget.batchID + yearID);
      }
      Navigator.of(context).pushReplacement(FadeRouteBuilder(
          page: RequestedSuccessfully(body['error'], body['message'])));
    }
    setState(() {
      isLoading = false;
    });
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
                                              if (_totalMarks.length > 0) {
                                                setStates(() {
                                                  isSubmitting = true;
                                                });
                                                this.uploadResult();
                                              }
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
                        child: Text(
                          "PLEASE ENTER TOTAL MARKS OF THE TEST OR EXAM",
                          textAlign: TextAlign.center,
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
                          onChanged: (String value) {
                            if (value.length > 0) {
                              setStates(() {
                                isActive = true;
                                _totalMarks = value;
                              });
                            } else {
                              setStates(() {
                                isActive = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Total marks',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        height: 30.0,
                      )
                    ],
                  ),
                )));
          });
        });
  }
}
