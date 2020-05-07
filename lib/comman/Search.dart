import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/Area.dart';
import 'package:subset/models/DistrictPojo.dart';
import 'package:subset/models/StatePojo.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/style/colors.dart' as CustomColors;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isALoading = true;
  bool isAFound = false;
  var stateList = List<StatePojo>();
  var districtList = List<DistrictPojo>();
  var areaList = List<AreaPojo>();
  String message = "States not found yet\nWe will there soon";
  String stateID;
  String districtID;
  String areaID;
  
  @override
  void initState() {
    this.fetchStateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 1.0,
        title: Text(
          "Choose Loaction",
          style: TextStyle(fontFamily: SubsetFonts().toolbarFonts,color: CustomColors.Colors.primaryColor),
        ),
      ),
      body: isALoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isAFound
              ? Center(
                  child: Text(
                    message.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                )
              : stateID == null
                  ? ListView.builder(
                      itemCount: stateList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            stateList[index].stateName,
                            style:
                                TextStyle(fontFamily: SubsetFonts().titleFont),
                          ),
                          onTap: () {
                            setState(() {
                              isALoading = true;
                              stateID = stateList[index].stateId.toString();
                            });
                            fetchDistrictData();
                          },
                        );
                      })
                  : districtID == null && stateID != null
                      ? ListView.builder(
                          itemCount: districtList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                districtList[index].distName,
                                style: TextStyle(
                                    fontFamily: SubsetFonts().titleFont),
                              ),
                              onTap: () {
                                setState(() {
                                  isALoading = true;
                                  districtID =
                                      districtList[index].distId.toString();
                                });
                                fetchData();
                              },
                            );
                          })
                      : areaID == null && districtID != null
                          ? ListView.builder(
                              itemCount: areaList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    areaList[index].areaName,
                                    style: TextStyle(
                                        fontFamily: SubsetFonts().titleFont),
                                  ),
                                  onTap: () {
                                    SharedDatabase().setLocationID(stateID +
                                        districtID +
                                        areaList[index].areaId.toString());
                                    Navigator.pop(
                                        context,
                                        stateID +
                                            districtID +
                                            areaList[index].areaId.toString());
                                  },
                                );
                              })
                          : Container(),
    );
  }

  fetchStateData() async {
    Map<String, dynamic> jsondat = {"type": 'S', "id": "userID"};
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
            isAFound = false;
          } else {
            isAFound = true;
          }
          isALoading = false;
        });
      }
    } on SocketException {}
  }

  fetchDistrictData() async {
    Map<String, dynamic> jsondat = {"type": 'D', "id": stateID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(Constants().fetchLocation,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          districtList = (json.decode(response.body) as List)
              .map((data) => new DistrictPojo.fromJson(data))
              .toList();
          if (districtList.length > 0) {
            isAFound = false;
          } else {
            isAFound = true;
            message = "Districts not available yet\nWe will be there soon";
          }
          isALoading = false;
        });
      }
    } on SocketException {}
  }

  fetchData() async {
    Map<String, dynamic> jsondat = {"type": 'A', "id": districtID};
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
            isAFound = false;
          } else {
            isAFound = true;
            message = "Area not available yet\nWe will be there soon";
          }
          isALoading = false;
        });
      }
    } on SocketException {}
  }
}
