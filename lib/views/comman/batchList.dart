import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:subset/Admin/StudentPage.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/models/AttendanceBatchPojo.dart';
import 'package:http/http.dart' as http;
import 'package:subset/models/classModel.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/TeacherViews/takeAttendance.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/views/comman/testList.dart';

class BatchListView extends StatefulWidget {
  final String coachingID;
  //-------------ONE FOR ATTENDANCE AND TWO FOR RESULT-------------------
  final int screenType;
  BatchListView(this.coachingID, this.screenType, {Key key}) : super(key: key);
  @override
  _BatchListViewState createState() => _BatchListViewState();
}

class _BatchListViewState extends State<BatchListView> {
  var batchList = List<AttendanceBatchPojo>();
  var classList = List<ClassModel>();
  bool isLoading = true;
  bool isAdding = false;
  bool isUpdating = false;
  bool isFound = false;
  var myFormat = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
  int _classID = 1;
  TextEditingController batchName = new TextEditingController();
  TextEditingController updatebatchName = new TextEditingController();

  _submitDesign() {
    return Container(
      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: CustomColors.Colors.primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          )),
      child: Text("SUBMITTED",
          style: TextStyle(
              fontSize: 12.0, color: CustomColors.Colors.primaryColor)),
    );
  }

  _openDesign() {
    return Container(
      padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: CustomColors.Colors.primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          )),
      child: Text("OPEN",
          style: TextStyle(
              fontSize: 12.0, color: CustomColors.Colors.primaryColor)),
    );
  }

  @override
  void initState() {
    this.getBatchListFromApi();
    this._getClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          elevation: 1.0,
          title: Text("Select Batch",
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
                      "Batches not added yet".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      itemCount: batchList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(batchList[index].batchName,style: TextStyle(fontFamily: SubsetFonts().titleFont),),
                          subtitle: Text(batchList[index].className,style: TextStyle(fontFamily: SubsetFonts().descriptionFont),),
                          trailing: widget.screenType == 1
                              ? batchList[index].value
                                  ? _submitDesign()
                                  : _openDesign()
                              : widget.screenType == 4
                                  ? IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        smsCodeDialog(context,batchList[index]);
                                        setState(() {
                                          updatebatchName.text=batchList[index].batchName;
                                        });
                                      })
                                  : Text(""),
                          onTap: () {
                            if (widget.screenType == 1) {
                              Navigator.of(context).pushReplacement(
                                  FadeRouteBuilder(
                                      page: AttendancePage(
                                          batchList[index].batchId.toString(),
                                          batchList[index].value)));
                            } else if (widget.screenType == 2) {
                              Navigator.of(context).push(FadeRouteBuilder(
                                  page: TextListView(
                                      batchList[index].classId.toString(),
                                      batchList[index].batchId.toString(),
                                      1,
                                      "userUid")));
                            } else if (widget.screenType == 3) {
                              Navigator.of(context).push(FadeRouteBuilder(
                                  page: StudentViewList(widget.coachingID,
                                      batchList[index].batchId.toString())));
                            } else if (widget.screenType == 5) {
                              Navigator.of(context).push(FadeRouteBuilder(
                                  page: TextListView(
                                      batchList[index].classId.toString(),
                                      batchList[index].batchId.toString(),
                                      3,
                                      "userUid")));
                            } else {}
                          },
                        );
                      },
                    ),
                  ),
      ),
      floatingActionButton: widget.screenType == 4
          ? FloatingActionButton(
              onPressed: () {
                _createBatchesBottomBar();
              },
              child: Icon(Icons.add),
            )
          : Container(),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading=true;
    });
    batchList.clear();
    this.getBatchListFromApi();
  }

  getBatchListFromApi() async {
    Map<String, dynamic> jsondat = {
      "coaching_id": widget.coachingID,
      "date": "${myFormat.format(selectedDate.toLocal())}"
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().fetchBatches,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        batchList = (json.decode(response.body) as List)
            .map((data) => new AttendanceBatchPojo.fromJson(data))
            .toList();
        if (batchList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }

  _createBatchesBottomBar() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (contex) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text("ADD NEW BATCH"),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButton(
                        hint: Text(
                          "Select Class",
                          style: TextStyle(color: Colors.grey),
                        ),
                        items: classList.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item.className),
                            value: item.classId,
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _classID = newVal;
                          });
                        },
                        value: _classID,
                      ),
                    ),
                    Container(
                      child: TextField(
                        autofocus: true,
                        controller: batchName,
                        decoration:
                            InputDecoration(hintText: "Enter Batch Name"),
                      ),
                    ),
                    isAdding
                        ? Container(
                            child: SizedBox(
                              height: 15.0,
                              width: 15.0,
                              child: Center(
                                child: new CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor:
                                      AlwaysStoppedAnimation(CustomColors.Colors.primaryColor),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: RaisedButton(
                              color: CustomColors.Colors.primaryColor,
                              child: Text(
                                "Add Batch",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (batchName.text.length > 0) {
                                  setStates(() {
                                    isAdding = true;
                                  });
                                  _createNewClass(batchName.text);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Batch name empty",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIos: 1);
                                }
                              },
                            ),
                          )
                  ],
                ),
              ),
            );
          });
        });
  }

  _getClasses() async {
    Map<String, dynamic> jsondat = {
      "coaching_id": widget.coachingID,
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().fetchClasses,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      setState(() {
        classList = (json.decode(response.body) as List)
            .map((data) => new ClassModel.fromJson(data))
            .toList();

        if (classList.length > 0) {
          isLoading = false;
        } else {
          isLoading = false;
          isFound = true;
        }
      });
    }
  }

  void _createNewClass(String text) async {
    Map<String, dynamic> jsondat = {
      "batch_name": text,
      "coaching_id": widget.coachingID,
      "class_id": _classID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().createBatches,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (!body['error']) {
        setState(() {
          isAdding = false;
        });
        batchName.clear();
        Navigator.of(context).pop();
        _refresh();
      }
      Fluttertoast.showToast(
          msg: body['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1);
    }
  }

  void _updateBatchName(String batchID, String name, String classID) async {
    Map<String, dynamic> jsondat = {
      "batch_id": batchID,
      "batch_name": name,
      "coaching_id": widget.coachingID,
      "class_id": classID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().updateBatchName,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (!body['error']) {
        batchName.clear();
        Navigator.of(context).pop();
        _refresh();
      }
      setState(() {
        isUpdating = false;
      });
      Fluttertoast.showToast(
          msg: body['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1);
    }
  }

  smsCodeDialog(BuildContext context, AttendanceBatchPojo batchList) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
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
                                    setBottomState(() {
                                      isUpdating = false;
                                    });
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
                      isUpdating
                          ? Container(
                              margin: EdgeInsets.all(50.0),
                              child: Center(child: CircularProgressIndicator()))
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: Text(
                                      "PLEASE ENTER NEW BATCH NAME",
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
                                      controller: updatebatchName,
                                      obscureText: false,
                                      onChanged: (String value) {},
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: 'Please enter new batch name',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 2.0, 20.0, 2.0),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    alignment: Alignment.center,
                                    child: RaisedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (updatebatchName.text.length > 0) {
                                          setBottomState(() {
                                            isUpdating = true;
                                          });
                                          _updateBatchName(
                                              batchList.batchId.toString(),
                                              updatebatchName.text,
                                              batchList.classId.toString());
                                        }else{
                                          Fluttertoast.showToast(
                                              msg: "Empty name",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIos: 1);
                                        }
                                      },
                                      color: CustomColors.Colors.primaryColor,
                                      child: Text(
                                        "UPDATE NEW BATCH NAME",
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
}
