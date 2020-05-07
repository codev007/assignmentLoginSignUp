import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/Attendance.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:http/http.dart' as http;
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/FirebaseMessagingService.dart';
import 'package:subset/views/helperViews/successful.dart';

class AttendancePage extends StatefulWidget {
  final String batchID;
  final bool submitted;
  AttendancePage(this.batchID, this.submitted, {Key key}) : super(key: key);
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String _appbarTitle = "Attendance";
  List<String> userIDs = [];
  List<String> values = [];
  bool isLoading = true;
  bool isFound = false;
  var userList = List<AttendancePojo>();
  String yearID;
  List<String> tempList = [];
  var myFormat = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
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
        elevation: 1,
        title: Text(
          _appbarTitle,
          style: new TextStyle(
              fontFamily: SubsetFonts().toolbarFonts,
              color: CustomColors.Colors.primaryColor),
        ),
        actions: <Widget>[
          isFound
              ? Container()
              : IconButton(
                  onPressed: () {
                    uploadAttendance(userIDs, values,
                        "${myFormat.format(selectedDate.toLocal())}");
                  },
                  icon: new Icon(
                    Icons.check_circle_outline,
                    color: CustomColors.Colors.primaryColor,
                  ),
                )
        ],
      ),
      body: widget.submitted
          ? Center(
              child: Text(
                "ALREADY ! ATTENDANCE SUBMITTED",
                style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
              ),
            )
          : isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : isFound
                  ? Center(
                      child: Text(
                        "STUDENTS LIST NOT FOUND",
                        style:
                            TextStyle(fontFamily: SubsetFonts().notfoundFont),
                      ),
                    )
                  : _takeStudentAttendance(), //StudentAttendancePage().studentAttendancePage(context),
    );
  }

  _takeStudentAttendance() {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
        return new CheckboxListTile(
          title: new Text(
            userList[index].username + " s/o " + userList[index].fatherName,
            style: TextStyle(fontFamily: SubsetFonts().titleFont),
          ),
          onChanged: (bool value) {
            setState(() {
              if (value) {
                values[index] = "P";
                tempList.add(index.toString());
              } else {
                values[index] = "A";
                tempList.remove(index.toString());
              }
            });
          },
          value: tempList.contains(index.toString()),
        );
      },
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

  uploadAttendance(List<String> userI, List<String> val, String date) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> jsondat = {
      "user_id": userI,
      "date": date,
      "value": val
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().submitAttendance,
        headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      Navigator.of(context).pushReplacement(FadeRouteBuilder(
          page: RequestedSuccessfully(body['error'], body['message'])));
      String title = 'Attendance';
      sendAndRetrieveMessage(title, "Today's attendance submitted",
          '/topics/' + widget.batchID + yearID);
    }
    setState(() {
      isLoading = false;
    });
  }
}
