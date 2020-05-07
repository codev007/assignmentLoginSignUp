import 'dart:convert';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:flutter/material.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/models/AdmissionCoachingList.dart';
import 'package:subset/models/batchList.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/FirebaseMessagingService.dart';
import 'package:subset/views/helperViews/successful.dart';
import 'package:uuid/uuid.dart';

class AddmissionRequest extends StatefulWidget {
  final String userID;
  final String userType;
  final String stateID;
  final String disctID;
  final String areaID;

  AddmissionRequest(
      this.userID, this.userType, this.stateID, this.disctID, this.areaID,
      {Key key})
      : super(key: key);
  @override
  _AddmissionRequestState createState() => _AddmissionRequestState();
}

class _AddmissionRequestState extends State<AddmissionRequest> {
  var fetchCoachingList = new List<AdmissionCoachingList>();
  var batchList = new List<BatchList>();
  bool isLoading = true;
  bool isFound = false;
  String message;
  String coachingId;
  String batchId;
  String batchName;
  String coachingName;
  String titleme = "Select Coaching";
  var uuid = Uuid();

  var myFormat = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy');

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1980, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _requestScreenPages() {
    if (batchId == null && coachingId == null) {
      return isFound
          ? Center(
              child: Text(message.toUpperCase(),
                              textAlign: TextAlign.center,),
            )
          : ListView.builder(
              itemCount: fetchCoachingList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(fetchCoachingList[index].coachingName,style: TextStyle(fontFamily: SubsetFonts().titleFont),),
                  subtitle: Text(fetchCoachingList[index].address,style: TextStyle(fontFamily: SubsetFonts().descriptionFont),),
                  onTap: () {
                    setState(() {
                      titleme = "Select Your Batch";
                      coachingId = fetchCoachingList[index].coachingId;
                      coachingName = fetchCoachingList[index].coachingName;
                    });
                    this.getBatchListFromApi();
                  },
                );
              },
            );
    } else if (coachingId != null && batchId == null) {
      return isFound
          ? Center(
              child: Text(message.toUpperCase(),
                              textAlign: TextAlign.center,),
            )
          : ListView.builder(
              itemCount: batchList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(batchList[index].batchName,style: TextStyle(fontFamily: SubsetFonts().titleFont),),
                  onTap: () {
                    setState(() {
                      titleme = "Send Application";
                      batchName = batchList[index].batchName;
                      batchId = batchList[index].batchId.toString();
                    });
                  },
                );
              },
            );
    } else if (coachingId != null && batchId != null) {
      return Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text("INSTITUTE NAME",
                  style: new TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            Container(
              child: Text(
                coachingName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: SubsetFonts().titleFont),
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text("BATCH NAME",
                  style: new TextStyle(color: Colors.grey, fontSize: 12.0)),
            ),
            Container(
              child: Text(
                batchName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: SubsetFonts().titleFont),
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Date of admission  : ".toUpperCase(),
                    style: TextStyle(fontFamily: "RobotoMedium"),
                  ),
                  Expanded(
                      child:
                          Text("${myFormat.format(selectedDate.toLocal())}",style: TextStyle(fontFamily: SubsetFonts().titleFont),)),
                  SizedBox(
                    height: 20.0,
                  ),
                  IconButton(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.date_range),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                "Your request will be sent to coaching administration . Please wait until it verified",
                textAlign: TextAlign.center
    ,style: TextStyle(fontFamily: SubsetFonts().linkFonts),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                color: CustomColors.Colors.primaryColor,
                onPressed: () {
                  String user_uid = uuid.v1();
                  String year_id = formatter.format(now);
                  _sendAdmissionRequest(
                      user_uid,
                      widget.userID,
                      batchId,
                      "${myFormat.format(selectedDate.toLocal())}",
                      year_id,
                      widget.userType,
                      coachingId);
                },
                child: Text(
                  "SUBMIT APPLICATION",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        height: 200.0,
        width: 200.0,
        color: Colors.black54,
      );
    }
  }

  getBatchListFromApi() async {
    setState(() {
      isLoading = true;
      isFound = false;
    });
    Map<String, dynamic> jsondat = {"coaching_id": coachingId};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().chooseBatchList,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        batchList = (json.decode(response.body) as List)
            .map((data) => new BatchList.fromJson(data))
            .toList();
        if (batchList.length > 0) {
          isFound = false;
        } else {
          message = "Batches not added yet\nPlease wait";
          isFound = true;
        }
        isLoading = false;
      });
    }
  }

  getCoachingListFromApi() async {
    setState(() {
      isLoading = true;
      isFound = false;
    });

    Map<String, dynamic> jsondat = {
      "mobile": widget.stateID + widget.disctID + widget.areaID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().chooseCoachingList,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        fetchCoachingList = (json.decode(response.body) as List)
            .map((data) => new AdmissionCoachingList.fromJson(data))
            .toList();
        if (fetchCoachingList.length > 0) {
          isFound = false;
        } else {
          isFound = true;
          message = "Coaching not found\nin this area";
        }
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    this.getCoachingListFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 1.0,
          title: Text(titleme,
              style: new TextStyle(
                  fontFamily: "RobotoRegular",
                  color: CustomColors.Colors.primaryColor)),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _requestScreenPages());
  }

  _sendAdmissionRequest(
      String user_uid,
      String user_id,
      String batch_id,
      String admission_date,
      String year_id,
      String user_type,
      String coaching_id) async {
    setState(() {
      isLoading = true;
    });
    // set up POST request arguments
    String url = Constants().apply;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {
      "user_uid": user_uid,
      "user_id": user_id,
      "batch_id": batch_id,
      "admission_date": admission_date,
      "year_id": year_id,
      "user_type": user_type,
      "coaching_id": coaching_id,
      "status": "0"
    };
    http.Response response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (!body['error']) {
        String title = 'New admission request';
        sendAndRetrieveMessage(
            title, "Verify the request now", '/topics/' + coaching_id + 'A');
      }
      Navigator.of(context).pushReplacement(FadeRouteBuilder(
          page: RequestedSuccessfully(body['error'], body['message'])));
    }

    setState(() {
      isLoading = false;
    });
  }
}
