import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/models/classModel.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/TeacherViews/subjectListView.dart';
import 'package:subset/style/colors.dart' as CustomColors;

class ClassesListView extends StatefulWidget {
  final String coachingID;
  ClassesListView(this.coachingID, {Key key}) : super(key: key);
  @override
  _ClassesListViewState createState() => _ClassesListViewState();
}

class _ClassesListViewState extends State<ClassesListView> {
  bool isLoading = true;
  bool isAdding = false;
  var classList = List<ClassModel>();
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
          "Select Class",
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
              itemBuilder: (context, index) {
                return ListTile(
                  title: new Text(
                    classList[index].className,
                    style: TextStyle(fontFamily: SubsetFonts().titleFont),
                  ),
                  onTap: () {
                    Navigator.of(context).push(FadeRouteBuilder(
                        page: SubjectsScreen(
                            classList[index].classId.toString(),widget.coachingID)));
                  },
                );
              },
              itemCount: classList.length,
            ),
    );
  }

  fectData() async {
    Map<String, dynamic> jsondat = {"coaching_id": widget.coachingID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().fetchClassesWithID,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        classList = (json.decode(response.body) as List)
            .map((data) => new ClassModel.fromJson(data))
            .toList();
        isLoading = false;
      });
    }
  }
}
