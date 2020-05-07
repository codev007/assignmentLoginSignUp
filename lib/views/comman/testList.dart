import 'dart:convert';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/models/TestPojo.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/ReportDetailsPage.dart';
import 'package:subset/views/comman/subjectList.dart';
import 'package:http/http.dart' as http;

class TextListView extends StatefulWidget {
  final String batchID;
  final String classID;
  final String userUID;
  final int screenID;
  TextListView(this.classID, this.batchID, this.screenID, this.userUID,
      {Key key})
      : super(key: key);
  @override
  _TextListViewState createState() => _TextListViewState();
}

class _TextListViewState extends State<TextListView> {
  var testList = List<TestPojo>();
  bool isLoading = true;
  bool isFound = false;
  String yearID;
  bool isAdding = false;
  String dialogSms = "ADD TEST OR EXAM NAME .";
  TextEditingController _testName = new TextEditingController();
  @override
  void initState() {
    this._userdata();
    super.initState();
  }

  _userdata() async {
    String yearid = await SharedDatabase().getYearID();

    setState(() {
      yearID = yearid;
    });
    this.getTestList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 1.0,
        title: Text("Select Exam ",
            style: new TextStyle(
                fontFamily: SubsetFonts().toolbarFonts,
                color: CustomColors.Colors.primaryColor)),
        actions: <Widget>[
          widget.screenID == 3
              ? IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    bottomSheetAddTest(context);
                  })
              : Container()
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
                      "Test or Exam not created yet !!".toUpperCase(),
                      style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      itemCount: testList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            testList[index].testName.toUpperCase(),
                            style:
                                TextStyle(fontFamily: SubsetFonts().titleFont),
                          ),
                          onTap: () {
                            if (widget.screenID == 1) {
                              Navigator.of(context).push(FadeRouteBuilder(
                                  page: SubjectListView(
                                      widget.classID,
                                      widget.batchID,
                                      testList[index].testId.toString())));
                            } else if (widget.screenID == 2) {
                              Navigator.of(context).push(FadeRouteBuilder(
                                  page: ReportDetailsPage(widget.userUID,
                                      testList[index].testId.toString())));
                            } else {}
                          },
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Future<void> _refresh() async {
    testList.clear();
    this.getTestList();
  }

  getTestList() async {
    Map<String, dynamic> jsondat = {
      "batch_id": widget.batchID,
      "year_id": yearID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().testList,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        testList = (json.decode(response.body) as List)
            .map((data) => new TestPojo.fromJson(data))
            .toList();
        if (testList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }

  bottomSheetAddTest(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setBottomState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
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
                                    Navigator.of(context).pop();
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
                      isAdding
                          ? Container(
                              margin: EdgeInsets.all(50.0),
                              child: Center(child: CircularProgressIndicator()))
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: Text(
                                      dialogSms.toUpperCase(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                    ),
                                    child: TextField(
                                      minLines: 1,
                                      maxLines: 1,
                                      autofocus: false,
                                      obscureText: false,
                                      controller: _testName,
                                      onChanged: (String value) {
                                        if (value.length > 0) {
                                        } else {}
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: 'Enter activity name',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 2.0, 20.0, 2.0),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(16.0),
                                    alignment: Alignment.bottomRight,
                                    child: RaisedButton(
                                      onPressed: () {
                                        if (_testName.text.length > 0) {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          setBottomState(() {
                                            isAdding = true;
                                          });
                                          createNewTest();
                                        }
                                      },
                                      color: CustomColors.Colors.primaryColor,
                                      child: Text(
                                        "CREATE NOW",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  createNewTest() async {
    Map<String, dynamic> jsondat = {
      "batch_id": widget.batchID,
      "test_name": _testName.text,
      "year_id": yearID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().createTest,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (!body['error']) {
        Navigator.of(context).pop();
        setState(() {
          _testName.clear();
          isAdding = false;
          testList.clear();
          this.getTestList();
        });
      } else {
        setState(() {
          isAdding = false;
          dialogSms = body['message'];
        });
      }
    }
  }
}
