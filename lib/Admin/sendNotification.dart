import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/NotificationPojo.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:http/http.dart' as http;
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/views/FirebaseMessagingService.dart';
import 'package:subset/views/helperViews/nointernet.dart';

class SendNotification extends StatefulWidget {
  final String coachingID;
  final int screentype;
  SendNotification(this.coachingID, this.screentype, {Key key})
      : super(key: key);
  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  bool isLoading = true;
  bool isFound = false;
  String yearID;
  var listView = List<NotificationPojo>();
  TextEditingController _title = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  _userdata() async {
    String yearid = await SharedDatabase().getYearID();

    setState(() {
      yearID = yearid;
    });
    this._loadData(widget.coachingID);
  }

  @override
  void initState() {
    this._userdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            elevation: 1,
            title: new Text("Notifications",
                style: new TextStyle(
                    color: CustomColors.Colors.primaryColor,
                    fontFamily: SubsetFonts().toolbarFonts))),
        body: Container(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : isFound
                  ? Center(
                      child: InkWell(
                          onTap: _refresh,
                          child: Text(
                            "Notification not found\nTap to refresh",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: SubsetFonts().notfoundFont),
                          )),
                    )
                  : RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        itemCount: listView.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              _notificationDetails(context, listView[index]);
                            },
                            title: Text(
                              listView[index].title,
                              style: TextStyle(fontFamily: SubsetFonts().titleFont),
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              listView[index].description,
                              style: TextStyle(fontFamily: SubsetFonts().descriptionFont),
                              maxLines: 4,
                            ),
                          );
                        },
                      ),
                    ),
        ),
        floatingActionButton: widget.screentype == 1
            ? FloatingActionButton(
                onPressed: () {
                  _createNotification(context);
                },
                child: Icon(Icons.add),
              )
            : Text(""));
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
      isFound = false;
    });
    listView.clear();
    this._loadData(widget.coachingID);
  }

  _loadData(String id) async {
    Map<String, dynamic> jsondat = {"coaching_id": id};
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(Constants().fetchNotification,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          listView = (json.decode(response.body) as List)
              .map((data) => new NotificationPojo.fromJson(data))
              .toList();
          if (listView.length > 0) {
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

  _notificationDetails(BuildContext context, NotificationPojo data) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (BuildContext bc) {
          return SingleChildScrollView(
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
                                Navigator.pop(context);
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
                  Container(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 10.0, bottom: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text("TITLE",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.title,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 18.0,fontFamily: SubsetFonts().titleFont)),
                        ),
                        Divider(),
                        Container(
                          child: Text("DESCRIPTION",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.description,
                              style: new TextStyle(
                                  color: Colors.black54, fontSize: 18.0,fontFamily: SubsetFonts().descriptionFont)),
                        ),
                        Divider(),
                        Container(
                          child: Text("CREATED AT ",
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0)),
                        ),
                        Container(
                          child: Text(data.createdAt,
                              style: new TextStyle(
                                  color: Colors.black54, fontSize: 18.0,fontFamily: SubsetFonts().timeFont)),
                        ),
                        Divider(),
                        widget.screentype == 1
                            ? Container(
                                margin: EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5.0),
                                        child: FlatButton(
                                          onPressed: () {
                                            _delete(data.notificationId);
                                          },
                                          child: Text(
                                            "DELETE NOTIFICATION",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: CustomColors
                                                    .Colors.primaryColor),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _createNotification(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (BuildContext bc) {
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
                                Navigator.pop(context);
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
                  Container(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Wrap(
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 10.0),
                                          child: Text("TITLE",
                                              style: new TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5.0, bottom: 5.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                          ),
                                          child: TextFormField(
                                            minLines: 1,
                                            maxLines: 2,
                                            controller: _title,
                                            autofocus: true,
                                            obscureText: false,
                                            onChanged: (String value) {
                                              if (value.length > 0) {
                                              } else {}
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: 'Notification title',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      20.0, 2.0, 20.0, 2.0),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              right: 15.0,
                                              top: 10.0),
                                          child: Text("DESCRIPTION",
                                              style: new TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5.0, bottom: 5.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white24,
                                          ),
                                          child: TextFormField(
                                            minLines: 1,
                                            maxLines: 2,
                                            controller: _description,
                                            autofocus: false,
                                            obscureText: false,
                                            onChanged: (String value) {
                                              if (value.length > 0) {
                                              } else {}
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText:
                                                  'Notification description',
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5.0),
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      _send(_title.text,
                                                          _description.text);
                                                    },
                                                    child: Text(
                                                      "SEND NOTIFICATION",
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: CustomColors
                                                              .Colors
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _send(String title, String description) async {
    Fluttertoast.showToast(
        msg: "Sending...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1);
    Map<String, dynamic> jsondat = {
      "coaching_id": widget.coachingID,
      "title": title,
      "description": description,
      "year_id": yearID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(Constants().sendNotification,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        _title.clear();
        _description.clear();
        Navigator.of(context).pop();
        var body = json.decode(response.body);
        if (!body['error']) {
          this._refresh();
          sendAndRetrieveMessage(
              title, description, '/topics/' + widget.coachingID);
        }
        Fluttertoast.showToast(
            msg: body['message'].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1);
      }
    } on SocketException {
      Navigator.of(context).push(FadeRouteBuilder(page: NoInternetScreen()));
    }
  }

  _delete(int id) async {
    Fluttertoast.showToast(
        msg: "Sending...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1);
    Map<String, dynamic> jsondat = {"id": id};
    Map<String, String> headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(Constants().deleteNotification,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        var body = json.decode(response.body);
        if (!body['error']) {
          this._refresh();
        }
        Fluttertoast.showToast(
            msg: body['message'].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1);
      }
    } on SocketException {
      Navigator.of(context).push(FadeRouteBuilder(page: NoInternetScreen()));
    }
  }
}
