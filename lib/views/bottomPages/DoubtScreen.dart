import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subset/Admin/sendNotification.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/QuestionPojo.dart';
import 'package:subset/models/SubjectModel.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:subset/style/fonts.dart';
import 'package:subset/style/subset_doubt_icons.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/DoubtDetails.dart';
import 'package:subset/views/FirebaseMessagingService.dart';
import 'package:subset/views/helperViews/ImageHelper.dart';
import 'package:subset/views/helperViews/nointernet.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class DoubtSreen extends StatefulWidget {
  const DoubtSreen({Key key}) : super(key: key);

  @override
  _DoubtSreenState createState() => _DoubtSreenState();
}

class _DoubtSreenState extends State<DoubtSreen> {
  bool isActive = false;
  bool isLoading = true;
  bool isFound = false;
  String userID;
  String userUUID;
  String userType;
  bool isListFinish = false;
  int page = 1;
  String class_id;
  var questionList = List<QuestionPojo>();
  var subjectList = List<SubjectModel>();
  TextEditingController questionController = new TextEditingController();
  var uuid = Uuid();
  Map<String, String> _paths;
  List<File> images = new List();
  List<String> file = [];
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = true;
  bool _hasValidMime = false;
  FileType _pickingType;
  String _fileName;
  String _path;
  String _subjectID;
  String profileImage;
  String username;
  String coachingID;
  File _image;
  bool isSubmitting = false;
  ScrollController _scrollController = ScrollController();

