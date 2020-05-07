import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/models/SubjectModel.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/DrawarViews/Notes.dart';
import 'package:http/http.dart' as http;

class SubjectsScreen extends StatefulWidget {
  final String classID;
  final String coachingID;
  SubjectsScreen(this.classID,this.coachingID, {Key key}) : super(key: key);
  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  bool isLoading = true;
  var subjectList = List<SubjectModel>();
  bool isAdding = false;

  @override
  void initState() {
    this.fectData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Subject",
          style: TextStyle(
              color: CustomColors.Colors.primaryColor,
              fontFamily: SubsetFonts().toolbarFonts),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: subjectList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    subjectList[index].subjectName,
                    style: TextStyle(fontFamily: SubsetFonts().titleFont),
                  ),
                  onTap: () {
                    Navigator.of(context).push(FadeRouteBuilder(
                        page: CoachingNotes(widget.classID,
                            subjectList[index].subjectId.toString(),widget.coachingID)));
                  },
                );
              }),
    );
  }

  fectData() async {
    Map<String, dynamic> jsondat = {"class_id": widget.classID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().subjectList,
        headers: headers, body: json.encode(jsondat));
    print(json.decode(response.body).toString());
    if (response.statusCode == 200) {
      setState(() {
        subjectList = (json.decode(response.body) as List)
            .map((data) => new SubjectModel.fromJson(data))
            .toList();
        isLoading = false;
      });
    }
  }
}
