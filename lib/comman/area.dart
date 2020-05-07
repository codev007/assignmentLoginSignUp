import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/models/Area.dart';
import 'package:http/http.dart' as http;
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/AddmissionRequest.dart';
import 'package:subset/views/RegistrationCoaching.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/views/helperViews/nointernet.dart';

class AreaScreen extends StatefulWidget {
  final String userID;
  final String userType;
  final String districtID;
  final String stateID;
  final String contactNo;
  AreaScreen(
      this.userID, this.userType, this.districtID, this.stateID, this.contactNo,
      {Key key})
      : super(key: key);

  @override
  _AreaScreenState createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  bool isLoading = true;
  bool isFound = false;
  var areaList = List<AreaPojo>();

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
        title: Text("Choose Area",
            style: new TextStyle(
                fontFamily: SubsetFonts().toolbarFonts,
                color: CustomColors.Colors.primaryColor)),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: Text("Area not available yet\nWe will be there soon".toUpperCase(),
                              textAlign: TextAlign.center,style: TextStyle(fontFamily: SubsetFonts().notfoundFont),),
                )
              : ListView.builder(
                  itemCount: areaList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(areaList[index].areaName,style: TextStyle(fontFamily: SubsetFonts().titleFont),),
                      onTap: () {
                        if (widget.userType == 'A') {
                          Navigator.of(context).pushReplacement(
                              FadeRouteBuilder(
                                  page: RegisterCoaching(
                                      widget.contactNo,
                                      widget.stateID,
                                      widget.districtID,
                                      areaList[index].areaId.toString())));
                        } else {
                          Navigator.of(context).push(FadeRouteBuilder(
                              page: AddmissionRequest(
                                  widget.userID,
                                  widget.userType,
                                  widget.stateID,
                                  widget.districtID,
                                  areaList[index].areaId.toString())));
                        }
                      },
                    );
                  }),
    );
  }

  fetchData() async {
    Map<String, dynamic> jsondat = {"type": 'A', "id": widget.districtID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(Constants().fetchLocation,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          areaList = (json.decode(response.body) as List)
              .map((data) => new AreaPojo.fromJson(data))
              .toList();
          if (areaList.length > 0) {
            isLoading = false;
          } else {
            isLoading = false;
            isFound = true;
          }
        });
      }
    } on SocketException {
      Navigator.of(context)
          .push(FadeRouteBuilder(page: NoInternetScreen()));
    }
  }
}