  var myFormat = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    this._userid();
    super.initState();
    setState(() {
      isActive = false;
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isListFinish) {
          _loadMoreItems();
        }
      }
    });
  }

  _userid() async {
    String id = await SharedDatabase().getID();
    String uid = await SharedDatabase().getUID();
    String type = await SharedDatabase().getTypeID();
    String classid = await SharedDatabase().getClassID();
    String cid = await SharedDatabase().getCoachingID();
    String name = await SharedDatabase().getName();
    String img = await SharedDatabase().getImage();
    setState(() {
      userID = id;
      userUUID = uid;
      userType = type;
      class_id = classid;
      username = name;
      profileImage = img;
      coachingID = cid;
    });
    this.loadItems(page);
    this.getSubjectList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        title: new Text("Questions",
            style: new TextStyle(
                fontFamily: SubsetFonts().toolbarFonts,
                color: CustomColors.Colors.primaryColor)),
        actions: <Widget>[
          userType == 'S'
              ? IconButton(
                  tooltip: "Add Your Doubt",
                  onPressed: () {
                    _writeAnswerBottomSheet();
                  },
                  padding: EdgeInsets.all(12.0),
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: CustomColors.Colors.primaryColor,
                  ),
                )
              : Container(),
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context).push(
                    FadeRouteBuilder(page: SendNotification(coachingID, 2)));
              })
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isFound
              ? Center(
                  child: InkWell(
                      onTap: _refresh,
                      child: Text(
                        "Data not added yet\nadd your doubt for fresh start\nTap here to refresh"
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontFamily: SubsetFonts().notfoundFont),
                      )),
                )
              : _doubtList(context),
    );
  }

  _doubtList(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: questionList.length + 1,
          itemBuilder: (context, index) {
            if (index == questionList.length) {
              return isListFinish
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "No more data",
                        style:
                            TextStyle(fontFamily: SubsetFonts().notfoundFont),
                      ))
                  : Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15.0),
                      child: CupertinoActivityIndicator());
            }
            return InkWell(
              onTap: () {
                Navigator.of(context).push(FadeRouteBuilder(
                    page: DoubtDetails(questionList[index].id)));
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                bottom: 5.0,
                                top: 10.0),
                            child: CircleAvatar(
                              backgroundColor: CustomColors.Colors.primaryColor,
                              backgroundImage: NetworkImage(
                                  Constants().profileImage +
                                      questionList[index].image),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                questionList[index].name,
                                overflow: TextOverflow.fade,
                                style: new TextStyle(
                                    fontFamily: SubsetFonts().usernameFont,
                                    color: Colors.black,
                                    fontSize: 17.0),
                              ),
                              Text(
                                questionList[index].time,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: SubsetFonts().timeFont),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
                      child: Text(
                        questionList[index].question,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: new TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: SubsetFonts().titleFont),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 10, right: 10, bottom: 16.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5.0, right: 10.0),
                            child: Icon(
                              SubsetDoubt.thumbs_up,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text(questionList[index].likeCount),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Icon(
                              SubsetDoubt.thumbs_down,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text(questionList[index].dislikeCount),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.black54,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text(questionList[index].answerCount),
                          ),
                        ],
                      ),
                    ),
                    _spacer()
                  ],
                ),
              ),
            );
          },
        ),
        onRefresh: _refresh,
      ),
    );
  }

  _spacer() {
    return Container(
      color: Colors.black12,
      height: 6.0,
    );
  }

  _writeAnswerBottomSheet() {
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
              //-------OPEN CAMERA FOR TAKING IMAGE----------------------
              Future getImage() async {
                setStates(() {
                  _loadingPath = true;
                });
                var image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                setStates(() {
                  _image = image;
                  _path = null;
                  _paths = null;
                  _loadingPath = false;
                });
              }

              //-----OPEN FILE EXPLORER-----------------------------
              void _openFileExplorer() async {
                if (_pickingType != FileType.CUSTOM || _hasValidMime) {
                  setStates(() {
                    _loadingPath = true;
                  });
                  try {
                    if (_multiPick) {
                      _image = null;
                      _path = null;
                      _paths = await FilePicker.getMultiFilePath(
                          type: _pickingType, fileExtension: _extension);
                    } else {
                      _image = null;
                      _paths = null;
                      _path = await FilePicker.getFilePath(
                          type: _pickingType, fileExtension: _extension);
                    }
                  } on Exception catch (e) {}
                  if (!mounted) return;
                  setStates(() {
                    _loadingPath = false;
                    _fileName = _path != null
                        ? _path.split('/').last
                        : _paths != null ? _paths.keys.toString() : '...';
                  });
                }
              }

              return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Column(
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
                                Expanded(
                                  child: Text(""),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: 10.0, top: 5.0, bottom: 5.0),
                                  child: isSubmitting
                                      ? Container(
                                          child: SizedBox(
                                            height: 15.0,
                                            width: 15.0,
                                            child: Center(
                                              child:
                                                  new CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      : isActive
                                          ? FlatButton(
                                              color: Colors.white,
                                              onPressed: () async {
                                                if (_subjectID == null) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Please Select Subject",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIos: 1);
                                                } else {
                                                  if (_paths != null) {
                                                    setStates(() {
                                                      isSubmitting = true;
                                                    });
                                                    for (int i = 0;
                                                        i < _paths.length;
                                                        i++) {
                                                      //desiredQuality ranges from 0 to 100
                                                      List<int> imageBytesorg =
                                                          await ImageHelper()
                                                              .compressImage(
                                                                  images[i]
                                                                      .readAsBytesSync());

                                                      String imageorg =
                                                          base64Encode(
                                                              imageBytesorg);
                                                      setStates(() {
                                                        file.add(imageorg);
                                                      });
                                                    }
                                                  } else if (_image != null) {
                                                    setStates(() {
                                                      isSubmitting = true;
                                                      file.clear();
                                                    });
                                                    List<int> imageBytesorg =
                                                        await ImageHelper()
                                                            .compressImage(_image
                                                                .readAsBytesSync());

                                                    String imageorg =
                                                        base64Encode(
                                                            imageBytesorg);
                                                    setStates(() {
                                                      file.add(imageorg);
                                                    });
                                                  }

                                                  addQuestion(
                                                      questionController.text,
                                                      file);
                                                }
                                              },
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0)),
                                              //          alignment: Alignment.center,
                                              padding: EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10.0,
                                                  top: 5.0,
                                                  bottom: 5.0),
                                              //            width: MediaQuery.of(context).size.width,
                                              child: Text(
                                                "submit".toUpperCase(),
                                                style: new TextStyle(
                                                    color: CustomColors
                                                        .Colors.primaryColor,
                                                    fontSize: 12.0),
                                              ),
                                            )
                                          : Text(""),
                                )
                              ],
                            ),
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: CustomColors.Colors.primaryColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(19.0),
                                  topRight: Radius.circular(19.0)),
                            )),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                                child: Wrap(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 15.0,
                                      right: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        //         margin: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
                                        child: Text("Hello $username,",
                                            style: new TextStyle(
                                                fontSize: 20.0,
                                                fontFamily:
                                                    SubsetFonts().titleFont)),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: Text(
                                          "Please keep your question short and to the point. Check whether the question has been already asked.",
                                          style: new TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16.0,
                                              fontFamily:
                                                  SubsetFonts().titleFont),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 15.0, right: 15.0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "Please select subject ",
                                          style: new TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16.0,
                                              fontFamily:
                                                  SubsetFonts().titleFont),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        child: DropdownButton(
                                          hint: Text(
                                            "Select Subject",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          items: subjectList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(item.subjectName),
                                              value: item.subjectId.toString(),
                                            );
                                          }).toList(),
                                          onChanged: (newVal) {
                                            setStates(() {
                                              _subjectID = newVal;
                                            });
                                          },
                                          value: _subjectID,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                  ),
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 2,
                                    controller: questionController,
                                    autofocus: false,
                                    obscureText: false,
                                    onChanged: (String value) {
                                      if (value.length > 0) {
                                        setState(() {
                                          isActive = true;
                                        });
                                      } else {
                                        isActive = false;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: 'Write Your Question Here',
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Divider(),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                top: 15.0, bottom: 15.0),
                                            margin: EdgeInsets.only(
                                                left: 15.0, right: 10.0),
                                            child: Text(
                                              "Attach Image",
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 16.0,
                                                  fontFamily: "RobotoRegular"),
                                            )),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: IconButton(
                                            tooltip:
                                                "Insert Image from Gallery",
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
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        child: IconButton(
                                            tooltip: "Insert Image from Camera",
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              getImage();
                                            },
                                            padding: EdgeInsets.all(10),
                                            icon: Icon(
                                              Icons.camera_alt,
                                              color: Colors.black54,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Container(
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
                                                      itemCount: _paths !=
                                                                  null &&
                                                              _paths.isNotEmpty
                                                          ? _paths.length
                                                          : 1,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        final bool isMultiPath =
                                                            _paths != null &&
                                                                _paths
                                                                    .isNotEmpty;
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
                                                          margin:
                                                              EdgeInsets.all(
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
                                                : _image != null
                                                    ? Container(
                                                        padding: EdgeInsets.all(
                                                            15.0),
                                                        width: 120.0,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.black12,
                                                          backgroundImage:
                                                              FileImage(_image),
                                                        ),
                                                      )
                                                    : Container(),
                                  ),
                                ),
                                Container(
                                  height: 10.0,
                                )
                              ],
                            )),
                          ),
                        )
                      ],
                    ),
                  ));
            },
          );
        });
  }

  Future<bool> _loadMoreItems() async {
    setState(() {
      page++;
    });
    loadItems(page);
    return true;
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
      isFound = false;
    });
    questionList.clear();
    setState(() {
      page = 1;
    });
    loadItems(page);
  }

  void loadItems(int page) async {
    var tempList = List<QuestionPojo>();
    Map<String, dynamic> jsondat;
    String import;
    if (userType == 'T') {
      import = Constants().questionListTeacher;
      jsondat = {"page": page};
    } else {
      import = Constants().questionListStudent;
      jsondat = {"class_id": class_id, "page": page};
    }

    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      final response =
          await http.post(import, headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          tempList = (json.decode(response.body) as List)
              .map((data) => new QuestionPojo.fromJson(data))
              .toList();
          if (tempList.length > 0) {
            questionList.addAll(tempList);
            if (tempList.length < 10) {
              isListFinish = true;
            } else {
              isListFinish = false;
            }
            isListFinish = false;
            isLoading = false;
          } else {
            if (questionList.length > 0) {
              isLoading = false;
              isFound = false;
            } else {
              isLoading = false;
              isFound = true;
            }
            isListFinish = true;
          }
        });
      }
    } on SocketException {
      Navigator.of(context).push(FadeRouteBuilder(page: NoInternetScreen()));
    }
  }

  addQuestion(String question, List<String> questionImages) async {
    String import = Constants().addquestion;
    Map<String, dynamic> jsondat = {
      "question_id": uuid.v1().toString(),
      "question": question,
      "user_id": userID,
      "subject_id": _subjectID,
      "class_id": class_id,
      "files": questionImages
    };

    Map<String, String> headers = {"Content-Type": "application/json"};

    try {
      final response =
          await http.post(import, headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        if (!body['error']) {
          this._refresh();
          Navigator.pop(context);
          questionController.clear();
          String title = username + ' added new question';
          sendAndRetrieveMessage(title, question, '/topics/' + class_id);
        }
        setState(() {
          isSubmitting = false;
          isActive = false;
        });
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

  getSubjectList() async {
    Map<String, dynamic> jsondat = {"class_id": class_id};
    Map<String, String> headers = {"Content-Type": "application/json"};

    var res = await http.post(Uri.encodeFull(Constants().subjectList),
        headers: headers, body: json.encode(jsondat));
    setState(() {
      subjectList = (json.decode(res.body) as List)
          .map((data) => new SubjectModel.fromJson(data))
          .toList();
    });
  }
}
