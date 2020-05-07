import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:subset/models/AttendancePojo.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:http/http.dart' as http;
import 'package:subset/style/colors.dart' as CustomColors;

class StudentAttendance extends StatefulWidget {
  final String userUID;
  StudentAttendance(this.userUID, {Key key}) : super(key: key);
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  bool isLoading = true;
  bool isFound = false;
  var attendanceList = List<AttendanceDataPojo>();

  @override
  void initState() {
    this.fetchAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          elevation: 1.0,
          title: Text("Attendance",
              style: new TextStyle(
                  fontFamily: SubsetFonts().toolbarFonts,
                  color: CustomColors.Colors.primaryColor))),
      body: Container(
        child: Container(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : isFound
                  ? Center(
                      child:
                          Text("attendance not uploaded yet".toUpperCase(),style: TextStyle(fontFamily: SubsetFonts().notfoundFont),),
                    )
                  : RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        itemCount: attendanceList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(attendanceList[index].date,style: TextStyle(fontFamily: SubsetFonts().titleFont),),
                            trailing: Text(attendanceList[index].value,style: TextStyle(fontFamily: SubsetFonts().titleFont),),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    attendanceList.clear();
    this.fetchAttendance();
  }

  fetchAttendance() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> jsondat = {"user_uid": widget.userUID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().fetchAttendance,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        attendanceList = (json.decode(response.body) as List)
            .map((data) => new AttendanceDataPojo.fromJson(data))
            .toList();
        if (attendanceList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }
}
