import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subset/anim/scale_anim.dart';
import 'package:subset/database/sharedPreferences.dart';
import 'package:subset/models/CommentPojo.dart';
import 'package:subset/models/DetailsModel/NoticeDetails.dart';
import 'package:subset/style/fonts.dart';
import 'package:subset/style/style.dart';
import 'package:subset/urls/allUrls.dart';
import 'package:subset/views/FirebaseMessagingService.dart';
import 'package:subset/views/fullImageView.dart';
import 'package:flutter/material.dart';
import 'package:subset/style/colors.dart' as CustomColors;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeDetails extends StatefulWidget {
  final String notice_id;
  HomeDetails(this.notice_id, {Key key}) : super(key: key);
  @override
  _HomeDetailsState createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {
  var detailsData = List<NoticeDetails>();
  bool isWrite = false;
  bool isLoading = true;
  bool isListFinish = false;
  String userID;
  String userType;
  String username;
  bool isUpdating = false;
  var commentList = List<CommentPojo>();
  int page = 1;
  TextEditingController updateComment = new TextEditingController();
  TextEditingController commentController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  _data() async {
    String id = await SharedDatabase().getID();
    String type = await SharedDatabase().getTypeID();
    String name = await SharedDatabase().getName();

    setState(() {
      userID = id;
      userType = type;
      username = name;
    });
    this.loadData(widget.notice_id, userID);
  }

  @override
  void initState() {
    this._data();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          _loadMoreItems();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 1,
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _details(),
      ),
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
              detailsData[0].files.length == 0 ? Container() : _files(),
              Style().spacer(),
              userType == 'A' ? Container() : _writeComments(),
              Style().spacer(),
              _comments(),
              homepageListPagination(context)
            ],
          ),
        ),
      ],
    );
  }

  Widget _files() {
    return detailsData[0].files[0].type.toString() == "L"
        ? Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: InkWell(
                onTap: () {
                  _launchURL(detailsData[0].files[0].url);
                },
                child: Text(
                  detailsData[0].files[0].url,
                  style: new TextStyle(color: Colors.blue, fontSize: 15.0),
                )),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 110.0,
                  child: new ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: detailsData[0].files.length,
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
                                      page: ImageView(Constants().noticeimage +
                                          detailsData[0].files[index].url)));
                                },
                                child: Container(
                                  width: 160.0,
                                  height: 90.0,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey),
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new NetworkImage(Constants()
                                                .noticeimage +
                                            detailsData[0].files[index].url)),
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
            child: detailsData[0].type == "N"
                ? Text(
                    "Notice for " + detailsData[0].batchName,
                    style: new TextStyle(
                        color: CustomColors.Colors.primaryColor,
                        fontFamily: SubsetFonts().titleFont),
                  )
                : Text(
                    "Assignment for " + detailsData[0].batchName,
                    style: new TextStyle(
                        color: CustomColors.Colors.primaryColor,
                        fontFamily: SubsetFonts().titleFont),
                  ),
          ),
          Container(
            child: Text(
              detailsData[0].title,
              style: new TextStyle(
                  fontSize: 20.0,
                  fontFamily: SubsetFonts().titleFont,
                  color: Colors.black),
            ),
          ),
          Divider(),
          Container(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      Constants().profileImage + detailsData[0].image),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          detailsData[0].name,
                          style: new TextStyle(
                              fontSize: 17.0,
                              fontFamily: SubsetFonts().usernameFont),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text(
                          detailsData[0].createdAt,
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
          Divider(),
          Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Text(
              detailsData[0].description,
              style: new TextStyle(
                  fontSize: 17.0,
                  fontFamily: SubsetFonts().descriptionFont,
                  color: Colors.black54),
            ),
          ),
          Divider(),
        ],
      ),
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
            child: Text(
              "Comments",
              style: new TextStyle(
                  fontFamily: SubsetFonts().titleFont,
                  fontSize: 16.0,
                  color: CustomColors.Colors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _writeComments() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              minLines: 1,
              controller: commentController,
              maxLines: 3,
              onChanged: (String value) {
                if (value.length > 0) {
                  setState(() {
                    isWrite = true;
                  });
                } else {
                  setState(() {
                    isWrite = false;
                  });
                }
              },
              cursorColor: CustomColors.Colors.primaryColor,
              decoration: InputDecoration(
                hintText: "Write comment here",
                hoverColor: CustomColors.Colors.white,
                fillColor: CustomColors.Colors.white,
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            child: isWrite
                ? IconButton(
                    onPressed: () {
                      addComment(commentController.text);
                    },
                    icon: Icon(Icons.send),
                  )
                : Text(""),
          )
        ],
      ),
    );
  }

  loadData(String noticeID, String userID) async {
    setState(() {
      isLoading = true;
    });
    if (userType == 'A') {
      userID = noticeID;
    }
    String import = Constants().noticeDetails;
    Map<String, dynamic> jsondat = {"notice_id": noticeID, "user_id": userID};
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response =
        await http.post(import, headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      setState(() {
        detailsData = (json.decode(response.body) as List)
            .map((data) => new NoticeDetails.fromJson(data))
            .toList();
        isLoading = false;
      });
      this.loadItems(page);
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  homepageListPagination(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: RefreshIndicator(
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: commentList.length + 1,
          itemBuilder: (context, index) {
            if (index == commentList.length) {
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
                          backgroundColor: CustomColors.Colors.primaryColor,
                          backgroundImage: NetworkImage(
                              Constants().profileImage +
                                  commentList[index].image),
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
                                      commentList[index].name,
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
                                  userID == commentList[index].userID
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              updateComment.text =
                                                  commentList[index].comment;
                                            });
                                            smsCodeDialog(
                                                context, commentList[index]);
                                          },
                                          child: Container(
                                            child: Text(
                                              "Edit comment",
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
                                margin: EdgeInsets.only(right: 20.0),
                                child: Text(
                                  commentList[index].comment,
                                  style: new TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontFamily:
                                          SubsetFonts().descriptionFont),
                                ),
                              ),
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
      isListFinish = false;
    });
    commentList.clear();
    setState(() {
      page = 1;
    });
    loadItems(page);
  }

  loadItems(int page) async {
    var tempList = List<CommentPojo>();
    Map<String, dynamic> jsondat = {
      "notice_id": widget.notice_id,
      "page": page
    };
    String import = Constants().noticeComments;

    Map<String, String> headers = {"Content-Type": "application/json"};
    final response =
        await http.post(import, headers: headers, body: json.encode(jsondat));

    if (response.statusCode == 200) {
      setState(() {
        tempList = (json.decode(response.body) as List)
            .map((data) => CommentPojo.fromJson(data))
            .toList();
        if (tempList.length > 0) {
          commentList.addAll(tempList);
          if (tempList.length < 2) {
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

  addComment(String comment) async {
    String import = Constants().addcomment;
    Map<String, dynamic> jsondat = {
      "notice_id": widget.notice_id,
      "comment": comment,
      "user_id": userID
    };
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response =
        await http.post(import, headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      if (!body['error']) {
        commentController.clear();
        this._refresh();

        String title = username + ' comment on your post';
        sendAndRetrieveMessage(title, comment, detailsData[0].token);
      }
      Fluttertoast.showToast(
          msg: body['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1);
    }
  }

  _commentOperation(int type, String commmentID) async {
    Map<String, dynamic> jsondat;
    String url;
    if (type == 1) {
      url = Constants().updateComment;
      jsondat = {
        "comment_id": commmentID,
        "comment": updateComment.text.toString()
      };
    } else if (type == 0) {
      url = Constants().deleteComment;
      jsondat = {"comment_id": commmentID, "user_id": userID.toString()};
    }
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (!body['error']) {
        updateComment.clear();
        Navigator.of(context).pop();
        _refresh();
      }
      setState(() {
        isUpdating = false;
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: body['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1);
    }
  }

  smsCodeDialog(BuildContext context, CommentPojo commentPojo) {
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
                              Spacer(),
                              isUpdating
                                  ? Container()
                                  : Container(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setBottomState(() {
                                            isUpdating = true;
                                          });
                                          _commentOperation(0, commentPojo.id);
                                        },
                                      ),
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
                                      "MODIFY YOUR COMMENT HERE",
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
                                      controller: updateComment,
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
                                        if (updateComment.text.length > 0) {
                                          setBottomState(() {
                                            isUpdating = true;
                                          });
                                          _commentOperation(1, commentPojo.id);
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
}
