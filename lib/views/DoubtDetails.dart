import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/AnswerPojo.dart';
import 'package:subset/models/DetailsModel/QuestionDetails.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/style/style.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/FirebaseMessagingService.dart';
import 'package:subset/views/fullImageView.dart';
import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:intl/intl.dart';
import 'package:subset/views/helperViews/ImageHelper.dart';
import 'package:uuid/uuid.dart';

class DoubtDetails extends StatefulWidget {
  final String question_id;
  DoubtDetails(this.question_id, {Key key}) : super(key: key);
  @override
  _DoubtDetailsState createState() => _DoubtDetailsState();
}

class _DoubtDetailsState extends State<DoubtDetails> {
  bool isActive = false;
  String userId;
  bool isLoading = false;
  bool isLiked = false;
  bool isDisliked = false;
  bool isUpdating = false;
  bool isListFinish = false;
  int page = 1;
  var questionDetails = List<QuestionDetails>();
  var answerList = List<AnswerPojo>();
  String userName;
  String userImage;
  var myFormat = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();
  var uuid = Uuid();
  TextEditingController _answerController = TextEditingController();
  TextEditingController _updateAnswer = TextEditingController();
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
  File _image;

  bool isSubmitting = false;
  ScrollController _scrollController = ScrollController();

  _data() async {
    String id = await SharedDatabase().getID();
    String name = await SharedDatabase().getName();
    String image = await SharedDatabase().getImage();

    setState(() {
      userId = id;
      userName = name;
      userImage = image;
    });
    this.loadData(widget.question_id, userId);
  }

