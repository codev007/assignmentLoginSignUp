import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:subset/models/ResultPojo.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/style/style.dart';
import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/urls/allUrls.dart';
import 'package:http/http.dart' as http;

class ReportDetailsPage extends StatefulWidget {
  final String userUID;
  final String testID;
  ReportDetailsPage(this.userUID, this.testID, {Key key}) : super(key: key);
  @override
  _ReportDetailsPageState createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  var resultData = List<ResultPojo>();
  bool isLoading = true;
  bool isFound = false;

  @override
  void initState() {
    this.getResultList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("Result",
            style: new TextStyle(
                fontFamily: SubsetFonts().toolbarFonts,
                color: CustomColors.Colors.primaryColor)),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : isFound
                ? Center(
                    child: Text(
                      "RESULT NOT UPLOADED YET :(",
                      style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                    ),
                  )
                : _details(),
      ),
    );
  }

  Widget _details() {
    return Container(
      child: Column(
        children: <Widget>[
          Style().spacer(),
          _header(),
          Style().spacer(),
          Expanded(child: Container(child: _resultData())),
          Style().spacer(),
          _footer()
        ],
      ),
    );
  }

  Widget _footer() {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              "Note :It is computer generated output",
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ),
          Container(
            child: Text(
              "'##' : Pass With Grace",
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultData() {
    return ListView.builder(
      itemCount: resultData[0].result.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            resultData[0].result[index].subjectName,
            style: TextStyle(fontFamily: SubsetFonts().titleFont),
          ),
          trailing: Text(
            resultData[0].result[index].marks+"/"+resultData[0].result[index].total,
            style: TextStyle(fontFamily: SubsetFonts().titleFont),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 5.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.7,
                  child: Text(resultData[0].name,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: new TextStyle(
                        fontFamily: SubsetFonts().titleFont,
                        fontSize: 18.0,
                        color: CustomColors.Colors.primaryColor,
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.7,
                  child: Text(
                    resultData[0].testName,
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.black54,
                        fontFamily: SubsetFonts().titleFont),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Container(
                  child: Text("Exam date : " + resultData[0].createdAt,
                      style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.black54,
                          fontFamily: SubsetFonts().titleFont)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getResultList() async {
    Map<String, dynamic> jsondat = {
      "user_uid": widget.userUID,
      "test_id": widget.testID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().fetchResult,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        resultData = (json.decode(response.body) as List)
            .map((data) => new ResultPojo.fromJson(data))
            .toList();
        if (resultData[0].result.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }
}
