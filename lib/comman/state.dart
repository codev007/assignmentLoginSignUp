import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/comman/district.dart';
import 'package:subset/models/StatePojo.dart';
import 'package:http/http.dart' as http;
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/views/helperViews/nointernet.dart';

class StateListScreen extends StatefulWidget {
  final String userID;
  final String userType;
  final String contactNo;
  StateListScreen(this.userID, this.userType, this.contactNo, {Key key})
      : super(key: key);

  @override
  _StateListScreenState createState() => _StateListScreenState();
}

class _StateListScreenState extends State<StateListScreen> {
  bool isLoading = true;
  bool isFound = false;
  var stateList = List<StatePojo>();

  @override
  void initState() {
    this.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text("Choose State",
            style: new TextStyle(
              fontFamily: SubsetFonts().toolbarFonts,
              color: CustomColors.Colors.primaryColor,
            )),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: Text(
                    "States not found yet\nWe will there soon".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                  ),
                )
              : ListView.builder(
                  itemCount: stateList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        stateList[index].stateName,
                        style: TextStyle(fontFamily: SubsetFonts().titleFont),
                      ),
                      onTap: () {
                        Navigator.of(context).push(FadeRouteBuilder(
                            page: DistrictScreen(
                                widget.userID,
                                widget.userType,
                                stateList[index].stateId.toString(),
                                widget.contactNo)));
                      },
                    );
                  }),
    );
  }

  fetchData() async {
    Map<String, dynamic> jsondat = {"type": 'S', "id": widget.userID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(Constants().fetchLocation,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          stateList = (json.decode(response.body) as List)
              .map((data) => new StatePojo.fromJson(data))
              .toList();
          if (stateList.length > 0) {
            isLoading = false;
          } else {
            isLoading = false;
            isFound = true;
          }
        });
      }
    } on SocketException {
      Navigator.of(context).push(FadeRouteBuilder(page: NoInternetScreen()));
    }
  }
}
