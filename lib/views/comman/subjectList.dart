import 'dart:convert';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/models/SubjectModel.dart';
import 'package:http/http.dart' as http;
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/TeacherViews/uploadResult.dart';

class SubjectListView extends StatefulWidget {
  final String classID;
  final String batchID;
  final String testID;
  SubjectListView(this.classID, this.batchID, this.testID, {Key key})
      : super(key: key);
  @override
  _SubjectListViewState createState() => _SubjectListViewState();
}

class _SubjectListViewState extends State<SubjectListView> {
  var subjectList = List<SubjectModel>();
  bool isLoading = true;
  bool isFound = false;
  @override
  void initState() {
    this.getSubjectsListFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          elevation: 1.0,
          title: Text("Select Subject ",
              style: new TextStyle(
                  fontFamily: SubsetFonts().toolbarFonts,
                  color: CustomColors.Colors.primaryColor))),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isFound
                ? Center(
                    child: Text(
                      "Subjects not found".toUpperCase(),
                      style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                    ),
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
                              page: UploadRestView(
                                  widget.batchID,
                                  widget.classID,
                                  subjectList[index].subjectId.toString(),
                                  widget.testID)));
                        },
                      );
                    },
                  ),
      ),
    );
  }

  getSubjectsListFromApi() async {
    Map<String, dynamic> jsondat = {"class_id": widget.classID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().fetchSubjects,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        subjectList = (json.decode(response.body) as List)
            .map((data) => new SubjectModel.fromJson(data))
            .toList();
        if (subjectList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }
}
