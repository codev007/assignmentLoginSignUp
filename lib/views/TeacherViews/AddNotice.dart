import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/style/fonts.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/FirebaseMessagingService.dart';
import 'package:subset/views/helperViews/ImageHelper.dart';
import 'package:subset/views/helperViews/successful.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class AddNotice extends StatefulWidget {
  @override
  _AddNoticeState createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  bool isActiveNodeOne = false;
  bool isActiveNodeTwo = false;
  List batchList = new List();
  bool isLoading = false;
  var uuid = Uuid();
  final FocusNode titleNode = FocusNode();
  final FocusNode descriptionNode = FocusNode();
  String _batchID;
  String coachingID;
  String userUID;
  String type = "";
  var now = new DateTime.now();
  String yearID;
  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController link = new TextEditingController();
  String noticeUUID = "";
  bool isSwitched = false;
  Map<String, String> _paths;
  List<File> images = new List();
  List<String> file = [];
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = true;
  bool _hasValidMime = false;
  FileType _pickingType = FileType.IMAGE;
  String _fileName;
  String _path;
  bool isLinkOpen = false;
  int attachType = 1;

  _data() async {
    String cid = await SharedDatabase().getCoachingID();
    String uid = await SharedDatabase().getUID();
    String year = await SharedDatabase().getYearID();

    setState(() {
      coachingID = cid;
      userUID = uid;
      yearID = year;
    });
    this.getSWData();
  }

  _switchOnStyle() {
    return TextStyle(
        color: CustomColors.Colors.primaryColor,
        fontSize: 18.0,
        fontFamily: SubsetFonts().titleFont,
        fontStyle: FontStyle.normal);
  }

  _switchOffStyle() {
    return TextStyle(color: Colors.grey, fontSize: 15.0);
  }

  @override
  void initState() {
    this._data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            child: isActiveNodeOne && isActiveNodeTwo && !isLoading
                ? FlatButton(
                    splashColor: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0)),
                    color: CustomColors.Colors.primaryColor,
                    onPressed: () async {
                      if (_batchID != null) {
                        if (isSwitched) {
                          setState(() {
                            type = "A";
                          });
                        } else {
                          setState(() {
                            type = "N";
                          });
                        }
                        noticeUUID = uuid.v1();
                        if (_paths != null) {
                          for (int i = 0; i < _paths.length; i++) {
                            List<int> imageBytesorg = await ImageHelper()
                                .compressImage(images[i].readAsBytesSync());

                            String imageorg = base64Encode(imageBytesorg);
                            setState(() {
                              file.add(imageorg);
                            });
                          }
                        }

                        _postNoticeDataToServer(
                            noticeUUID,
                            title.text,
                            description.text,
                            userUID,
                            int.parse(_batchID),
                            type,
                            yearID);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Select Batch",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1);
                      }
                    },
                    //          alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    //            width: MediaQuery.of(context).size.width,
                    child: Text(
                      "SUBMIT",
                      style: new TextStyle(
                          color: CustomColors.Colors.white,
                          fontSize: 13.0,
                          fontFamily: "RobotoRegular"),
                    ),
                  )
                : Text(""),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: SpinKitRing(
              size: MediaQuery.of(context).size.width / 2,
              color: CustomColors.Colors.primaryColor,
            ))
          : SingleChildScrollView(
              child: Form(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15.0, top: 15.0),
                        child: Text(
                          "Add Notice \n& Assignment",
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontFamily: SubsetFonts().titleFont),
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Notice",
                                style: !isSwitched
                                    ? _switchOnStyle()
                                    : _switchOffStyle(),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(5.0),
                              child: Switch(
                                value: isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                  });
                                },
                                activeTrackColor: Colors.black38,
                                activeColor: CustomColors.Colors.primaryColor,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Assignment",
                                style: isSwitched
                                    ? _switchOnStyle()
                                    : _switchOffStyle(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: DropdownButton(
                          hint: Text(
                            "Select Batch",
                            style: TextStyle(color: Colors.grey),
                          ),
                          items: batchList.map((item) {
                            return new DropdownMenuItem(
                              child: Text(item['batch_name']),
                              value: item['batch_id'].toString(),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _batchID = newVal;
                            });
                          },
                          value: _batchID,
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(left: 15.0, top: 15.0),
                        child: Text(
                          "Write Title Here",
                          style: new TextStyle(fontSize: 12.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                        ),
                        child: TextFormField(
                          autofocus: false,
                          obscureText: false,
                          focusNode: titleNode,
                          controller: title,
                          onChanged: (String value) {
                            if (value.length > 0) {
                              setState(() {
                                isActiveNodeOne = true;
                              });
                            } else {
                              setState(() {
                                isActiveNodeOne = false;
                              });
                            }
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Title goes here',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, titleNode, descriptionNode);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Write Description Here",
                          style: new TextStyle(fontSize: 12.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                        ),
                        child: TextFormField(
                          focusNode: descriptionNode,
                          minLines: 3,
                          maxLines: 5,
                          controller: description,
                          textInputAction: TextInputAction.done,
                          autofocus: false,
                          obscureText: false,
                          onChanged: (String value) {
                            if (value.length > 0) {
                              setState(() {
                                isActiveNodeTwo = true;
                              });
                            } else {
                              setState(() {
                                isActiveNodeTwo = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Description goes here',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 4,
                              color: Colors.grey,
                              height: 1.0,
                            ),
                            Container(
                              margin: EdgeInsets.all(5.0),
                              child: Text(
                                "Attach Documents",
                                style: new TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4,
                              color: Colors.grey,
                              height: 1.0,
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: IconButton(
                                  tooltip: "Add Gallery Image",
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    _openFileExplorer();
                                  },
                                  padding: EdgeInsets.all(10),
                                  icon: Icon(
                                    Icons.photo,
                                    color: Colors.black54,
                                  )),
                            ),
                            IconButton(
                                tooltip: "Add Link",
                                onPressed: () {
                                  setState(() {
                                    images.clear();
                                    isLinkOpen = true;
                                  });
                                },
                                padding: EdgeInsets.all(10),
                                icon: Icon(
                                  Icons.link,
                                  color: Colors.black54,
                                )),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        child: isLinkOpen
                            ? Container(
                                margin: EdgeInsets.only(bottom: 20.0),
                                child: TextField(
                                  //               focusNode: _descriptionNode,
                                  minLines: 3,
                                  maxLines: 5,
                                  controller: link,
                                  textInputAction: TextInputAction.done,
                                  autofocus: false,
                                  obscureText: false,
                                  onChanged: (String value) {
                                    if (value.length > 0) {
                                      setState(() {
                                        attachType = 2;
                                      });
                                    } else {}
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: 'Paste Link Here...',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    border: InputBorder.none,
                                  ),
                                ),
                              )
                            : Container(
                                //      width: MediaQuery.of(context).size.width,
                                height: 120.0,
                                child: new Builder(
                                  builder: (BuildContext context) =>
                                      _loadingPath
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child:
                                                  const CircularProgressIndicator())
                                          : _path != null || _paths != null
                                              ? new Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 30.0),
                                                  //        height: MediaQuery.of(context).size.height * 0.50,
                                                  child: new Scrollbar(
                                                      child: new ListView
                                                          .separated(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: _paths != null &&
                                                            _paths.isNotEmpty
                                                        ? _paths.length
                                                        : 1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final bool isMultiPath =
                                                          _paths != null &&
                                                              _paths.isNotEmpty;
                                                      final String name =
                                                          'File $index: ' +
                                                              (isMultiPath
                                                                  ? _paths.keys
                                                                          .toList()[
                                                                      index]
                                                                  : _fileName ??
                                                                      '...');
                                                      final path = isMultiPath
                                                          ? _paths.values
                                                              .toList()[index]
                                                              .toString()
                                                          : _path;
                                                      images.add(File(_paths
                                                          .values
                                                          .toList()[index]
                                                          .toString()));
                                                      return Container(
                                                        margin: EdgeInsets.all(
                                                            10.0),
                                                        child: CircleAvatar(
                                                          radius: 35.0,
                                                          backgroundImage:
                                                              FileImage(
                                                                  File(path)),
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            new Divider(),
                                                  )),
                                                )
                                              : new Container(),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _postNoticeDataToServer(String noticeId, String title, String description,
      String user_uid, int batch_id, String type, String year_id) async {
    setState(() {
      isLoading = true;
    });
    String url = Constants().notice;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat;
    if (file == null) {
    } else if (file != null) {}
    if (file.length > 0) {
      jsondat = {
        "notice_id": noticeId,
        "title": title,
        "description": description,
        "user_uid": user_uid,
        "batch_id": batch_id,
        "type": type,
        "year_id": year_id,
        "file": file,
        "fileType": "F"
      };
    } else if (attachType == 2) {
      jsondat = {
        "notice_id": noticeId,
        "title": title,
        "description": description,
        "user_uid": user_uid,
        "batch_id": batch_id,
        "type": type,
        "year_id": year_id,
        "file": link.text,
        "fileType": "L"
      };
    } else {
      jsondat = {
        "notice_id": noticeId,
        "title": title,
        "description": description,
        "user_uid": user_uid,
        "batch_id": batch_id,
        "type": type,
        "year_id": year_id,
        "file": "",
        "fileType": "N"
      };
    }

    http.Response response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    var body = jsonDecode(response.body);

    if (!body['error']) {
      String titlea = type == 'A' ? 'New Assignment added' : 'New Notice added';
      sendAndRetrieveMessage(titlea, title, '/topics/$batch_id$year_id');
    }
    Navigator.of(context).pushReplacement(FadeRouteBuilder(
        page: RequestedSuccessfully(body['error'], body['message'])));
    setState(() {
      isLoading = false;
    });
  }

  Future<String> getSWData() async {
    Map<String, dynamic> jsondat = {"coaching_id": coachingID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    var res = await http.post(Uri.encodeFull(Constants().chooseBatchList),
        headers: headers, body: json.encode(jsondat));
    setState(() {
      batchList = json.decode(res.body);
    });
    return "Success";
  }

  void _openFileExplorer() async {
    setState(() {
      isLinkOpen = false;
    });
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);
        }
      } on Exception catch (e) {
        // print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }
}
