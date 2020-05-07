import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/models/ChilrenPojo.dart';
import 'package:subset/style/fonts.dart';
import 'package:http/http.dart' as http;
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/ChooseScreen.dart';
import 'package:subset/style/colors.dart' as CustomColors;

class ChildrenListScreen extends StatefulWidget {
  final String userType;
  final String mobileNumber;
  ChildrenListScreen(this.userType, this.mobileNumber, {Key key})
      : super(key: key);
  @override
  _ChildrenListScreenState createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends State<ChildrenListScreen> {
  bool isLoading = true;
  bool isFound = false;
  var childrenList = List<ChilrenPojo>();

  @override
  void initState() {
    super.initState();
    this._childrensList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select student",
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
                      child: InkWell(
                          //   onTap: _refresh,
                          child: Text(
                              "your mobile number is not reistered"
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: SubsetFonts().notfoundFont))),
                    )
                  : ListView.builder(
                      itemCount: childrenList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.black12,
                              backgroundImage: NetworkImage(
                                  Constants().profileImage +
                                      childrenList[index].image),
                            ),
                            title: Text(
                              childrenList[index].username,
                              style: TextStyle(
                                  fontFamily: SubsetFonts().titleFont),
                            ),
                            subtitle: Text(
                              "Date of birth : ".toUpperCase() +
                                  childrenList[index].birth.toUpperCase(),
                              style: TextStyle(
                                  fontFamily: SubsetFonts().descriptionFont),
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  FadeRouteBuilder(
                                      page: ChooseScreen(
                                          childrenList[index].userId,
                                          widget.userType)));
                            },
                          ),
                        );
                      })),
    );
  }

  _childrensList() async {
    setState(() {
      isLoading = true;
    });
    // set up POST request arguments
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {
      "mobile": widget.mobileNumber,
    };
    final response = await http.post(Constants().childrenList,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        childrenList = (json.decode(response.body) as List)
            .map((data) => new ChilrenPojo.fromJson(data))
            .toList();
        if (childrenList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }
}