  @override
  void initState() {
    super.initState();
    this._data();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.5,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : _details(),
    );
  }

  Widget _details() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _header(),
              questionDetails[0].files.length == 0 ? Container() : _files(),
              Style().spacer(),
              _writeAnswerContainer(),
              Style().spacer(),
              _comments()
            ],
          ),
        ),
      ],
    );
  }

  Widget _files() {
    return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 110.0,
              child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: questionDetails[0].files.length,
                itemBuilder: (context, index) => new Container(
                  alignment: Alignment.topCenter,
                  child: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            splashColor: Colors.red,
                            onTap: () {
                              Navigator.of(context).push(FadeRouteBuilder(
                                  page: ImageView(Constants().questionimage +
                                      questionDetails[0].files[index].url)));
                            },
                            child: Container(
                              width: 160.0,
                              height: 90.0,
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border:
                                    Border.all(width: 1.0, color: Colors.grey),
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(Constants()
                                            .questionimage +
                                        questionDetails[0].files[index].url)),
                              ),
                              //margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _header() {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(
              questionDetails[0].className.toUpperCase() +
                  "/" +
                  questionDetails[0].subjectName.toUpperCase(),
              style: new TextStyle(
                  color: CustomColors.Colors.primaryColor,
                  fontFamily: SubsetFonts().titleFont),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(
              questionDetails[0].question,
              style: new TextStyle(
                  fontSize: 20.0,
                  fontFamily: SubsetFonts().titleFont,
                  color: Colors.black),
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      Constants().profileImage + questionDetails[0].image),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          questionDetails[0].name,
                          style: new TextStyle(
                              fontSize: 17.0,
                              fontFamily: SubsetFonts().usernameFont),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          questionDetails[0].createdAt,
                          style: new TextStyle(
                              fontSize: 13.0,
                              color: Colors.black54,
                              fontFamily: SubsetFonts().timeFont,
                              fontStyle: FontStyle.normal),
                        ))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _writeAnswerBottomSheet(BuildContext contex) {
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
                } on Exception catch (e) {
                  //   print("Unsupported operation" + e.toString());
                }
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
                    child: SingleChildScrollView(
                  child: Wrap(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  padding: EdgeInsets.all(5.0),
                                  onPressed: () {
                                    setStates(() {
                                      _paths = null;
                                      _path = null;
                                      images.clear();
                                      _answerController.clear();
                                    });
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
                                              setStates(() {
                                                isSubmitting = true;
                                              });
                                              if (_paths != null) {
                                                for (int i = 0;
                                                    i < _paths.length;
                                                    i++) {
                                                  List<int> imageBytesorg =
                                                      await ImageHelper()
                                                          .compressImage(images[
                                                                  i]
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
                                                    base64Encode(imageBytesorg);
                                                setStates(() {
                                                  file.add(imageorg);
                                                });
                                              }

                                              addAnswer(
                                                  _answerController.text, file);
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
                                              "submit answer".toUpperCase(),
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
                      Container(
                        margin: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                        child: Text(
                          "Please read question carefully and answer relevantly.",
                          style: new TextStyle(
                              color: Colors.black87,
                              fontSize: 16.0,
                              fontFamily: SubsetFonts().titleFont),
                        ),
                      ),
                      Divider(),
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                        ),
                        child: TextField(
                          minLines: 1,
                          maxLines: 10,
                          autofocus: false,
                          obscureText: false,
                          controller: _answerController,
                          onChanged: (String value) {
                            if (value.length > 0) {
                              setStates(() {
                                isActive = true;
                              });
                            } else {
                              setStates(() {
                                isActive = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Write your answer here',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                                  padding:
                                      EdgeInsets.only(top: 15.0, bottom: 15.0),
                                  margin:
                                      EdgeInsets.only(left: 15.0, right: 10.0),
                                  child: Text(
                                    "Attach Answer Image",
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 16.0,
                                        fontFamily: "RobotoRegular"),
                                  )),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: IconButton(
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
                        //      width: MediaQuery.of(context).size.width,
                        height: 120.0,
                        child: new Builder(
                          builder: (BuildContext context) => _loadingPath
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: const CircularProgressIndicator())
                              : _path != null || _paths != null
                                  ? new Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 30.0),
                                      //        height: MediaQuery.of(context).size.height * 0.50,
                                      child: new Scrollbar(
                                          child: new ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            _paths != null && _paths.isNotEmpty
                                                ? _paths.length
                                                : 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final bool isMultiPath =
                                              _paths != null &&
                                                  _paths.isNotEmpty;
                                          final String name = 'File $index: ' +
                                              (isMultiPath
                                                  ? _paths.keys.toList()[index]
                                                  : _fileName ?? '...');
                                          final path = isMultiPath
                                              ? _paths.values
                                                  .toList()[index]
                                                  .toString()
                                              : _path;
                                          images.add(File(_paths.values
                                              .toList()[index]
                                              .toString()));
                                          return Container(
                                            margin: EdgeInsets.all(10.0),
                                            child: CircleAvatar(
                                              radius: 35.0,
                                              backgroundImage:
                                                  FileImage(File(path)),
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                new Divider(),
                                      )),
                                    )
                                  : _image != null
                                      ? Container(
                                          padding: EdgeInsets.all(15.0),
                                          width: 120.0,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black12,
                                            backgroundImage: FileImage(_image),
                                          ),
                                        )
                                      : Container(),
                        ),
                      ),
                      Container(
                        height: 10.0,
                      )
                    ],
                  ),
                )));
          },
        );
      },
    );
  }

  Widget _comments() {
    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Answers",
              style: new TextStyle(
                  fontFamily: SubsetFonts().titleFont,
                  fontSize: 16.0,
                  color: CustomColors.Colors.primaryColor),
            ),
          ),
          answerListPagination(context),
        ],
      ),
    );
  }

  answerListPagination(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: answerList.length + 1,
          itemBuilder: (context, index) {
            if (index == answerList.length) {
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
            return Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 30.0,
                        width: 30.0,
                        margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              Constants().profileImage +
                                  answerList[index].image),
                          backgroundColor: CustomColors.Colors.primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10.0, top: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      answerList[index].name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: new TextStyle(
                                          fontFamily:
                                              SubsetFonts().usernameFont,
                                          color: Colors.grey,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  Spacer(),
                                  this.userId == answerList[index].userID
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _updateAnswer.text =
                                                  answerList[index].answer;
                                            });
                                            smsCodeDialog(
                                                context, answerList[index]);
                                          },
                                          child: Container(
                                            child: Text(
                                              "Edit answer",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: new TextStyle(
                                                  fontFamily: "RobotoRegular",
                                                  color: Colors.blue,
                                                  fontSize: 10.0),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 3.0),
                                child: Text(
                                  answerList[index].answer,
                                  style: new TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontFamily:
                                          SubsetFonts().descriptionFont),
                                ),
                              ),
                              answerList[index].files.length == 0
                                  ? Container()
                                  : Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: 60.0,
                                            child: new ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: answerList[index]
                                                  .files
                                                  .length,
                                              itemBuilder: (context, indexs) =>
                                                  new Container(
                                                alignment: Alignment.topCenter,
                                                child: new Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        InkWell(
                                                          splashColor:
                                                              Colors.red,
                                                          onTap: () {
                                                            Navigator.of(context).push(FadeRouteBuilder(
                                                                page: ImageView(Constants()
                                                                        .answerimage +
                                                                    answerList[
                                                                            index]
                                                                        .files[
                                                                            indexs]
                                                                        .url)));
                                                          },
                                                          child: Container(
                                                            width: 80.0,
                                                            height: 45.0,
                                                            decoration:
                                                                new BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              border: Border.all(
                                                                  width: 1.0,
                                                                  color: Colors
                                                                      .grey),
                                                              image: new DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: new NetworkImage(Constants()
                                                                          .answerimage +
                                                                      answerList[
                                                                              index]
                                                                          .files[
                                                                              indexs]
                                                                          .url)),
                                                            ),
                                                            //margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 13.0),
                  height: 1.0,
                  color: Colors.black12,
                )
              ],
            );
          },
        ),
        onRefresh: _refresh,
      ),
    );
  }

  _writeAnswerContainer() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.thumb_up,
                color: isLiked ? CustomColors.Colors.primaryColor : Colors.grey,
              ),
              iconSize: 25.0,
              onPressed: () {
                if (isLiked) {
                  setState(() {
                    isLiked = false;
                    isDisliked = false;
                  });
                } else {
                  setState(() {
                    isLiked = true;
                    isDisliked = false;
                  });
                }

                sendLikeRequest(widget.question_id, userId, 1);
              },
              splashColor: CustomColors.Colors.primaryColor,
            ),
          ),
          Container(
            child: IconButton(
              icon: Icon(
                Icons.thumb_down,
                color:
                    isDisliked ? CustomColors.Colors.primaryColor : Colors.grey,
              ),
              iconSize: 25.0,
              onPressed: () {
                if (isDisliked) {
                  setState(() {
                    isLiked = false;
                    isDisliked = false;
                  });
                } else {
                  setState(() {
                    isLiked = false;
                    isDisliked = true;
                  });
                }
                sendLikeRequest(widget.question_id, userId, 0);
              },
              splashColor: CustomColors.Colors.primaryColor,
            ),
          ),
          Expanded(
            child: Text(""),
          ),
          Container(
            child: FlatButton(
              child: Text("Answer Now",
                  style: TextStyle(
                    color: CustomColors.Colors.primaryColor,
                  )),
              onPressed: () {
                _writeAnswerBottomSheet(context);
              },
            ),
          )
        ],
      ),
    );
  }

  loadData(String questionID, String userID) async {
    setState(() {
      isLoading = true;
    });
    String import = Constants().questionDetails;
    Map<String, dynamic> jsondat = {
      "question_id": questionID,
      "user_id": userID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response =
        await http.post(import, headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      setState(() {
        questionDetails = (json.decode(response.body) as List)
            .map((data) => new QuestionDetails.fromJson(data))
            .toList();
        isLoading = false;
        if (questionDetails[0].like == 1) {
          isLiked = true;
          isDisliked = false;
        }
        if (questionDetails[0].like == 0) {
          isDisliked = true;
          isLiked = false;
        }
      });
      this.loadItems(page);
    }
  }

  sendLikeRequest(String questionID, String userID, int value) async {
    String import = Constants().questionLike;
    Map<String, dynamic> jsondat = {
      "question_id": questionID,
      "user_id": userId,
      "value": value
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response =
        await http.post(import, headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      if (!body['error']) {
        String title = userName + ' react on your question';
        String descr;
        if (value == 1) {
          setState(() {
            descr = userName + ' upvote your question';
          });
        } else {
          setState(() {
            descr = userName + ' downvote your question';
          });
        }
        sendAndRetrieveMessage(title, descr, questionDetails[0].token);
        Fluttertoast.showToast(
            msg: "Submitted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1);
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
      isListFinish = false;
    });
    answerList.clear();
    setState(() {
      page = 1;
    });
    loadItems(page);
  }

  Future<bool> _loadMoreItems() async {
    setState(() {
      page++;
    });
    loadItems(page);
    return true;
  }

  void loadItems(int page) async {
    var tempList = List<AnswerPojo>();
    Map<String, dynamic> jsondat = {
      "question_id": widget.question_id,
      "page": page
    };
    String import = Constants().questionComments;

    Map<String, String> headers = {"Content-Type": "application/json"};
    final response =
        await http.post(import, headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      setState(() {
        tempList = (json.decode(response.body) as List)
            .map((data) => AnswerPojo.fromJson(data))
            .toList();
        if (tempList.length > 0) {
          answerList.addAll(tempList);
          if (tempList.length < 10) {
            isListFinish = true;
          } else {
            isListFinish = false;
          }
        } else {
          isListFinish = true;
        }
        isLoading = false;
      });
    }
  }

  addAnswer(String answer, List<String> stringFiles) async {
    String import = Constants().addanswer;
    Map<String, dynamic> jsondat;
    if (stringFiles.length > 0) {
      jsondat = {
        "answer_id": uuid.v1().toString(),
        "answer": answer,
        "user_id": userId,
        "question_id": widget.question_id,
        "files": stringFiles
      };
    } else {
      jsondat = {
        "answer_id": uuid.v1().toString(),
        "answer": answer,
        "user_id": userId,
        "question_id": widget.question_id,
        "files": false
      };
    }

    Map<String, String> headers = {"Content-Type": "application/json"};
    final response =
        await http.post(import, headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      if (!body['error']) {
        this._refresh();
        Navigator.pop(context);
        _paths = null;
        _path = null;
        images.clear();
        _answerController.clear();
        String title = 'Your question is answered by ' + userName;
        sendAndRetrieveMessage(title, answer, questionDetails[0].token);
      }
      setState(() {
        isActive = false;
        isSubmitting = false;
      });

      Fluttertoast.showToast(
          msg: body['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1);
    }
  }

  smsCodeDialog(BuildContext context, AnswerPojo answerPojo) {
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
                                      "MODIFY YOUR ANSWER HERE",
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
                                      controller: _updateAnswer,
                                      obscureText: false,
                                      onChanged: (String value) {},
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: 'Edit Comment',
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
                                        if (_updateAnswer.text.length > 0) {
                                          setBottomState(() {
                                            isUpdating = true;
                                          });
                                          _answerOperation(answerPojo.id);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Empty name",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIos: 1);
                                        }
                                      },
                                      color: CustomColors.Colors.primaryColor,
                                      child: Text(
                                        "UPDATE COMMENT",
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

  _answerOperation(String answerID) async {
    Map<String, dynamic> jsondat = {
      "anser_id": answerID,
      "answer": _updateAnswer.text.toString()
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.post(Constants().updateAnswer,
        headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (!body['error']) {
        _updateAnswer.clear();
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
}
