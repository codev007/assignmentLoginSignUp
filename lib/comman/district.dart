import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/comman/area.dart';
import 'package:subset/models/DistrictPojo.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/views/helperViews/nointernet.dart';

class DistrictScreen extends StatefulWidget {
  final String userID;
  final String userType;
  final String stateID;
  final String contactNo;
  DistrictScreen(this.userID, this.userType, this.stateID, this.contactNo,
      {Key key})
      : super(key: key);

  @override
  _DistrictScreenState createState() => _DistrictScreenState();
}

class _DistrictScreenState extends State<DistrictScreen> {
  bool isLoading = true;
  bool isFound = false;

  var districtList = List<DistrictPojo>();
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
          title: Text("Choose city",
              style: new TextStyle(
                  fontFamily: SubsetFonts().toolbarFonts,
                  color: CustomColors.Colors.primaryColor))),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child:
                      Text("Districts not available yet\nWe will be there soon".toUpperCase(),
                              textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: SubsetFonts().titleFont),),
                )
              : ListView.builder(
                  itemCount: districtList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(districtList[index].distName,style: TextStyle(fontFamily: SubsetFonts().titleFont),),
                      onTap: () {
                        Navigator.of(context).push(FadeRouteBuilder(
                            page: AreaScreen(
                                widget.userID,
                                widget.userType,
                                districtList[index].distId.toString(),
                                widget.stateID,
                                widget.contactNo)));
                      },
                    );
                  }),
    );
  }

  fetchData() async {
    Map<String, dynamic> jsondat = {"type": 'D', "id": widget.stateID};
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
